mkdir -p ${HOME}/ws/helm_home
export HELM_HOME="${HOME}/ws/helm_home"
export HELM_TLS_ENABLE="true"
export TILLER_NAMESPACE="magnum-tiller"
kubectl -n magnum-tiller get secret helm-client-secret -o jsonpath='{.data.ca\.pem}' | base64 --decode > "${HELM_HOME}/ca.pem"
kubectl -n magnum-tiller get secret helm-client-secret -o jsonpath='{.data.key\.pem}' | base64 --decode > "${HELM_HOME}/key.pem"
kubectl -n magnum-tiller get secret helm-client-secret -o jsonpath='{.data.cert\.pem}' | base64 --decode > "${HELM_HOME}/cert.pem"
