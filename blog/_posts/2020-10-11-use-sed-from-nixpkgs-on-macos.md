---
layout: post
title:  "Install sed, grep from nixpkgs on macOS"
date:   2020-10-11 20:34:00 -0800
categories: macOS, NixOS, nixpkgs
---

## TL;DR

    nix-env -i gnused gnugrep

## Problem

The `sed` and `grep` available on macOS do not provide extended features
generally available on Linux systems. When you rely on such features in your
shell scripts running on macOS, you need to have GNU versions of these commands
installed. 

## Solution

If you're using Nix on macOS, you can use the above command to
install the GNU's versions of `sed` and `grep`.

