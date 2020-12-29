---
layout: post
title:  "How to Remove a Postgres User's Password"
date:   2020-12-28 23:01:00 -0800
categories: Postgres, Password, Security
---

Sometimes you may want to remove a Postgres user's password altogether. You may
want to do this to, say, keep the user metadata but disallow her to login. In my
case I had a user with password but I wanted it to login without a password, and
force myself to use an alternate mechanism for authentication.

The followind SQL command will remove the user's password; this is similar to
how you would remove a Linux/Unix user's password with `passwd -d username`.

    ALTER USER username PASSWORD NULL;


