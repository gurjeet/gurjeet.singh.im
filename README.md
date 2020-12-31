This repository hosts the code for my website [gurjeet.singh.im][gurjeet].

[gurjeet]: gurjeet.singh.im

Blog
====

The Blog posts are under the `blog/_posts` directory. Currently this repository
uses GitHub Pages to publish the website as well as the blog posts.

The files `Gemfile` and `_config.yml` are used by the GitHub/Jekyll
infrastructure to generate the blog pages. To test the Jekyll site generation
locally, use the following commands:

    bundle install
    bundle exec jekyll serve

To ensure that you use the same versions of packages as used by GitHub pages,
update the package versions in `Gemfile` to match the versions published by
GitHub on this [HTML][GitHub Jekyll Versions] or [JSON][GitHub Jekyll Versions
JSON] pages.

[GitHub Jekyll Versions]: https://pages.github.com/versions/
[GitHub Jekyll Versions JSON]: https://pages.github.com/versions.json

