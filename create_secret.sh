et -euo pipefail
: "${AWS_REGION:=eu-north-1}"
: "${REPOSITORY_URI:?REPOSITORY_URI env var required}"

SECRET_NAME="${AWS_REGION}-ecr-registry"

TOKEN=$(aws ecr get-authorization-token --region "$AWS_REGION" --output text \
	  --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2)

kubectl create secret docker-registry "$SECRET_NAME" \
	  --docker-server="https://${REPOSITORY_URI}" \
	    --docker-username=AWS \
	      --docker-password="${TOKEN}" \
	        --docker-email="none@example.com" \
		  --dry-run=client -o yaml | kubectl apply -f -

kubectl patch serviceaccount default \
	  -p "{\"imagePullSecrets\":[{\"name\":\"${SECRET_NAME}\"}]}" || true
