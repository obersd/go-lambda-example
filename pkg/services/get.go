package services

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"go-lambda-example/pkg/db"

	"github.com/aws/aws-lambda-go/events"
)

// GetNote handles GET /notes/{id}
func GetNote(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	parts := strings.Split(req.Path, "/")
	if len(parts) < 3 || parts[2] == "" {
		return errorResponse(400, "Missing note ID in path")
	}

	id := parts[2]
	note, err := db.GetNoteById(ctx, id)
	if err != nil {
		if err.Error() == "note not found" {
			return errorResponse(404, "Note not found")
		}
		return errorResponse(500, fmt.Sprintf("Failed to retrieve note: %v", err))
	}

	responseBody, _ := json.Marshal(note)
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(responseBody),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}
