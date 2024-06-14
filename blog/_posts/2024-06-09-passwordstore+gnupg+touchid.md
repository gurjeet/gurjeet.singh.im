---
layout: post
title:  "PasswordStore + GnuPG + TouchID"
date:   2024-06-09 13:33:22 -0700
categories: pass, password store, touchid, VPN, encryption
---

Local, Secure, Convenient, Shareable Password Management with GPG, Git, and TouchID
===================================================================================

Open Source security tools abound, but common people don't use them becuase
these tools cause inconvenience. If you give an average person a choice between
security and conveninence, they'll always end up choosing convenience.

If you have done the right thing and set a strong password to protect your GPG
keys, unlocking GPG keys requires entering the (loooo...ng) password every time
you want to unlock the private key. And because that is very inconvenient, an
average person will choose to not use GPG keys. I am a prime example of this;
everytime I tried to use GPG for something in past, after dedicating significant
time to setting it up, I used to end up not using it because of the complexity,
inconvenience, and never being sure if I'm doing the right thing in terms of
security posture.

We'll see how one can store their passwords locally, in encrypted form, and
protect those passwords with a GPG key. And to make it all extremely convenient
to use, the password used to protect the GPG private key is protected by a mere
touch of TouchID, so you won't have to tediously type your long passwords.

Below I will show how to use [PasswordStore][] [CLI][] (a.k.a `pass`) to
securely store all your passwords locally, and protect them with TouchID. In
essence, your TouchID will protect the GPG key passwords (stored in the macOS
login Keychain), which in turn will protect the GPG private key, which in turn
will protect the passwords stored in PasswordStore.

[PasswordStore]: https://www.passwordstore.org/
[CLI]: https://en.wikipedia.org/wiki/Command-line_interface

My use case was that I wanted to automate connection and reconnection of my VPN,
but did not want to be bothered to provide the long cryptic password every time.
Upon searching for TouchID-based soutions, I came across this [blog][] post
which mentioned that `pinentry-touchid` can be used for this purpose, but the
post did not have much details on installation and configuration of the tools. I
spent significant amount of time in understanding and configuring these
utilities, so I thought of documenting the precise instructions for others to
use.

[blog]: https://blog.urbansedlar.com/archives/49880

With the implementation shown below, now whenever my scripts want to access the
VPN password, or any other secret stored in my PasswordStore, I get prompted
with the TouchID to unlock their access. As an added bonus, if you choose to,
the encrypted passwords can be managed in, and shared using [Git][].

[Git]: https://git-scm.com/

Hopefully the below instructions and explanation will make it convenient for
you to make use of GPG and PasswordStore.

```shell
# Install the packages using Homebrew
brew install gnupg
brew install pinentry
brew install pinentry-mac
brew install pass
brew tap jorgelbg/tap
brew install pinentry-touchid

# Perform a check to see if `pinentry-mac` is the default pinentry
# mechanism.
pinentry-touchid -check

# Expect to see a failure output as shown below.
#
# ❌ /opt/homebrew/opt/pinentry/bin/pinentry is a symlink that resolves to
# /opt/homebrew/Cellar/pinentry/1.3.0/bin/pinentry-curses not to pinentry-mac

# By default, `pinentry` is a link to `pinentry-ncurses`. The following command
# will make the link point to `pinentry-mac`. Thereafter, `pinentry-mac` will
# become the default program that gpg-agent will use to unlock the GPG keys.
# 
# If you ever _reinstall_ gpg package, the link will be reset back to point to
# `pinentry-ncurses`. You should run `pinentry-touchid -check` to see if it
# succeeds, and run it with `-fix` option, like below, to fix the link, if
# needed.
pinentry-touchid -fix

# Perform the check again. This time it should pass.
pinentry-touchid -check

# Generate a new private+public keypair.
#
# If unsure of which of the choices to pick, accept the defaults indicated in
# the options shown by gpg. When asked for a password to ptorect the private
# key, use a very strong password; the private key being generated will protect
# all your passwords, so make sure it's not easy to guess the password that
# protects it.
#
# To fully understand how to manage and backup your GPG keys, please read the
# 'GPG Keys Management' section in Fedora documentation linked below.
#
# https://docs.fedoraproject.org/en-US/quick-docs/create-gpg-keys/
# 
# If you already have a private+public keypair, you can use that instead of
# creating a new one. In that case, skip this command.
gpg --full-generate-key

# Note the KeyID of the key you created above, or the one you want to use. For
# example, in the following output, 0xDA0564F36822B15B on the first line is the
# KeyID.
#
# pub   ed25519/0xDA0564F36822B15B 2024-06-08 [SC] [expires: 2025-06-08]
#       Key fingerprint = FFD9 2569 B7A2 D3B5 9EAD  4BC4 DA05 64F3 6822 B15B
# uid                   [ultimate] John Doe (GPG key for Work) <john.doe@expmple.com>
# sub   cv25519/0xB08D23EF71423D97 2024-06-08 [E] [expires: 2025-06-08]
gpg --list-keys --fingerprint --keyid-format 0xlong

# Initialize PasswordStore's storage, `~/.passsword-store/`, replacing $KEYID
# with the KeyID of the key you generated or chose above.
pass init $KEY_ID

# (Optional) Have PasswordStore track and log password changes in a Git
# repository. If you choose to do this, every addition or removal of a password
# in the PasswordStore will create a Git commit in the Git repository stored at
# `~/.password-store/`.
pass git init

# Tell `pinentry-mac` (a product of GPGTools) to not store the passwords it
# decrypts in the Keychain.
#
# Instead, `pinentry-touchid` will perform the storage operations on the
# Keychain, hence it will be treated as the owner of the values it stores in
# Keychain.  Which means `pinentry-touchid` can then read these values from
# Keychain without triggering a macOS password prompt to the user.
defaults write org.gpgtools.common DisableKeychain -bool yes

# Set `pinentry-touchid` as the default pinentry-program in `gpg-agent`'s config
# file.
echo "pinentry-program $(which pinentry-touchid)" >> ~/.gnupg/gpg-agent.conf

# Tell `gpg-agent` to reload the config file changes made above.
gpg-connect-agent reloadagent /bye

# Check that encryption works.
#
# You will _not_ be prompted for the password to unlock the GPG private key.
# Encryption of the secrets/passwords does not require private key. This step
# uses your public key, which is not protected, to perform the encryption.
#
# Create a test password and store it in PasswordStore. 
pass insert VPNpassword

# Retrieve the value of VPNpassword. You will now be prompted to provide the
# password to unlock the private key.
#
# This should display a dialog box (created by `pinentry-touchid`) asking for
# the password to unlock your GPG private key; provide the password you used in
# `gpg --full-generate-key` step.
# 
# If your provided password successfully unlocks the private key, then your
# password will be stored in the macOS' Keychain. To verify this, in the
# 'KeyChain Access' app, under 'login' Keychain, search for 'GnuPG'.
# 
# Because this entry in the login Kaychain is created by the `pinentry-touchid`
# program, `pinentry-touchid` is always allowed to read its value. To verify
# this, open 'Keychain Access' app, search for 'GnuPG', right-click on the
# password entry shown in results, then click on 'Get Info', and then on
# 'Access Control'. You should see `pinentry-touchid` listed in the list under
# 'Always allow access by these applicatons'.
pass show VPNpassword

# The private key password has now been stored in Keychain by TouchID.

# If you try to `show` this password again, you will _not_ be prompted to unlock
# the PGP key, because it was cached by `gpg-agent` after the command above.
pass show VPNpassword

# The private key password, after it has been retrieved from Keychain, is cached
# by `gpg-agent`. So, usually you won't be  prompted to unlock the private key
# for the next few minutes.
#
# But since we want to see the ultimate benefit, that of using TouchID to fetch
# the private key password, we will force the `gpg-agent` to drop its cached
# values of private key passwords.
#
# Tell `gpg-agent` to reload config (even though the config hasn't changed), and
# it will additionally forget all cached private keys.
gpg-connect-agent reloadagent /bye

# After dropping `gpg-agent`'s cached passwords, trying to `show` any password
# in PasswordStore should prompt for the TouchID dialog. You will _not_ be
# prompted for GPG private key password; the GPG private key password is now
# stored in the login Keychain, and protected by your TouchID, thanks to
# `pinentry-touchid`.
pass show VPNpassword

# Since this was just for demo purposes, delete the `VPNpassword`.
pass rm VPNpassword

# In essence, now your TouchID protects the GPG key passwords stored in the
# macOS login Keychain, which in turn protect the GPG private keys, which in
# turn protect the passwords stored in PasswordStore.

# If you performed the optional `pass git init` command shown above, all changes
# to the PasswordStore are now tracked in Git. This Git repository can now be
# managed and shared just like any other Git repository.
#
# See the log of changes done to the PasswordStore.
( cd ~/.password-store/; git log )

# You should see output similar to the one below.
#
# commit 89fca136b832a0a829a0ee8f04197cc7147cb12d
# Author: Gurjeet Singh <gurjeet@singh.im>
# Date:   Sun Jun 9 21:17:33 2024 -0700
# 
#     Remove VPNpassword from store.
# 
# commit 41e950a6284e8f423a3f634d762038b77ff25df7
# Author: Gurjeet Singh <gurjeet@singh.im>
# Date:   Sun Jun 9 21:16:56 2024 -0700
# 
#     Add given password for VPNpassword to store.
# 
# commit 583e38474f3c341e648df666fce7b039712cb1cd
# Author: Gurjeet Singh <gurjeet@singh.im>
# Date:   Sun Jun 9 21:16:39 2024 -0700
# 
#     Configure git repository for gpg file diff.
# 
# commit a34b400171220fab8e3543afd01a917b38dc5da9
# Author: Gurjeet Singh <gurjeet@singh.im>
# Date:   Sun Jun 9 21:16:39 2024 -0700
# 
#     Add current contents of password store.
```
