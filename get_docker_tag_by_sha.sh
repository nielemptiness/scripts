 curl -s "https://registry.hub.docker.com/v2/repositories/{image_name}/tags?page_size=100"   | jq -r '.results[] | select(.digest == "sha256:{sha}") | .name'
