---
layout: post
title:  "Use TouchID With sudo on macOS"
date:   2019-02-26 08:12:00 -0800
categories: [ Apple, macOS, sudo ]
---

On recent macOS laptops that have TouchID feature you can easily use your
fingerprint to authenticate with `sudo`, instead of having to type in your
passcode.	

Edit the `/etc/pam.d/sudo` and add the line `auth       sufficient     pam_tid.so`
to that file at the beginning.

Use the following command to edit this file.

    sudo vi /etc/pam.d/sudo

After this edit, your file may look like the following:

    # sudo: auth account password session
    auth       sufficient     pam_tid.so # This line allows TouchID to authenticate for sudo commands
    auth       sufficient     pam_smartcard.so
    auth       required       pam_opendirectory.so
    account    required       pam_permit.so
    password   required       pam_deny.so
    session    required       pam_permit.so


