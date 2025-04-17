package db

import (
	"context"
	"fmt"
	"log"

	"go-lambda-example/pkg/models"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

var tableName = "AdNotesTable"

func getClient(ctx context.Context) (*dynamodb.Client, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to load AWS config: %w", err)
	}
	return dynamodb.NewFromConfig(cfg), nil
}

func SaveNote(ctx context.Context, note models.Note) error {
	log.Println("Saving note to DynamoDB:", note)
	client, err := getClient(ctx)
	if err != nil {
		return err
	}

	item, err := attributevalue.MarshalMap(note)
	if err != nil {
		return fmt.Errorf("failed to marshal note: %w", err)
	}

	_, err = client.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: aws.String(tableName),
		Item:      item,
	})

	return err
}

func GetNoteById(ctx context.Context, id string) (*models.Note, error) {
	client, err := getClient(ctx)
	if err != nil {
		return nil, err
	}

	key, err := attributevalue.MarshalMap(map[string]string{"Id": id})
	if err != nil {
		return nil, fmt.Errorf("failed to marshal key: %w", err)
	}

	out, err := client.GetItem(ctx, &dynamodb.GetItemInput{
		TableName: aws.String(tableName),
		Key:       key,
	})
	if err != nil {
		return nil, fmt.Errorf("failed to get item: %w", err)
	}

	if len(out.Item) == 0 {
		return nil, fmt.Errorf("note not found")
	}

	var note models.Note
	err = attributevalue.UnmarshalMap(out.Item, &note)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal item: %w", err)
	}

	return &note, nil
}

func ListNotes(ctx context.Context) ([]models.Note, error) {
	client, err := getClient(ctx)
	if err != nil {
		return nil, err
	}

	out, err := client.Scan(ctx, &dynamodb.ScanInput{
		TableName: aws.String(tableName),
	})
	if err != nil {
		return nil, fmt.Errorf("failed to scan notes: %w", err)
	}

	var notes []models.Note
	err = attributevalue.UnmarshalListOfMaps(out.Items, &notes)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal notes: %w", err)
	}

	return notes, nil
}

func UpdateNote(ctx context.Context, note models.Note) error {
	client, err := getClient(ctx)
	if err != nil {
		return err
	}

	item, err := attributevalue.MarshalMap(note)
	if err != nil {
		return fmt.Errorf("failed to marshal note: %w", err)
	}

	_, err = client.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: aws.String(tableName),
		Item:      item,
	})

	return err
}

func DeleteNote(ctx context.Context, id string) error {
	client, err := getClient(ctx)
	if err != nil {
		return err
	}

	key, err := attributevalue.MarshalMap(map[string]string{"Id": id})
	if err != nil {
		return fmt.Errorf("failed to marshal key: %w", err)
	}

	_, err = client.DeleteItem(ctx, &dynamodb.DeleteItemInput{
		TableName: aws.String(tableName),
		Key:       key,
	})
	return err
}
