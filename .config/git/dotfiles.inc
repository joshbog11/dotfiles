[core]
	pager = delta
[interactive]
	diffFilter = delta --color-only
[delta]
	navigate = true
	line-numbers = true
	syntax-theme = none
[merge]
	conflictStyle = zdiff3
[diff]
	colorMoved = default
[alias]
	lg = log --graph --decorate --all --pretty=format:'%C(auto)%h%d %s %C(dim white)%cr %C(auto)(%an)'
	root = rev-parse --show-toplevel
