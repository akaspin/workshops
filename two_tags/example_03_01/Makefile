CWD 	= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN		= $(shell basename $(CWD))
REPO	= github.com/akaspin/workshops/two_tags

VENDOR = $(CWD)/_vendor
SRC 		= $(shell find . -type f \( -iname '*.go' \) )
PKGS 		= $(shell cd $(GOPATH)/src/$(REPO)/$(BIN) && go list ./...)

GOOPTS=-installsuffix cgo -ldflags '-s'

test_fail:
	go test $(PKGS)

test:
	GOPATH=$(VENDOR):$(GOPATH) go test $(PKGS)
