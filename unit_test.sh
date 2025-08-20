et -euo pipefail

kubectl rollout status deploy/hello-k8s --timeout=120s
curl -fsS -m 5 http://127.0.0.1:8080/ || (echo "Service test failed" && exit 1)
echo "Unit test OK"
