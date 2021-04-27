package chatbot

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	dialogflow "cloud.google.com/go/dialogflow/apiv2"
	dialogflowpb "google.golang.org/genproto/googleapis/cloud/dialogflow/v2"
)

// GOOGLE_CLOUD_PROJECT is a user-set environment variable.
var projectID = os.Getenv("GOOGLE_CLOUD_PROJECT")

// client is a global dialogflow sessionClient
var client *dialogflow.SessionsClient

type Request struct {
	Text      string `json:"message"`
	SessionID string `json:"sessionId"`
}

type Response struct {
	Text []string `json:"messages"`
}

func init() {
	// err is pre-declared to avoid shadowing client
	var err error

	// client is initialized with context.Background() because it should
	// persist between function invocations.
	client, err = dialogflow.NewSessionsClient(context.Background())
	if err != nil {
		log.Fatalf("dialogflow.NewSessionsClient: %v", err)
	}
}

func ChatBotHandler(w http.ResponseWriter, r *http.Request) {
	applyCors(w)
	if r.Method == "OPTIONS" {
		w.WriteHeader(http.StatusNoContent)
		return
	}
	if r.Method != "POST" {
		http.Error(w, "Method is not supported", http.StatusMethodNotAllowed)
		return
	}

	var request Request
	err := json.NewDecoder(r.Body).Decode(&request)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error parsing object %v", err), http.StatusInternalServerError)
		return
	}

	responseText, err := detectIntentText(request.Text, request.SessionID, "EN-us", r)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error talking to google %v", err), http.StatusInternalServerError)
		return
	}

	response := Response{
		Text: *responseText,
	}
	respData, err := json.Marshal(response)
	if err != nil {
		http.Error(w, fmt.Sprintf("Error generating response %v", err), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(respData)
	return
}

func detectIntentText(text, sessionID, languageCode string, r *http.Request) (*[]string, error) {
	sessionPath := fmt.Sprintf("projects/%s/agent/sessions/%s", projectID, sessionID)
	textInput := dialogflowpb.TextInput{Text: text, LanguageCode: languageCode}
	queryTextInput := dialogflowpb.QueryInput_Text{Text: &textInput}
	queryInput := dialogflowpb.QueryInput{Input: &queryTextInput}
	request := dialogflowpb.DetectIntentRequest{Session: sessionPath, QueryInput: &queryInput}

	response, err := client.DetectIntent(r.Context(), &request)
	if err != nil {
		return nil, nil
	}

	var out []string
	fulfillmentMessages := response.GetQueryResult().GetFulfillmentMessages()
	for _, v := range fulfillmentMessages {
		out = append(out, v.GetText().Text...)
	}

	return &out, nil
}

func applyCors(w http.ResponseWriter) {
	w.Header().Set("Access-Control-Allow-Origin", os.Getenv("ACCESS_ORIGIN"))
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
}
