# Development profile
# Tools for software development and DevOps
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # Container/Kubernetes tools
    kubectl
    kubernetes-helm
    k9s
    stern         # Multi-pod log tailing
    kubectx       # Context/namespace switching

    # Infrastructure tools
    opentofu      # Open source Terraform fork
    ansible

    # Cloud CLIs
    awscli2
    google-cloud-sdk

    # Development tools
    direnv
    lazygit       # Terminal UI for git
    lazydocker    # Terminal UI for docker
    gh            # GitHub CLI
    delta         # Better git diffs
    httpie        # HTTP client
    usql          # Universal SQL client
    tokei         # Code statistics

    # Languages (add as needed)
    go
    gopls           # Go LSP
    golangci-lint   # Go linter
    delve           # Go debugger
    python3
    uv              # Fast Python package manager
    ruff            # Fast Python linter/formatter
    pyright         # Python type checker
    nodejs
    yarn

    # Rust
    rustup

    # C/C++
    clang
    llvm
    clang-tools     # clangd, clang-format, clang-tidy
    lld             # LLVM linker
    lldb            # LLVM debugger
    gdb             # GNU debugger
    valgrind        # Memory debugging

    # Build tools
    cmake
    ninja
    meson
    gnumake

    # Formatters
    prettier
    shfmt

    # File manager
    yazi

    # Media tools
    yt-dlp
  ];

  # Direnv integration
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Lazygit
  programs.lazygit.enable = true;

  # Zoxide (smarter cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Atuin (shell history)
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Tmux for terminal multiplexing
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    escapeTime = 10;
  };
}
