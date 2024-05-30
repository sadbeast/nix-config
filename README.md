# Installation

1. Follow the [installation guide](https://nixos.org/manual/nixos/stable/#sec-installation-manual-installing) and run `nixos-install --flake .#hostname` in this directory, instead of `nixos-install`.

# Usage

To rebuild the system after changes in `hosts/`:
```
sudo nixos-rebuild switch --flake .#hostname
```

After making changes in `home/`:

```
home-manager switch --flake .#sadbeast@hostname
```

# References
This was intitially setup using [https://github.com/Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)

[Encypted Btrfs Root with Opt-in State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
