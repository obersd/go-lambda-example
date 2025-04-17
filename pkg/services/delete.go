package services

import (
	"context"
	"fmt"
	"strings"

	"go-lambda-example/pkg/db"

	"github.com/aws/aws-lambda-go/events"
)

// DeleteNote handles DELETE /notes/{id}
func DeleteNote(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	parts := strings.Split(req.Path, "/")
	if len(parts) < 3 || parts[2] == "" {
		return errorResponse(400, "Missing note ID in path")
	}

	id := parts[2]
	_, err := db.GetNoteById(ctx, id)
	if err != nil {
		if err.Error() == "note not found" {
			return errorResponse(404, "Note not found")
		}
		return errorResponse(500, fmt.Sprintf("Error checking note: %v", err))
	}

	if err := db.DeleteNote(ctx, id); err != nil {
		return errorResponse(500, fmt.Sprintf("Failed to delete note: %v", err))
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 204,
		Body:       "",
	}, nil
}
