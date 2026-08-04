# RBAC Persona Matrix

| Persona | Kubernetes Role | Cluster Access | Secret Access | Namespaces |
|---|---|---|---|---|
| Platform Admin | ClusterAdmin | Full (`*`) | Full (`*`) | All |
| SRE | SRE-ReadWrite | Workload read/write | Read-only | All |
| Developer | Dev-Tenant | Workload read/write | Namespace Secrets | `dev`, `staging`, `prod` |
| Security Auditor | Security-Auditor | Read-only (`get`, `list`, `watch`) | Metadata only | All |
