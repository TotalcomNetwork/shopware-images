#!/bin/bash
TAGS=( $(find ./php-* -maxdepth 1 -type d -printf '%f\n') ) 

for tag in "${TAGS[@]}"
do
	echo "  "
    echo "Start build of ${tag} ======================================================================================="
    docker buildx build --push --sbom true --tag artifacts.totalcom.it/library/shopware:${tag} --output type=image --platform linux/amd64 ./${tag}
    echo "Built of ${tag} completed ==================================================================================="
    echo "  "
done

docker push --all-tags davidetriso/shopware
