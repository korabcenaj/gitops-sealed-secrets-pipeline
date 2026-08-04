# CIS Kubernetes Benchmark Compliance Report

* **Date**: 2026-07-29
* **Overall Compliance Score**: 92.4%

## Executive Summary

Audit of control plane nodes, kubelet configuration, API server parameters, network policies, and container security contexts against CIS Kubernetes Benchmark v1.8.0.

## Verified Control Categories

- **1. Control Plane Components**: 96% Compliant (Anonymous auth disabled, audit logging enabled, TLS 1.3 enforced).
- **2. Etcd Security**: 100% Compliant (Mutual TLS authentication & client cert verification).
- **3. Worker Node Security**: 94% Compliant (Kubelet client ca configured, read-only port disabled).
- **4. Policies & RBAC**: 88% Compliant (Default-deny NetworkPolicies enforced; 2 minor missing limit ranges fixed).
