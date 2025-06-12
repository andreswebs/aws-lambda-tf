package main

import (
	"encoding/json"
	"fmt"
	"log/slog"
	"maps"
	"net/http"
	"os"
)

/*
ReadRequiredEnvVar reads a specified environment variable and returns the value,
or exits with status 1 if the value is unset or empty.
*/
func ReadRequiredEnvVar(name string) string {
	value := os.Getenv(name)
	if value == "" {
		slog.Error(fmt.Sprintf("missing required environment variable %s", name))
		os.Exit(1)
	}
	return value
}

/*
ReadEnvVarWithDefault reads a specified environment variable and returns the value,
or returns a specified default value if the value is unset or empty.
*/
func ReadEnvVarWithDefault(name string, defaultVal string) string {
	value := os.Getenv(name)
	if value == "" {
		return defaultVal
	}
	return value
}

/*
WriteJSONResponse writes a HTTP JSON response.

Taken from:

Edwards, Alex. 2021. Let's Go Further! Advanced patterns for building, managing and deploying RESTful JSON APIs and web applications in Go (1st ed.)
*/
func WriteJSONResponse(w http.ResponseWriter, status int, data any, headers http.Header) (err error) {
	jsonBytes, err := json.Marshal(data)
	if err != nil {
		return
	}
	jsonBytes = append(jsonBytes, '\n')

	maps.Copy(w.Header(), headers)
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	w.Write(jsonBytes)

	return
}

func ErrorResponse(w http.ResponseWriter, _ *http.Request, status int, message any) {
	env := envelope{"error": message}
	err := WriteJSONResponse(w, status, env, nil)
	if err != nil {
		slog.Error("failed to write error response", slog.Any("err", err))
		w.WriteHeader(500)
	}
}
