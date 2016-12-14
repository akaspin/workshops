// +build !windows

package main

import "os/exec"

func execCmd(cmd string, args ...string) *exec.Cmd  {
	return exec.Command(cmd, args...)
}
