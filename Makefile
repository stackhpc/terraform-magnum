HELM ?=v3.6.1
HELM2 ?=v2.17.0
SONOBUOY ?= 0.53.0
TERRAFORM ?= 1.0.3
KUBECTL ?= $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
CLUSTERCTL ?= 0.4.0

OS = $(shell lsb_release -si || echo CentOS)
ifeq ($(OS),Ubuntu)
	PM = apt
else ifeq ($(OS),CentOS)
	PM = dnf
else
	exit 1
endif

deps: helm kubectl terraform sonobuoy

# Install helm (version 3)
helm:
	curl -L https://get.helm.sh/helm-${HELM}-linux-amd64.tar.gz --output helm.tar.gz && \
	mkdir -p tmp && \
	tar -xzf helm.tar.gz -C tmp/ && \
	sudo mv tmp/linux-amd64/helm /usr/local/bin/helm && \
	rm -rf helm.tar.gz tmp

# Install helm (version 2)
helm2:
	curl -L https://get.helm.sh/helm-${HELM2}-linux-amd64.tar.gz --output helm.tar.gz && \
	mkdir -p tmp && \
	tar -xzf helm.tar.gz -C tmp/ && \
	sudo mv tmp/linux-amd64/helm /usr/local/bin/helm2 && \
	rm -rf helm.tar.gz tmp

unzip:
	sudo ${PM} install unzip -y

# Install known latest terraform
terraform: unzip
	curl -L https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip --output terraform.zip && \
	unzip terraform.zip && \
	rm terraform.zip && \
	sudo mv terraform /usr/local/bin/terraform

# Install latest kubectl
kubectl:
	curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL}/bin/linux/amd64/kubectl && \
	chmod +x kubectl && \
	sudo mv kubectl /usr/local/bin/kubectl

# Install latest known clusterctl
clusterctl:
	curl -L https://github.com/kubernetes-sigs/cluster-api/releases/download/v${CLUSTERCTL}/clusterctl-linux-amd64 -o clusterctl && \
	chmod +x clusterctl && \
	sudo mv clusterctl /usr/local/bin/clusterctl
jq:
	sudo ${PM} install jq -y

# Install latest known sonobuoy
sonobuoy: jq
	curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY}/sonobuoy_${SONOBUOY}_linux_amd64.tar.gz" --output sonobuoy.tar.gz && \
	mkdir -p tmp && \
	tar -xzf sonobuoy.tar.gz -C tmp/ && \
	chmod +x tmp/sonobuoy && \
	sudo mv tmp/sonobuoy /usr/local/bin/sonobuoy && \
	rm -rf sonobuoy.tar.gz tmp

