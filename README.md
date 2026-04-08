# dotfiles

My NixOS dotfiles

How to update the system:

```
cd ~/dotfiles
nix flake update
sudo nixos-rebuild switch --flake .#desktop
git add flake.lock
git commit -m "Update system packages"
```

How to clean up old generations:

```
sudo nix-collect-garbage -d
```
