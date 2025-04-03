package main

import (
	"context"
	"log"
	"strings"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"

	"goland-lambda-example/cmd/lambda/handlers"
)

// Handler is the entry point for the Lambda function.
func Handler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Printf("HOLA")
	log.Println("Received request:", req)

	// Aquí puedes agregar más detalles si es necesario
	log.Println("Handling request method:", req.HTTPMethod)

	log.Println("METHOD:", req.HTTPMethod, "PATH:", req.Path)
	path := strings.TrimRight(req.Path, "/")
	if path == "" {
		path = "/"
	}
	method := req.HTTPMethod

	switch {
	// Create: POST /notes
	case method == "POST" && path == "/notes":
		return handlers.CreateNote(ctx, req)

	// Get one: GET /notes/{id}
	case method == "GET" && strings.HasPrefix(path, "/notes/"):
		return handlers.GetNote(ctx, req)

	// List all: GET /notes
	case method == "GET" && path == "/notes":
		return handlers.ListNotes(ctx, req)

	// Update: PUT /notes/{id}
	case method == "PUT" && strings.HasPrefix(path, "/notes/"):
		return handlers.UpdateNote(ctx, req)

	// Delete: DELETE /notes/{id}
	case method == "DELETE" && strings.HasPrefix(path, "/notes/"):
		return handlers.DeleteNote(ctx, req)

	default:
		return events.APIGatewayProxyResponse{
			StatusCode: 404,
			Body:       "Ruta no encontrada",
		}, nil
	}
}

func main() {
	log.Println("🔥 Lambda is starting up... 🔥")
	lambda.Start(Handler)
}
