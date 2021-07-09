---
layout: post
title:  "Postgres turns 25 years old today (or is it 35?)"
date:   2021-07-08 19:41:59 -0700
categories: [postgres, foss]
---

When was Postgres born?
=======================

It is very difficult to pin down the date when Postgres (a.k.a PostgreSQL)
project was born. If you look at the [official history][history] on the Postgres
website, you'd see a few years mentioned, as early as the year 1986, but no
specific dates.

Unofficial Birth Timestamp of Postgres
======================================

If we go by the timestamp of the [first commit][first_commit] in Postgres code
repository, the project was started at 'Tue Jul 9 06:22:35 1996 +0000'. Going by
that date, today the Postgres project turns 25 years old.

    $ psql -c "select age(now(), 'Tue Jul 9 06:22:35 1996 +0000')"
                       age
    ------------------------------------------
     24 years 11 mons 30 days 22:39:46.830704
    (1 row)

Oh, it's so close...

<div class="tenor-gif-embed" data-postid="14490824" data-share-method="host" data-width="50%" data-aspect-ratio="0.8955823293172691"><a href="https://tenor.com/view/excited-party-dance-puppy-gif-14490824">Excited Party GIF</a> from <a href="https://tenor.com/search/excited-gifs">Excited GIFs</a></div>

<br>
Don't be like this

<div class="tenor-gif-embed" data-postid="13182748" data-share-method="host" data-width="50%" data-aspect-ratio="1.7913669064748199"><a href="https://tenor.com/view/duck-dynasty-reality-tv-getting-old-birthday-not-excited-gif-13182748">Duck Dynasty Reality TV GIF</a> from <a href="https://tenor.com/search/duckdynasty-gifs">Duckdynasty GIFs</a></div>

<script type="text/javascript" async src="https://tenor.com/embed.js"></script>

Future
======

If you haven't been following the progress of the Postgres project, I implore
you to do so now (see below). The future of the Postgres project is very bright.
Its feature set has been growing steadily, while retaining its legendary
commitment to stability and correctness.

Follow Postgres
===============

We have these awesome [contributors][], and many others who are not listed
there, to thank for the current state of their projects, and their tireless
work.

These contributors, and many others, blog regularly about what's happening in
the Postgres world, and those blog posts are aggregated at [Planet
Postgres][planet]. Feel free to subscribe to any of the many RSS feeds there
(even by an author you may be interested in).

Here are many other channels to engage with Postgres community:

- Twitter: [@PostgreSQL](https://twitter.com/PostgreSQL), and [@PlanetPostgres](https://twitter.com/planetpostgres)
- [Mailing Lists](https://www.postgresql.org/list/)
- [IRC](https://www.postgresql.org/community/irc/)
- [LinkedIn](https://www.linkedin.com/company/postgresql-global-development-group/mycompany/)

[history]: https://www.postgresql.org/docs/current/history.html

[first_commit]: https://git.postgresql.org/gitweb/?p=postgresql.git;a=commit;h=d31084e9d1118b25fd16580d9d8c2924b5740dff

[contributors]: https://www.postgresql.org/community/contributors/

[planet]: https://planet.postgresql.org/

