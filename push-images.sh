#!/bin/sh

docker login -u ${username} -p ${password}

kubeadm config images list 2>/dev/null 1>images.txt

for line in $(cat images.txt)
do
    echo "Handing image: ${line}"
    new="xuwenbao/"`echo ${line} | cut -d "/" -f 1`
    echo "New image: ${new}"

    docker pull ${line}
    docker tag ${line} ${new}
    docker push ${new}
done
