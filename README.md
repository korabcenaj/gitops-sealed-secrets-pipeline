# GitOps Secrets Pipeline — Sealed Secrets & Credential Rotation

Git-safe secrets management pipeline using Bitnami Sealed Secrets (`kubeseal`), HashiCorp Vault, and External Secrets Operator (ESO).

## Key Capabilities
- **Asymmetric Encryption**: Encrypted SealedSecrets stored safely in public/private Git repositories.
- **Vault ESO Integration**: Automated secret synchronization and dynamic credential generation.
