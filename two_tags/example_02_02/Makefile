CWD 	= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN		= $(shell basename $(CWD))
REPO	= github.com/akaspin/workshops/two_tags

SRC 		= $(shell find . -type f \( -iname '*.go' \) )
PKGS 		= $(shell cd $(GOPATH)/src/$(REPO) && go list ./...)

GOOPTS=-installsuffix cgo -ldflags '-s'

dist: dist/$(BIN) dist/$(BIN)-debug

dist_m: dist/$(BIN)-m

dist/$(BIN):
	GOOS=darwin CGO_ENABLED=0  \
		go build $(GOOPTS) -o $@ $(REPO)/$(BIN)

dist/$(BIN)-debug:
	GOOS=darwin CGO_ENABLED=0  \
		go build -tags debug $(GOOPTS) -o $@ $(REPO)/$(BIN)

dist/$(BIN)-m:
	GOOS=darwin CGO_ENABLED=0  \
		go build -gcflags=-m $(GOOPTS_M) -o $@ $(REPO)/$(BIN)
