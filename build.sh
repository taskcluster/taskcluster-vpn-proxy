#! /bin/bash -e
if [ -z $1 ]; then
    echo "Must supply a directory for vpn configuration."
    exit 1
fi

vpn_path=$1

if [ ! -d $vpn_path ]; then
    echo "VPN path must be a directory"
    exit 1
fi

registry=$(cat ./REGISTRY)
version=$(cat ./VERSION)
image_name=${PWD##*/}

mkdir -p ./data/vpn_config/
cp $vpn_path/* data/vpn_config/

tag=$registry/$image_name:$version
docker build -t $tag .
rm -rf data/

echo "Push image to the repository: docker push $tag"
