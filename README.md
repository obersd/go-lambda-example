# go-lambda-example
This test demonstrates how to create a Go with AWS Lambda and API Gateway with Terraform as IaC.


## Prerequisites

This example assumes you have the following installed or configured on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS Account](https://aws.amazon.com/free/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) with permissions to create Lambda functions and API Gateway resources.
- [Go](https://golang.org/doc/install) installed on your local machine.

### make

Install [make](https://www.gnu.org/software/make/)

on Linux

```bash
sudo apt update
sudo apt install build-essential
```

On Windows

```bash
winget install GnuWin32.Make
```

## Dependencies

This example uses the following dependencies, executed in the root of the project:

```bash
go mod init goland-lambda-example
go get github.com/aws/aws-lambda-go \
github.com/oklog/ulid/v2 \
github.com/aws/aws-sdk-go-v2/config \
github.com/aws/aws-sdk-go-v2/service/dynamodb \
github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue
```

## Build

Build the Go application:

Linux
```bash
(cd cmd/lambda && GOOS=linux GOARCH=amd64 go build -o bootstrap main.go && zip lambda.zip bootstrap)
```

Windows:
```bash
(cd cmd/lambda && GOOS=linux GOARCH=amd64 go build -o bootstrap main.go && 7z.exe a -tzip lambda.zip bootstrap)
```

## Deploy
Deploy the application using Terraform:

```bash
(cd terraform && terraform init)
(cd terraform && terraform apply -auto-approve)
```


## Check invalid characters

```bash
cat -A terraform/main.tf
```

0## Removing the stack

```bash
(cd terraform && terraform destroy -auto-approve)
```


curl -X GET https://lhrp21i97c.execute-api.us-east-1.amazonaws.com/dev/notes


curl -X POST https://lhrp21i97c.execute-api.us-east-1.amazonaws.com/dev/notes -H "Content-Type: application/json" -d '{"note": "Mi primera nota"}'
