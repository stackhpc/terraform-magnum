case `lsb_release -si` in
	Ubuntu)
		PM=apt
		;;
	CentOS)
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

# Install known latest terraform
VERSION=0.12.24 && \
	curl -L https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip --output terraform.zip && \
	unzip terraform.zip && \
	rm terraform.zip && \
	sudo mv terraform /usr/local/bin/terraform

# Install latest known sonobuoy
VERSION=0.17.4 && \
	curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${VERSION}/sonobuoy_${VERSION}_linux_amd64.tar.gz" --output sonobuoy.tar.gz && \
	mkdir -p tmp && \
	tar -xzf sonobuoy.tar.gz -C tmp/ && \
	chmod +x tmp/sonobuoy && \
	sudo mv tmp/sonobuoy /usr/local/bin/sonobuoy && \
	rm -rf sonobuoy.tar.gz tmp
