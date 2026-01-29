# Secrets

SOPS-encrypted secrets for NixOS system configuration.

## Usage

Edit secrets:
```bash
just secrets-edit secrets/secrets.yaml
```

Re-encrypt after key changes:
```bash
just secrets-rekey
```

Get host's age public key:
```bash
just host-key hl-node01
```
