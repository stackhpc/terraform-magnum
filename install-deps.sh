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
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

# Install known latest terraform
VERSION=0.12.24
curl -OL https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip
unzip terraform_${VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
