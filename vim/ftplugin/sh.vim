" -------------------------Shellcheck Integration-------------------------

if executable("shellcheck")
  set makeprg=shellcheck\ -f\ gcc\ %<
endif
