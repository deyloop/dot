#!/usr/bin/bash

cdl () {
  cd "$@" || return
  ls -a --color='auto' --group-directories-first
}
