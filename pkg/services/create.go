package services

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"go-lambda-example/pkg/db"
	"go-lambda-example/pkg/models"

	"math/rand"

	"github.com/aws/aws-lambda-go/events"
	"github.com/oklog/ulid/v2"
)

// CreateNote handles POST /notes
func CreateNote(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var input struct {
		Note string `json:"note"`
	}

	if err := json.Unmarshal([]byte(req.Body), &input); err != nil {
		return errorResponse(400, "Invalid JSON format")
	}

	if input.Note == "" {
		return errorResponse(400, "Missing 'id'")
	}

	now := time.Now().UTC()
	date := now.Format(time.RFC3339)
	entropy := ulid.Monotonic(rand.New(rand.NewSource(now.UnixNano())), 0)
	id := ulid.MustNew(ulid.Timestamp(now), entropy).String()

	note := models.Note{
		Id:        id,
		Note:      input.Note,
		CreatedAt: date,
		UpdatedAt: date,
	}

	if err := db.SaveNote(ctx, note); err != nil {
		return errorResponse(500, fmt.Sprintf("Failed to save note: %v", err))
	}

	responseBody, _ := json.Marshal(note)

	return events.APIGatewayProxyResponse{
		StatusCode: 201,
		Body:       string(responseBody),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}

func errorResponse(status int, message string) (events.APIGatewayProxyResponse, error) {
	errJSON := fmt.Sprintf(`{"error": "%s"}`, message)
	return events.APIGatewayProxyResponse{
		StatusCode: status,
		Body:       errJSON,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}, nil
}
