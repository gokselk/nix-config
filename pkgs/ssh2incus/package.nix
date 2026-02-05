{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "0.9";
in
buildGoModule {
  pname = "ssh2incus";
  inherit version;

  src = fetchFromGitHub {
    owner = "mobydeck";
    repo = "ssh2incus";
    rev = version;
    hash = "sha256-4VgxLp+2lIrHshfQ4DwSJ6ykssL75XN4dBmF57PMPfM=";
  };

  vendorHash = "sha256-lJ1FckdxtlpI7AvlqgfVu4zWCaa7CADw/UheGCG4kws=";
  proxyVendor = true;

  subPackages = [ "cmd/ssh2incus" ];

  ldflags = [
    "-s"
    "-w"
    "-X ssh2incus.version=${version}"
    "-X ssh2incus.builtAt=1970-01-01T00:00:00Z"
  ];

  postPatch = ''
    substituteInPlace pkg/user/id.go \
      --replace-fail '/usr/bin/id' 'id'
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
