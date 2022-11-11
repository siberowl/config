alias -s gs='git status'
alias -s gl='git log'
alias -s ga='git add'
alias -s yl='yarn lint'
alias -s g='git'
alias -s gaa='git add -u'
alias -s gsh='git stash'

function gc
  set curr (git branch --show-current)
  set fish_trace 1
  git commit -m "$curr $argv"
end

function gsw
  set res (git branch -r | grep $argv)
  if test -z "$res"
    git fetch origin $argv
  end
  if test $status -eq 0
    set fish_trace 1
    git switch $argv
  end
end

funcsave gc
funcsave gsw