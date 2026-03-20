{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  systemdLibs,
}:
let
  version = "0.7.0";
in
buildGoModule {
  pname = "coi";
  inherit version;

  src = fetchFromGitHub {
    owner = "mensfeld";
    repo = "code-on-incus";
    rev = "v${version}";
    hash = "sha256-hTQFmOPoEfxeREC2IL6R3zUtNZwTx83pc2bN1mt0kfI=";
  };

  vendorHash = "sha256-YagzBcH9b0Xc/ULglvwmeX4EemvQz9ZC2xGKrK85E2Q=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemdLibs ];

  subPackages = [ "cmd/coi" ];

  # COI embeds the container build script and a test dummy into the binary
  preBuild = ''
    mkdir -p internal/image/embedded
    cp scripts/build/coi.sh internal/image/embedded/coi_build.sh
    cp testdata/dummy/dummy internal/image/embedded/dummy
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mensfeld/code-on-incus/internal/cli.Version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/coi $out/bin/claude-on-incus
  '';

  meta = {
    description = "Security-hardened container runtime for AI coding agents";
    homepage = "https://github.com/mensfeld/code-on-incus";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "coi";
  };
}
