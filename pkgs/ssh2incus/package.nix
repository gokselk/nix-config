{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.10";
in
buildGoModule {
  pname = "ssh2incus";
  inherit version;

  src = fetchFromGitHub {
    owner = "mobydeck";
    repo = "ssh2incus";
    rev = version;
    hash = "sha256-okYakGF+zADhszKGmsiItNKw4hkZwXeU6w5eqgwMk+E=";
  };

  vendorHash = "sha256-csegMIRjq1thUXDAmEd3DQlZL0cb+gklySZSveL0J1c=";
  proxyVendor = true;

  subPackages = [ "cmd/ssh2incus" ];

  ldflags = [
    "-s"
    "-w"
    "-X ssh2incus.version=${version}"
    "-X ssh2incus.builtAt=1970-01-01T00:00:00Z"
  ];

  # Web UI frontend source is closed-source and not in the public repo.
  # Placeholder satisfies the go:embed directive in web/embed.go.
  postPatch = ''
    mkdir -p web/dist
    echo '<!doctype html>' > web/dist/index.html
  '';

  preBuild = ''
    # Cross-compile sftp-server for amd64 and arm64
    for arch in amd64 arm64; do
      GOARCH=$arch CGO_ENABLED=0 go build -ldflags "-s -w" \
        -o server/sftp-server-binary/bin/ssh2incus-sftp-server-$arch \
        ./cmd/sftp-server
      gzip -f server/sftp-server-binary/bin/ssh2incus-sftp-server-$arch
    done

    # Cross-compile stdio-proxy for amd64 and arm64
    for arch in amd64 arm64; do
      GOARCH=$arch CGO_ENABLED=0 go build -ldflags "-s -w" \
        -o server/stdio-proxy-binary/bin/ssh2incus-stdio-proxy-$arch \
        ./cmd/stdio-proxy
      gzip -f server/stdio-proxy-binary/bin/ssh2incus-stdio-proxy-$arch
    done
  '';

  meta = {
    description = "SSH server for Incus instances";
    homepage = "https://github.com/mobydeck/ssh2incus";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "ssh2incus";
  };
}
