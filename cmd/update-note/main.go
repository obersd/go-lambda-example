package main

import (
	"context"
	"go-lambda-example/pkg/services"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

/**
 * @file main.go
 * @brief This file contains the main function for the AWS Lambda function that updates a note.
 * @details It uses the AWS Lambda Go SDK to handle API Gateway requests and responses.
 *          The function is triggered by an API Gateway event and calls the UpdateNote function from the services package.
 * @param ctx context.Context - The context for the Lambda function.
 * @param req events.APIGatewayProxyRequest - The request from API Gateway.
 * @return events.APIGatewayProxyResponse - The response to be sent back to API Gateway.
 * @return error - An error if one occurred during processing.
 */
func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return services.UpdateNote(ctx, req)
}

func main() {
	lambda.Start(Handler)
}
