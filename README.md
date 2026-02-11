# argocd-apps

## Migration

If `chatbot` and `notes-app` Applications already exist in your cluster, you can still adopt this repo safely.

1. Apply `root/app-of-apps.yaml`.
2. Argo CD will start managing those existing Applications as resources from this repo.
3. If live Application definitions differ from these manifests, Argo CD will reconcile toward the Git state.

Verify after sync:

```bash
k -n argocd get applications -o wide
k -n argocd describe application chatbot | sed -n '1,120p'
k -n argocd describe application notes-app | sed -n '1,120p'
```

# Argo CD Bootstrap (App-of-Apps)

This repository bootstraps Argo CD using the App-of-Apps pattern.

## Layout

- `app-of-apps.yaml` - Root Argo CD `Application` that points to this repo.
- `kustomization.yaml` - Includes all child applications in `apps/`.
- `apps/chatbot.yaml` - Chatbot workload application.
- `apps/notes-app.yaml` - Notes app workload application.
- `apps/gpu-observability.yaml` - GPU observability workload application.

## Bootstrap

1. Ensure Argo CD is installed.
2. Apply the root app:

```bash
kubectl apply -f app-of-apps.yaml -n argocd
```

Argo CD will then create and continuously reconcile all child applications listed in `kustomization.yaml`.
