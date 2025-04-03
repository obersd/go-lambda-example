package models

// Note Represents a note in the system.
type Note struct {
	// Id is the unique identifier for the note.
	Id string `json:"id"`

	// Note is the content of the note.
	Note string `json:"note"`

	// CreatedAt is the timestamp when the note was created.
	CreatedAt string `json:"created_at"`

	// UpdatedAt is the timestamp when the note was last updated.
	UpdatedAt string `json:"updated_at,omitempty"`
}
