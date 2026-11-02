# Load the local default identity without keeping it in the checkout.
[include]
    path = ~/.gitconfig-work

# Override the previous work profile's key without changing its local settings.
[core]
    sshCommand = ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes

# This also applies during cloning, before the destination checkout exists.
[includeIf "gitdir:~/code/personal/"]
    path = ~/.gitconfig-personal
