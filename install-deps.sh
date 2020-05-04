set -ex
source /etc/os-release
case $ID in
	ubuntu)
		PM=apt
		;;
	centos)
		PM=dnf
		;;
	*)
		exit 1
		;;
esac
sudo $PM install jq unzip -y

# Install latest kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
	chmod +x kubectl && \
	sudo mv kubectl /usr/local/bin/kubectl

# Install helm2 and helm (version 3)
VERSION=v2.16.4 && \
	curl -L https://get.helm.sh/helm-$VERSION-linux-amd64.tar.gz --output helm.tar.gz && \
	mkdir -p tmp && \
	tar -xzf helm.tar.gz -C tmp/ && \
	sudo mv tmp/linux-amd64/helm /usr/local/bin/helm2 && \
	rm -rf helm.tar.gz tmp

VERSION=v3.1.2 && \
	curl -L https://get.helm.sh/helm-$VERSION-linux-amd64.tar.gz --output helm.tar.gz && \
	mkdir -p tmp && \
	tar -xzf helm.tar.gz -C tmp/ && \
	sudo mv tmp/linux-amd64/helm /usr/local/bin/helm && \
	rm -rf helm.tar.gz tmp

# Install known latest terraform
VERSION=0.12.24 && \
	curl -L https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip --output terraform.zip && \
	unzip terraform.zip && \
	rm terraform.zip && \
	sudo mv terraform /usr/local/bin/terraform

# Install latest known sonobuoy
VERSION=0.18.0 && \
	curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_linux_amd64.tar.gz" --output sonobuoy.tar.gz && \
	mkdir -p tmp && \
	tar -xzf sonobuoy.tar.gz -C tmp/ && \
	chmod +x tmp/sonobuoy && \
	sudo mv tmp/sonobuoy /usr/local/bin/sonobuoy && \
	rm -rf sonobuoy.tar.gz tmp
