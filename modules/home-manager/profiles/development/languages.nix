# Programming languages and build tools
{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    # Go
    go
    gopls # Go LSP
    golangci-lint # Go linter
    delve # Go debugger

    # Python
    python3
    uv # Fast Python package manager
    ruff # Fast Python linter/formatter
    pyright # Python type checker

    # JavaScript/Node
    nodejs
    yarn

    # Rust
    rustup

    # C/C++
    clang
    llvm
    clang-tools # clangd, clang-format, clang-tidy
    lld # LLVM linker
    lldb # LLVM debugger
    gdb # GNU debugger
    valgrind # Memory debugging

    # Build tools
    cmake
    ninja
    meson
    gnumake

    # Formatters
    prettier
    shfmt
  ];
}
