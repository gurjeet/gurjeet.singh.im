---
layout: post
title:  "No Golang For You"
date:   2021-01-02 04:08:00 -0800
categories: Golang
---

The blog post ["I want off Mr. Golang's Wild Ride"][Amos Post] by Amos incited
me to write a comment on its [HN][] submission page. But as the comment ran 5
paragraphs long, I have turned it into this blog post.

[Amos Post]: https://fasterthanli.me/articles/i-want-off-mr-golangs-wild-ride
[HN]: https://news.ycombinator.com/item?id=25616593

It is a well written and in-depth look at the rot inside the Golang ecosystem.
Make sure to read to the end and notice that the rot started at the core
contributors level.

Golang's tagline, from their [repository][0], is "Go is an open source
programming language that makes it easy to build simple, reliable, and efficient
software."

Reading this post by Amos should make it clear to you that Golang has succeeded
ONLY in the "simple" part of the claim; unless written with extreme care,
programs written in Golang are neither reliable, nor efficient.

Amos presents some examples of why I have disliked Golang since the beginning.
After having used Golang for a few years seriously, I disliked it enough to
start a fork of the language named [GoFY][1]. I named the language as such
because, since the beginning when I saw some of initial presentations by Rob
Pike specifically, and some others' presentations and blog posts generally, they
had an air of ego when dismissing others' opinions and concerns, and appeared to
say "these are our decisions, that is how it is, and if you don't like it, Go
F*** Yourself". So the project name was a GoFY to them back, from me.

I'm sure it looks a great language from afar, and for newcomers. But as a
seasoned developer who has seen a few other languages in thier lifetime, you
will quickly begin to see the problems with the language and the ecosystem
around it.  The astute among you may notice that in my [post yesterday][] I
did not claim to be an expert in Golang; it's hard to be an expert in something
that's fragile, flaky and full of special cases. For the same reason I
never took up using MySQL; I have heard enough stories of its flakiness and
special cases that it never looked like a solid technology to me. I openly and
whole-heartedly recommend learning and using [Postgres][] to anyone who would
listen.

[post yesterday]: https://gurjeet.singh.im/blog/persistence-perseverance
[Postgres]: https://www.postgresql.org

Fortunately I did not invest any more time in it other than to document a few
times in section ["GoFY Desired Differences"][differences] as to what I would
like to see different in the GoFY language, which in turn would make it better
than Golang, at least for long-time systems developers like myself. I am glad I
didn't burn any oil on it because creating a new language, even a fork, is
neither easy nor quick.

[0]: https://github.com/golang/go
[1]: https://github.com/gurjeet/gofy/tree/gofy
[differences]: https://github.com/gurjeet/gofy/tree/gofy#gofy-desired-differences

