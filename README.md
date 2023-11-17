This repository hosts the code for my website [gurjeet.singh.im][gurjeet].

Currently this repository uses GitHub Pages to publish the website as well as
the blog posts.

[gurjeet]: gurjeet.singh.im

Blog
====

The Blog posts are under the `blog/_posts` directory.  The files `Gemfile` and
`_config.yml` are used by the GitHub/Jekyll infrastructure to generate the blog
pages.

Creating New Post
-----------------

Ideally you should first create a new draft, work on it, commit it etc. but not
publish it until it's finished.

To create a new draft, use the following command. It creates a new template file
under `blob/_drafts` directory.

    ./create_draft.sh "New Post Title"

For your convenience, the newly created draft post is also added to the Git
staging area.

Feel free to commit your in-progress/draft posts to the Git repository, since
the Jekyll infrastructure will NOT publish the contents stored under
`blog/_drafts` folder.

After you're satisfied with the draft, you can move it under the `blog/_posts`
directory, and Jekyll will publish that post in the Blog.

Testing/Rendering Locally
-------------------------

To test the Jekyll site generation locally, use the following commands:

    bundle install
    bundle exec jekyll serve --drafts --watch --livereload

The `--drafts` flag ensures that the posts in `blog/_drafts` directory are also
published, which are not published in production mode.

The `--livereload` flag ensures that the browser automatically refreshes to show
you the most up-to-date content, as and when you modify your posts and drafts.

The `--watch` flag seems to be  unecessary when using the `-livereload` flag.
But we use it nonetheless to make our intent explicit that we wish to rebuild
the posts and drafts as and when they get updated.

Maintenance
----------

To ensure that you use the same versions of packages as used by GitHub pages,
update the package versions in `Gemfile` to match the versions published by
GitHub on this [HTML][GitHub Jekyll Versions] or [JSON][GitHub Jekyll Versions
JSON] pages.

[GitHub Jekyll Versions]: https://pages.github.com/versions/
[GitHub Jekyll Versions JSON]: https://pages.github.com/versions.json

