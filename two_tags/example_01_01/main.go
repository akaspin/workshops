package main

import (
	"os/exec"
	"fmt"
	"os"
)

func main() {
	output, err := exec.Command("echo", "test").Output()
	if err != nil {
		panic(err)
	}
	fmt.Fprintln(os.Stderr, string(output))
}
