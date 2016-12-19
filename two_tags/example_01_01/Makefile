.phony: clean

CWD 	= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN		= $(shell basename $(CWD))
REPO	= github.com/akaspin/workshops/two_tags

SRC 		= $(shell find . -type f \( -iname '*.go' \) )
PKGS 		= $(shell cd $(GOPATH)/src/$(REPO) && go list ./...)

GOOPTS=-installsuffix cgo -ldflags '-s'

dist: dist/$(BIN).exe dist/$(BIN)

dist/$(BIN).exe:
	GOOS=windows CGO_ENABLED=0 go build $(GOOPTS) -o $@ $(REPO)/$(BIN)

dist/$(BIN):
	GOOS=darwin CGO_ENABLED=0 go build $(GOOPTS) -o $@ $(REPO)/$(BIN)

clean:
	rm -rf dist
