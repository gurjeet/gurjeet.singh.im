---
layout: post
title:  "Find Large Files to Delete"
date:   2030-05-23 16:27:00 -0800
categories: Linux
---

## TL;DR

    find . -path ./Trash -prune -o -type f -o -type d -print0 | xargs -0 -n1 du -ms | sort -g

## Problem

Often we are faced with the situation of running out of disk storage, and we
have to quickly find some large files to delete to free up the storage as soon
as possible.

### Update (2020/05/25)

Someone on [Hacker News][] pointed me to [ncdu][], which helps with the same
problem, and is much more advanced than my clunky one-liner.

[Hacker News]: https://news.ycombinator.com/item?id=23287682
[ncdu]: https://en.wikipedia.org/wiki/Ncdu

## Other Solutions

When faced with this situation on Windows OS, I immediately turn to
[WinDirStat][] to visualize the storage consumed by various files and
directories, so that I can quickly delete them and free up some space and get on
with my life.

[WinDirStat]: https://windirstat.net/

## CLI Solution

Bus since I use Linux, macOS, or some other variant of Unix OS nowadays, I came
up with the following quick and dirty command to find and delete large files or
directories.

Note that I have a directory named `Trash` that I move files to, before finally
deleting them for good. Hence I exclude this directory from my search.

    find ./ -path ./Trash -prune -o -type f -o -type d -print0 | xargs -0 -n1 du -ms | sort -g

This command emits a sorted list of largest files and directories under the
currrent active directory.
