# Host defaults apply wherever the repository is cloned.
[includeIf "hasconfig:remote.*.url:git@github.com:*/**"]
    path = ~/.gitconfig-personal
[includeIf "hasconfig:remote.*.url:https://github.com/**"]
    path = ~/.gitconfig-personal
[includeIf "hasconfig:remote.*.url:ssh://git@github.com/**"]
    path = ~/.gitconfig-personal
[includeIf "hasconfig:remote.*.url:git@gitlab.com:*/**"]
    path = ~/.gitconfig-work
[includeIf "hasconfig:remote.*.url:https://gitlab.com/**"]
    path = ~/.gitconfig-work
[includeIf "hasconfig:remote.*.url:ssh://git@gitlab.com/**"]
    path = ~/.gitconfig-work

# Directory rules come last so they override host defaults, even before a remote exists.
[includeIf "gitdir:~/code/personal/"]
    path = ~/.gitconfig-personal
[includeIf "gitdir:~/code/work/"]
    path = ~/.gitconfig-work
