#!/usr/bin/bash

cdl () {
  cd "$@" || return
  ls -la --color='auto' --group-directories-first
}
