#!/bin/sh

set -e

docker version

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum clean all && rpm --rebuilddb && yum install -y kubeadm --disableexcludes=kubernetes

kubeadm config images list 2>/dev/stderr 1>images.txt

echo "---- Origin images ----"
cat images.txt
echo "-----------------------"


echo "${password}" | docker login --username "${username}" --password-stdin ${server}

for line in $(cat images.txt)
do
    echo "Handing image: ${line}"
    new="registry.cn-hangzhou.aliyuncs.com/xuwenbao/"`echo ${line} | cut -d "/" -f 2`
    echo "New image: ${new}"

    docker pull ${line}
    docker tag ${line} ${new}
    docker push ${new}
done
