#!/usr/bin/env bash

set -o noclobber  # refuse to overwrite an existing file
set -e  # bail out on error

TITLE="$1"

[[ -z "$TITLE" ]] \
    && echo "ERROR: Specify a title for the post" >&2 \
    && exit 1

[[ "$(echo "$TITLE" | wc -l )" != "1" ]] \
    && echo "ERROR: Title must be one line" >&2 \
    && exit 2

TITLE_LOWER_CASE=$( echo "$TITLE" | tr '[:upper:]' '[:lower:]')
TITLE_LC_WITH_DASHES=$(echo "$TITLE_LOWER_CASE" | sed 's/ /-/g')
FILE_NAME=$(date "+%Y-%m-%d-${TITLE_LC_WITH_DASHES}.md")
FILE_PATH="blog/_drafts/$FILE_NAME"

cat << EOF > "$FILE_PATH"
---
layout: post
title:  "${TITLE}"
date:   $(date "+%Y-%m-%d %H:%M:%S %z")
categories: Comma, Separated, Categories, Go, Here
---

==== THIS IS A DRAFT ====

Write your markdown here.
EOF

git add "$FILE_PATH"
