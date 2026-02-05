{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ssh2incus";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "mobydeck";
    repo = "ssh2incus";
    rev = version;
    hash = "sha256-4VgxLp+2lIrHshfQ4DwSJ6ykssL75XN4dBmF57PMPfM=";
  };

  vendorHash = "sha256-lJ1FckdxtlpI7AvlqgfVu4zWCaa7CADw/UheGCG4kws=";
  proxyVendor = true;

  # NixOS doesn't have /usr/bin - use PATH lookup instead
  postPatch = ''
    substituteInPlace $(grep -rl '/usr/bin/id' .) --replace-warn '/usr/bin/id' 'id'
  '';

  preBuild = ''
    ldflags+=" -X ssh2incus.builtAt=$(date -u -d @$SOURCE_DATE_EPOCH +%Y-%m-%dT%H:%M:%SZ)"
    for arch in amd64 arm64; do
      CGO_ENABLED=0 GOOS=linux GOARCH=$arch \
        go build -ldflags="-s -w" -o server/sftp-server-binary/bin/ssh2incus-sftp-server-$arch ./cmd/sftp-server
      CGO_ENABLED=0 GOOS=linux GOARCH=$arch \
        go build -ldflags="-s -w" -o server/stdio-proxy-binary/bin/ssh2incus-stdio-proxy-$arch ./cmd/stdio-proxy
      gzip -9 -k server/{sftp-server,stdio-proxy}-binary/bin/*-$arch
    done
  '';

  subPackages = [ "cmd/ssh2incus" ];
  ldflags = [ "-s" "-w" "-X ssh2incus.version=${version}" ];

  meta = {
    description = "SSH server for Incus instances";
    homepage = "https://github.com/mobydeck/ssh2incus";
    license = lib.licenses.gpl3Only;
    mainProgram = "ssh2incus";
  };
}
