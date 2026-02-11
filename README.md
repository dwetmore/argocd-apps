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
