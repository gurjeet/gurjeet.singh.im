---
layout: post
title:  "Postgres Ordering Data Type - A Failed Experiment"
date:   2023-05-17 17:50:08 -0700
categories: Postgres, Data type, experiment
---

I'm publishing this failed experiment in the spirit of the [most famous failed
experiment][]. We should be more open about our failed attempts.

[most famous failed experiment]: https://en.wikipedia.org/wiki/Michelson%E2%80%93Morley_experiment

This started as a disucssion on HackerNews as a [feature request][], where
danielheath asked for a Postgres data type that, when used as a column in a
table, would allow the user to simply assign a desired position to an item/row
in the list, and the system (Postgres, in this case) would do the necessary
moving of all the items in the list to ensure that the item/row is assigned that
position in the list.

[feature request]: https://news.ycombinator.com/item?id=34565332

The concrete example they used was of managing a playlist, where the user wants
a song to be moved to position N, say 3. This feature would allow the
programmer/developer to not worry about rearranging the other items in the list,
and simply assign the desired position to the item. And when retrieving the
results, the item should show up at the assigned position.

At the time I [proposed a solution][], as did others, but it wasn't clear that
any of the proposed solutions were close to the actual request. I kept thinking
of ways to implement it, and a few days later I came up with a way to achieve
the desired effect; or at least I thought it was _the_ solution. So this last
weekend I attempted to code it up using plain SQL, with the hopes that if it
succeeded, I might be able to propose such a feature to be included in Postgres
project.

[proposed a solution]: https://news.ycombinator.com/item?id=34565522

Below you can see the code for the solution I had come up with. The core idea is
to assign actual positons at runtime, and when an update request arrives, use
the requested position, plus the current timestamp, to assgin a value that'll be
used to sort results.

The solution seems to work, but not for long. As you can see towards the end,
that this solution fails to set the position of the 'Song B' to 3 under one of
the conditions. The problem with this solution, and any others that may be
proposed, is that that we need a sorted list of elements before we can place an
item at some desired position in that list. You can see I tried to code up that
in `set_song_position_v2()` function at the end. The `_v2` function is not
complete, but even if it were complete and handled all the corner cases, I would
not call it a solution to the feature that was requested. The correct solution
has to use a _sorted_ list to begin with, and that is a non-starter, because the
feature request was to simply set the desired position, and not have to do any
work.

To state simply, it's the same problem as trying to get the `max()` value of a
column without trying to maintain an index that contains all the rows.

```sql
/*
 * The playlists table holds all the playlists, and the songs in those
 * playlists. This table is denormalized, and it does not have any indexes, to
 * keep the code simple and readable.
 *
 * The position_ts column records the timestamp when the operation occurred.
 * This column is then used to resolve conflicts when the song_position of 2
 * or more songs is the same.
 */
create table playlists(
    playlist_name text,
    song_name text,
    song_position integer,
    position_ts timestamptz default clock_timestamp()
);
> CREATE TABLE

create or replace function update_playlist_position_ts()
    returns trigger as
    $$
    begin
        new.position_ts = clock_timestamp();
        return new;
    end;
    $$ language plpgsql;
> CREATE FUNCTION

create or replace trigger update_position_ts
    before update of song_position on playlists
    for each row
    execute function update_playlist_position_ts();
> CREATE TRIGGER

create or replace view playlists_numbered as
    select  row_number() over (partition by playlist_name order by song_position asc, position_ts desc) as position,
            playlist_name,
            song_name
    from   (select  playlist_name,
                    song_name,
                    song_position,
                    position_ts
            from    playlists);
> CREATE VIEW

-- Simpler view definition with similar (but not the same) results as the
-- playlists_numbered view.
create or replace view playlists_ordered as
    select  row_number() over () as position, *
    from   (select  playlist_name,
                    song_name
            from    playlists
            order by
                    playlist_name,
                    song_position asc,
                    position_ts desc);
> CREATE VIEW

-- Set the position of a song within a playlist
create or replace function set_song_position(playlist text, song text, new_position int)
returns void as
$$
    -- Simply set the 'song_positon' to the desired value; the
    -- trigger and the View will do the rest to actually show
    -- this song at a position relative to other songs within
    -- the playlist.
    --
    -- TODO: should it throw error if song is not already in the
    -- playlist?
    update      playlists
        set     song_position = $3
        where   playlist_name = $1
        and     song_name = $2;
$$
language sql;
> CREATE FUNCTION

insert into playlists values
    ('Playlist A', 'Song A', 1),
    ('Playlist A', 'Song B', 2),
    ('Playlist A', 'Song C', 3),
    ('Playlist B', 'Song X', 1),
    ('Playlist B', 'Song Y', 2);
> INSERT 0 5

select * from playlists_numbered;
>  position | playlist_name | song_name
> ----------+---------------+-----------
>         1 | Playlist A    | Song A
>         2 | Playlist A    | Song B
>         3 | Playlist A    | Song C
>         1 | Playlist B    | Song X
>         2 | Playlist B    | Song Y
> (5 rows)

select set_song_position('Playlist A', 'Song C', 2);
>  set_song_position
> -------------------
> 
> (1 row)

select * from playlists_numbered
    where playlist_name = 'Playlist A';
>  position | playlist_name | song_name
> ----------+---------------+-----------
>         1 | Playlist A    | Song A
>         2 | Playlist A    | Song C
>         3 | Playlist A    | Song B
> (3 rows)

select set_song_position('Playlist A', 'Song B', 1);
>  set_song_position
> -------------------
> 
> (1 row)

select * from playlists_numbered
    where playlist_name = 'Playlist A';
>  position | playlist_name | song_name
> ----------+---------------+-----------
>         1 | Playlist A    | Song B
>         2 | Playlist A    | Song A
>         3 | Playlist A    | Song C
> (3 rows)

-- Setting a song position to a value more than the number of
-- songs will place the song last.
select set_song_position('Playlist A', 'Song A', 99);
>  set_song_position
> -------------------
> 
> (1 row)

select * from playlists_numbered
    where playlist_name = 'Playlist A';
>  position | playlist_name | song_name
> ----------+---------------+-----------
>         1 | Playlist A    | Song B
>         2 | Playlist A    | Song C
>         3 | Playlist A    | Song A
> (3 rows)

-- Inserting a new song at an in-between position places the new
-- song before the song at position 99.
insert into playlists values('Playlist A', 'Song D', 4);
> INSERT 0 1

select * from playlists_numbered
    where playlist_name = 'Playlist A';
>  position | playlist_name | song_name
> ----------+---------------+-----------
>         1 | Playlist A    | Song B
>         2 | Playlist A    | Song C
>         3 | Playlist A    | Song D
>         4 | Playlist A    | Song A
> (4 rows)

-- This fails. We want Song B to be at position 3, but the
-- result shows that Song D shows up at position 3.
select set_song_position('Playlist A', 'Song B', 3);
>  set_song_position
> -------------------
> 
> (1 row)

select * from playlists_numbered
    where playlist_name = 'Playlist A';
>  position | playlist_name | song_name
> ----------+---------------+-----------
>         1 | Playlist A    | Song C
>         2 | Playlist A    | Song B
>         3 | Playlist A    | Song D
>         4 | Playlist A    | Song A
> (4 rows)

create or replace function set_song_position_v2(p_playlist text, p_song text, p_position int)
returns void as
$$
declare
    pos int := 0;
begin
    pos := (
        select  coalesce(min(song_position), p_position) as pos from (
            select  row_number() over (partition by playlist_name order by song_position asc, position_ts desc) as position,
                    playlist_name,
                    song_name,
                    song_position
            from   (select  playlist_name,
                            song_name,
                            song_position,
                            position_ts
                    from    playlists
                    where   playlist_name = p_playlist
                    and     song_name <> p_song -- exclude the song we're manipulating
                   ))
        where position >= p_position
    );

    raise notice 'Position is %', pos;

    update  playlists
    set     song_position = pos
    where   playlist_name = p_playlist
    and     song_name = p_song;
end;
$$ language plpgsql;
> CREATE FUNCTION

-- Clean up
drop table playlists cascade; -- cascade drops views of the table
psql:playlists.sql:133: NOTICE:  drop cascades to 2 other objects
DETAIL:  drop cascades to view playlists_numbered
drop cascades to view playlists_ordered
> DROP TABLE

drop function update_playlist_position_ts();
> DROP FUNCTION

drop function set_song_position(text, text, int);
> DROP FUNCTION

drop function set_song_position_v2(text, text, int);
> DROP FUNCTION

```
