# Variables
GO_VERSION = 1.24.0
BIN = bin
CMD_DIR = cmd
TF_DIR = terraform
LAMBDA_NAMES = create-note delete-note get-note list-notes update-note

.PHONY: install-go install-zip install-terraform tf-init tf-deploy tf-remove clean release build compile zip clear-build

install-go:
install-go:
	curl -LO https://go.dev/dl/go$(GO_VERSION).linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	rm go$(GO_VERSION).linux-amd64.tar.gz
	echo 'export PATH=$$PATH:/usr/local/go/bin' >> ~/.bashrc
	@echo "Go $(GO_VERSION) installed. Run 'source ~/.bashrc' or restart terminal."


install-zip:
	sudo apt-get update && sudo apt-get install zip -y

install-terraform:
	wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update && sudo apt install terraform
	@echo "Terraform installed"

tf-init:
	cd $(TF_DIR) && terraform init

tf-deploy:
	cd $(TF_DIR) && terraform apply -auto-approve

tf-remove:
	cd $(TF_DIR) && terraform destroy -auto-approve

clean:
	rm -rf $(BIN)

release: build tf-deploy
build: clean compile zip clear-build

compile:
	@$(foreach lambda,$(LAMBDA_NAMES), \
		GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -tags $(lambda).norpc -ldflags="-s -w" -o $(BIN)/$(lambda)/bootstrap $(CMD_DIR)/$(lambda)/main.go; \
	)

zip:
	@$(foreach lambda,$(LAMBDA_NAMES), \
		zip -j $(BIN)/$(lambda)/lambda.zip $(BIN)/$(lambda)/bootstrap; \
	)

clear-build:
	@$(foreach lambda,$(LAMBDA_NAMES), \
		rm -f $(BIN)/$(lambda)/bootstrap; \
	)
