package services

import (
	"context"
	"encoding/json"
	"fmt"

	"go-lambda-example/pkg/db"

	"github.com/aws/aws-lambda-go/events"
)

// ListNotes handles GET /notes
func ListNotes(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	notes, err := db.ListNotes(ctx)
	if err != nil {
		return errorResponse(500, fmt.Sprintf("Failed to list notes: %v", err))
	}

	jsonBody, err := json.Marshal(notes)
	if err != nil {
		return errorResponse(500, "Failed to marshal notes")
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(jsonBody),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}
