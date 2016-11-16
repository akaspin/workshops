package example_03_01_test

import (
	"testing"
	"github.com/akaspin/dummy"
)

func TestCheck(t *testing.T) {
	if "ok" != dummy.Check() {
		t.FailNow()
	}
}
