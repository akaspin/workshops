package main

import (
	"fmt"
	"os"
)

func main() {
	output, err := execCmd("echo", "test").Output()
	if err != nil {
		panic(err)
	}
	fmt.Fprintln(os.Stderr, string(output))
}
