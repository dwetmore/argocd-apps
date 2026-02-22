# argocd-apps

Argo CD app-of-apps control repository for this MicroK8s environment.

## Purpose

- Provide a single Git source of truth for platform and workload applications.
- Bootstrap Argo CD child `Application` resources from one root app.
- Continuously reconcile live cluster state to Git.

## Managed applications

Current applications included through `kustomization.yaml`:

- `argocd`
- `chatbot`
- `cmatrix`
- `notes-app`
- `gpu-observability`
- `space-invaders`
- `dependency-track-syft-gitops` (Dependency-Track + PostgreSQL + Syft SBOM stack)

## Repository layout

- `app-of-apps.yaml`: root app manifest.
- `root/app-of-apps.yaml`: same bootstrap pattern under `root/`.
- `kustomization.yaml`: lists child app manifests in `apps/`.
- `apps/*.yaml`: child Argo CD `Application` definitions.
- `argocd/overlays/...`: Argo CD platform patches.

## Bootstrap

1. Ensure Argo CD is installed in `argocd` namespace.
2. Apply root app:

```bash
kubectl apply -n argocd -f app-of-apps.yaml
```

## Verify reconciliation

```bash
kubectl -n argocd get applications -o wide
kubectl -n argocd get application argocd-apps -o yaml | rg -n 'sync|health|revision'
```

## Supply-chain stack reference

`apps/dependency-track-syft-gitops.yaml` points to:

- Repo: `https://github.com/dwetmore/dependency-track-syft-gitops.git`
- Path: `.`
- Revision: `main`

For detailed operational docs, see that repo:

- `dependency-track-syft-gitops/README.md`
- `dependency-track-syft-gitops/docs/OPERATIONS.md`
- `dependency-track-syft-gitops/docs/TROUBLESHOOTING.md`

## Common operations

Force refresh root app:

```bash
kubectl -n argocd patch application argocd-apps \
  --type merge \
  -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
```

Check only the supply-chain apps:

```bash
kubectl -n argocd get applications | rg 'dependency-track|syft'
```
