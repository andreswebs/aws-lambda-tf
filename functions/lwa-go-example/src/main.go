package main

import (
	"encoding/json"
	"fmt"
	"log/slog"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
)

var (
	portEnvVar          string = "AWS_LWA_PORT"
	readinessPathEnvVar string = "AWS_LWA_READINESS_CHECK_PATH"
	eventsPathEnvVar    string = "AWS_LWA_PASS_THROUGH_PATH"

	port          string
	eventsPath    string
	readinessPath string
)

type Event events.SQSEvent
type envelope map[string]any

func init() {
	logger := slog.New(slog.NewJSONHandler(os.Stderr, nil))
	slog.SetDefault(logger)

	port = ReadEnvVarWithDefault(portEnvVar, "8080")
	readinessPath = ReadEnvVarWithDefault(readinessPathEnvVar, "/readyz")
	eventsPath = ReadEnvVarWithDefault(eventsPathEnvVar, "/events")
}

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc(readinessPath, readinessHandler)
	mux.HandleFunc(eventsPath, eventsHandler)

	s := &http.Server{
		Addr:    fmt.Sprintf(":%s", port),
		Handler: mux,
	}

	slog.Info(fmt.Sprintf("starting server on :%s", port))

	if err := s.ListenAndServe(); err != nil && err != http.ErrServerClosed {
		slog.Error("failed to start server", slog.Any("err", err))
	}
}

func readinessHandler(w http.ResponseWriter, r *http.Request) {
	data := map[string]string{
		"msg": "available",
	}
	err := WriteJSONResponse(w, http.StatusOK, data, nil)
	if err != nil {
		slog.Error("failed to write JSON response", slog.Any("err", err))
		http.Error(w,
			"The server encountered a problem and could not process your request", http.StatusInternalServerError)
	}
}

func eventsHandler(w http.ResponseWriter, r *http.Request) {
	var event Event

	err := json.NewDecoder(r.Body).Decode(&event)
	if err != nil {
		ErrorResponse(w, r, http.StatusBadRequest, err.Error())
		return
	}

	slog.Info("event received", slog.Any("event", r.Body))
	w.WriteHeader(http.StatusNoContent)
}
