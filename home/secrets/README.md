# User Secrets

SOPS-encrypted secrets for home-manager configuration.

## Usage

Edit secrets:
```bash
just secrets-edit home/secrets/user-secrets.yaml
```

Access in home-manager:
```nix
sops.secrets."gh-token".path  # file path to decrypted secret
```
