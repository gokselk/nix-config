# Nixpkgs overlays
# Add custom packages or override existing ones
final: prev: {
  # Example: override a package version
  # example-package = prev.example-package.override { ... };

  # Example: add a custom package
  # my-custom-package = final.callPackage ../pkgs/my-package { };
}
