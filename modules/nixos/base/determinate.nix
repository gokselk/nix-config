# Determinate Nix module (optional)
# Import this module to use Determinate Nix instead of vanilla Nix
# Provides: parallel evaluation, lazy trees, better defaults
{ inputs, ... }:
{
  imports = [ inputs.determinate.nixosModules.default ];
}
