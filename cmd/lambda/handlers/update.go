package handlers

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"goland-lambda-example/cmd/lambda/dynamodb"
	"goland-lambda-example/cmd/models"

	"github.com/aws/aws-lambda-go/events"
)

// UpdateNote handles PUT /notes/{id}
func UpdateNote(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	parts := strings.Split(req.Path, "/")
	if len(parts) < 3 || parts[2] == "" {
		return errorResponse(400, "Missing note ID in path")
	}
	id := parts[2]

	var input struct {
		Note string `json:"note"`
	}
	if err := json.Unmarshal([]byte(req.Body), &input); err != nil {
		return errorResponse(400, "Invalid JSON")
	}

	if input.Note == "" {
		return errorResponse(400, "Field 'note' is required")
	}

	existing, err := dynamodb.GetNoteByID(ctx, id)
	if err != nil {
		if err.Error() == "note not found" {
			return errorResponse(404, "Note not found")
		}
		return errorResponse(500, fmt.Sprintf("Failed to fetch note: %v", err))
	}

	updated := models.Note{
		Id:        existing.Id,
		Note:      input.Note,
		CreatedAt: existing.CreatedAt,
		UpdatedAt: time.Now().UTC().Format(time.RFC3339),
	}

	if err := dynamodb.UpdateNote(ctx, updated); err != nil {
		return errorResponse(500, fmt.Sprintf("Failed to update note: %v", err))
	}

	jsonBody, _ := json.Marshal(updated)

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Body:       string(jsonBody),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}
