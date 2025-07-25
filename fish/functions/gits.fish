function gits --wraps='git status -sb' --description 'alias gits git status -sb'
  git status -sb $argv
        
end
