package main

import (
	"os"
	"fmt"
)

var needDebug bool

func init() {
	needDebug = os.Getenv("DEBUG") != ""
}

func Debug(msg string) {
	if needDebug {
		fmt.Fprintln(os.Stderr, msg)
	}
}

