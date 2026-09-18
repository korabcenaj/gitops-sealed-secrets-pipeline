# GitOps Secrets Pipeline — Sealed Secrets + Automated Credential Rotation

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.28%2B-blue.svg)](https://kubernetes.io/)
[![Sealed Secrets](https://img.shields.io/badge/Bitnami-Sealed_Secrets-blue.svg)](https://github.com/bitnami-labs/sealed-secrets)
[![HashiCorp Vault](https://img.shields.io/badge/HashiCorp-Vault-black.svg)](https://www.vaultproject.io/)
[![External Secrets](https://img.shields.io/badge/ESO-External_Secrets_Operator-purple.svg)](https://external-secrets.io/)

A Git-safe secrets management and compliance pipeline utilizing **Bitnami Sealed Secrets (`kubeseal`)**, **HashiCorp Vault**, and the **External Secrets Operator (ESO)** with asymmetric encryption, automated secret synchronization, admission policy gates, and runtime compliance audits.

---

## Architecture Overview

```
                                  [ Developer / CI/CD ]
                                            |
                         Asymmetric Encryption via `kubeseal`
                         (Public Certificate, Private Key in Cluster)
                                            |
                                            v
                                  [ Public Git Repository ]
                                  (Stores SealedSecret CRDs)
                                            |
                                    GitOps Reconciled
                                            v
                            +-------------------------------+
                            | Sealed Secrets Controller     |
                            | (Decrypts in-cluster only)    |
                            +-------------------------------+
                                            |
                                            +---> [ Kubernetes Secret ]
                                                        ^
                            +-------------------------------+
                            | External Secrets Operator     |
                            | (Syncs Dynamic Vault Secrets) |
                            +-------------------------------+
                                            ^
                                            |
                                  [ HashiCorp Vault ]
                                  (Key Escrow / Rotation)
```

---

## Key Capabilities

1. **Git-Safe Asymmetric Secrets (`kubeseal`)**:
   - Secrets are encrypted on the developer client using the cluster's public sealing key.
   - Encrypted `SealedSecret` custom resources (as demonstrated in [`security/sealed-secrets/sealed-secret-example.yaml`](security/sealed-secrets/sealed-secret-example.yaml)) can be safely committed to public and private Git repositories.
   - Private decryption keys never leave the cluster controller.

2. **Automated Secret Syncing with Vault & ESO**:
   - `ClusterSecretStore` integration configured in [`security/vault/vault-eso-integration.yaml`](security/vault/vault-eso-integration.yaml) connecting workloads to HashiCorp Vault.
   - Automated periodic credential rotation and synchronization (`refreshInterval: 1h`) injecting credentials directly into standard Kubernetes Secrets.

3. **Supply Chain Defense & Policy Enforcement**:
   - **Admission Control**: Kyverno and OPA policies in [`security/kyverno/`](security/kyverno/) and [`security/opa/`](security/opa/) preventing privileged containers, enforcing read-only root filesystems, and mandating resource limits.
   - **Container Attestation**: Cosign image signing and Syft SPDX SBOM generation in [`security/cosign/`](security/cosign/).
   - **Runtime Defense**: Falco eBPF runtime threat detection rules in [`security/falco/falco-rules.yaml`](security/falco/falco-rules.yaml).

4. **Compliance Auditing**:
   - Automated CIS Kubernetes Benchmark audit script in [`security/compliance/cis-benchmark-audit.py`](security/compliance/cis-benchmark-audit.py) verifying API server configurations, kubelet flags, and RBAC least-privilege policies.

---

## Directory Structure

```text
├── README.md
└── security/
    ├── sealed-secrets/                      # Bitnami SealedSecret manifests & examples
    │   └── sealed-secret-example.yaml
    ├── vault/                               # HashiCorp Vault server & ESO manifests
    │   ├── config.hcl
    │   └── vault-eso-integration.yaml
    ├── sops/                                # SOPS age encryption configurations
    │   └── sops-config.yaml
    ├── kyverno/                             # Admission control security policies
    │   ├── disallow-privileged.yaml
    │   └── production-workload-policies.yaml
    ├── opa/                                 # Open Policy Agent Rego constraints
    │   └── container-limits.rego
    ├── falco/                               # Runtime threat detection rules
    │   └── falco-rules.yaml
    ├── cosign/                              # Container signing & SBOM scripts
    │   ├── sign-image.sh
    │   └── sbom-generation.sh
    ├── compliance/                          # CIS benchmark audit & reports
    │   ├── cis-benchmark-audit.py
    │   ├── sbom-attestator.py
    │   └── COMPLIANCE-REPORT-2026.md
    └── rbac-matrix.md                       # Role-Based Access Control matrix
```

---

## Verification & Usage

```bash
# 1. Encrypt a secret using kubeseal
kubectl create secret generic db-credentials --dry-run=client --from-literal=password=supersecret -o yaml | \
  kubeseal --controller-name=sealed-secrets-controller --format yaml > sealed-secret.yaml

# 2. Inspect ExternalSecrets synchronization status
kubectl get externalsecrets.external-secrets.io -A

# 3. Run CIS Benchmark compliance audit
python3 security/compliance/cis-benchmark-audit.py
```
