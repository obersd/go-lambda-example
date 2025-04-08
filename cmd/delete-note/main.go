package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"goland-lambda-example/pkg/services"
)

// Handler is the entry point for the Lambda function.
func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return services.DeleteNote(ctx, req)
}

func main() {
	lambda.Start(Handler)
}
