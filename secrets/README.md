# Secrets

SOPS-encrypted secrets using age encryption.

## Structure

- `hosts/common/` - shared host secrets (encrypted to user + hosts)
- `users/<username>/` - user secrets (encrypted to user only)

## Usage

```bash
just secrets-edit secrets/hosts/common/secrets.yaml
just secrets-rekey   # re-encrypt after key changes
just host-key hl-node01  # get host's age public key
```
