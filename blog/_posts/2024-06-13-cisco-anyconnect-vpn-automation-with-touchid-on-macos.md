---
layout: post
title:  "Cisco Anyconnect VPN automation with TouchID on macOS"
date:   2024-06-13 20:35:24 -0700
categories: pass, password store, touchid, VPN, encryption, automation
---

Automate Cisco AnyConnect VPN Reconnection
==========================================

Ideally any software like Cisco AnyConnect should support TouchID on macOS, so
as to make it conveninent for users to use these security tools. Unfortunately,
AnyConnect does not yet support TouchID.

Below are the shell functions I have written to keep my VPN connection always
connected. In a terminal window, I run the function `vpn_keep_connected` and it
polls the status of the VPN every few seconds. When it detects a disconnection
(perhaps because the laptop is waking up from sleep), it reinitiates the VPN
connection, and instead of having to type in my looong password, I just use
TouchID to login.

Please note that this intgrates with, and depends on, the TouchID based password
management setup I documented in my previous blog [post][]. This combination
ensures that you will not be prompted for the VPN password; instead, you will be
prompted for TouchID veification, and if that succeeds the VPN password will be
retrieved from the [PasswordStore][].

[post]: ./passwordstore+gnupg+touchid
[PasswordStore]: https://www.passwordstore.org/

```shell

function vpn_connect()
{
  local user="userid";
  local password="$(pass show vpn_password)";
  # Connect to VPN using CLI
  printf "$user\n$password\n" | /opt/cisco/secureclient/bin/vpn -s connect myaccess.oraclevpn.com
  # Start the App, so that its icon shows in the macOS menu bar to represent connection status
  open /Applications/Cisco/Cisco\ Secure\ Client.app/
}
 
function vpn_disconnect()
{
  # Disconnect VPN client, if already connected
  /opt/cisco/secureclient/bin/vpn disconnect
  # Kill the App, if running
  kill $(ps ax | grep -e '[C]isco Secure Client' | cut -f 1 -d?)
}
 
function vpn_reconnect()
{
  vpn_disconnect
  vpn_connect
}
 
function vpn_is_disconnected()
{
  /opt/cisco/secureclient/bin/vpn status | grep -q 'state: Disconnected';
  return $?;
}
 
function vpn_keep_connected()
{
  if vpn_is_disconnected; then
    echo "INFO: VPN is disconnected. Reinitiating connection."
    vpn_reconnect
  fi

  while true; do
    echo INFO: Waiting until VPN is disconnected.
    while ! vpn_is_disconnected; do
      sleep 5
    done
    echo "INFO: VPN is disconnected. Reinitiating connection."
    vpn_reconnect
  done
}
```
