# Variables
GO_VERSION = 1.24.0
BIN = bin
CMD_DIR = cmd
TF_DIR = terraform

.PHONY: install-go install-zip install-terraform tf-init tf-deploy tf-remove clean release build compile zip clear-build

install-go:
	curl -LO https://go.dev/dl/go$(GO_VERSION).linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	rm go$(GO_VERSION).linux-amd64.tar.gz
	echo 'export PATH=$$PATH:/usr/local/go/bin' >> ~/.bashrc
	source ~/.bashrc
	@echo "Go $(GO_VERSION) installed"

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
	rm -rf ./bin
	env GOARCH=arm64 GOOS=linux

	go build -tags create-note.norpc -ldflags="-s -w" -o 	$(BIN)/create-note/bootstrap $(CMD_DIR)/create-note/main.go
	go build -tags delete-note.norpc -ldflags="-s -w" -o 	$(BIN)/delete-note/bootstrap $(CMD_DIR)/delete-note/main.go
	go build -tags get-note.norpc -ldflags="-s -w" -o 		$(BIN)/get-note/bootstrap $(CMD_DIR)/get-note/main.go
	go build -tags list-notes.norpc -ldflags="-s -w" -o 	$(BIN)/list-notes/bootstrap $(CMD_DIR)/list-notes/main.go
	go build -tags update-note.norpc -ldflags="-s -w" -o 	$(BIN)/update-note/bootstrap $(CMD_DIR)/update-note/main.go

zip:
	zip $(BIN)/create-note/lambda.zip 	$(BIN)/create-note/bootstrap
	zip $(BIN)/delete-note/lambda.zip 	$(BIN)/delete-note/bootstrap
	zip $(BIN)/get-note/lambda.zip 		$(BIN)/get-note/bootstrap
	zip $(BIN)/list-notes/lambda.zip 	$(BIN)/list-notes/bootstrap
	zip $(BIN)/update-note/lambda.zip 	$(BIN)/update-note/bootstrap

clear-build:
	rm -rf $(BIN)/create-note/bootstrap
	rm -rf $(BIN)/delete-note/bootstrap
	rm -rf $(BIN)/get-note/bootstrap
	rm -rf $(BIN)/list-notes/bootstrap
	rm -rf $(BIN)/update-note/bootstrap
