// +build debug

package main

import (
	"fmt"
	"os"
)

func Debug(msg string) {
	fmt.Fprintln(os.Stderr, msg)
}
