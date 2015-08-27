# Shadow-base

This is the whole stack shadowsocks service for [Strikingly](https://www.strikingly.com), it contains two sets of infrastructure and service setting, for now we only use `single node` version.


## Setup


* Install [Packer](https://www.packer.io/downloads.html) and [Terraform](https://www.terraform.io/downloads.html)

  verify that this command works:

  `packer`

  `terraform`

* Please notice that, you required to have a Google Cloud account. Please download your authentication file as `shadow-base/credentials/gc.json`

```
Authentication JSON File

Authenticating with Google Cloud services requires a JSON file which we call the account file.

This file is downloaded directly from the Google Developers Console. To make the process more straightforwarded, it is documented here:

  1. Log into the Google Developers Console and select a project.

  2. Under the "APIs & Auth" section, click "Credentials."

  3. Create a new OAuth client ID and select "Service account" as the type of account. Once created, and after a P12 key is downloaded, a JSON file should be downloaded. This is your account file.
```

* You need create a project on Google Cloud before start, then replace all `strikingly-test` in this repository with your own project name

## Configuration

* Modify `shadow_single_node/shadowsocks-config.json`

```
server          your server ip or hostname
server_port     server port
method          encryption method, null by default (table), the following methods are supported:
                    aes-128-cfb, aes-192-cfb, aes-256-cfb, bf-cfb, cast5-cfb, des-cfb, rc4-md5, chacha20, salsa20, rc4, table
password        a password used to encrypt transfer
timeout         server option, in seconds
```

## Build Image

* At shadow-base root directory, run `packer build packer_shadow_single_node.json` after this you will have a pre-build image on google Cloud

## Create Resources

* `cd single_node` run `terraform apply`

## Done

* `terraform show | grep ip_address` will show you the ip address you should use for shadowsocks

* You can view the server status at http://YOUR_IP_ADDRESS/docker/shadow

* If the ip got blocked, you can simply generate a new one by:

  `terraform taint google_compute_forwarding_rule.default && terraform apply`

  then run `terraform show | grep ip_address` again to show the new ip address
