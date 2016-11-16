CWD 	= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN		= $(shell basename $(CWD))
REPO	= github.com/akaspin/workshops/two_tags

SRC 		= $(shell find . -type f \( -iname '*.go' \) )
PKGS    = $(shell cd $(GOPATH)/src/$(REPO)/$(BIN) && go list ./...)
PKGS_OK = $(shell cd $(GOPATH)/src/$(REPO)/$(BIN) && go list ./... | grep -v /vendor/)

GOOPTS=-installsuffix cgo -ldflags '-s'

test_fail:
	go test $(PKGS)

test:
	go test $(PKGS_OK)
