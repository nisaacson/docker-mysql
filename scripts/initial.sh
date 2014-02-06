#!/usr/bin/env bash

# resolve "stdin: is not a tty warning", related issue and proposed fix: https://github.com/mitchellh/vagrant/issues/1673
sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
