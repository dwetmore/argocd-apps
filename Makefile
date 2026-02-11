.PHONY: render validate

render:
	kustomize build .

validate:
	kustomize build . | kubeconform -strict -summary -ignore-missing-schemas
