# Go-lambda-example

This test demonstrates how to create a Go with AWS Lambda and API Gateway with Terraform as IaC.

## Prerequisites

This example assumes you have the following installed or configured on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS Account](https://aws.amazon.com/free/)
- [AWS IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) with permissions to create Lambda functions and API Gateway resources.
- [Go](https://golang.org/doc/install) installed on your local machine.

### make

Install make executing the following commands:

```bash
sudo apt update
sudo apt install build-essential
```

## Dependencies

This example uses the following dependencies, executed in the root of the project:

```bash
go mod init go-lambda-example
go get github.com/aws/aws-lambda-go \
github.com/oklog/ulid/v2 \
github.com/aws/aws-sdk-go-v2/config \
github.com/aws/aws-sdk-go-v2/service/dynamodb \
github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue
```

## Testing the API

```bash
curl -X POST https://hwmb6a3sa8.execute-api.us-east-1.amazonaws.com/dev/notes -H "Content-Type: application/json" -d '{"note": "Mi primera nota"}'
curl -X GET https://hwmb6a3sa8.execute-api.us-east-1.amazonaws.com/dev/notes
```
