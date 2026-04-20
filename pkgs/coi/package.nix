{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  systemdLibs,
}:
let
  version = "0.8.0";
in
buildGoModule {
  pname = "coi";
  inherit version;

  src = fetchFromGitHub {
    owner = "mensfeld";
    repo = "code-on-incus";
    rev = "v${version}";
    hash = "sha256-05i/5M8u2f04/6dhVxHPRn0rF1ZJ/pQEI4xY+selutU=";
  };

  vendorHash = "sha256-HSobQDo0P9e6oCMv/VOjsRQVJFnX7zd1oqsiVEsGf90=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemdLibs ];

  subPackages = [ "cmd/coi" ];

  # COI embeds the container build script, default config, and a test dummy into the binary
  preBuild = ''
    mkdir -p internal/image/embedded internal/config/embedded
    cp profiles/default/build.sh internal/image/embedded/coi_build.sh
    cp profiles/default/config.toml internal/config/embedded/default_config.toml
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
