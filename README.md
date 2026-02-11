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
