BINDIR ?= $(CURDIR)/bin
TMPDIR ?= $(CURDIR)/tmp
ARCH   ?= amd64

help:  ## display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

.PHONY: help build docker all clean

test: ## test version-checker
	go test ./...

build: ## build version-checker
	mkdir -p $(BINDIR)
	CGO_ENABLED=0 go build -o ./bin/version-checker ./cmd/.

verify: test build ## tests and builds version-checker

image: ## build docker image
	GOARCH=$(ARCH) GOOS=linux CGO_ENABLED=0 go build -o ./bin/version-checker-linux ./cmd/.
	docker build -t mogensen/cert-checker:v0.0.1 .

clean: ## clean up created files
	rm -rf \
		$(BINDIR) \
		$(TMPDIR)

all: test build docker ## runs test, build and docker

test-coverage: ## Generate test coverage report
	mkdir -p $(TMPDIR)
	go test ./... --coverprofile $(TMPDIR)/outfile
	go tool cover -html=$(TMPDIR)/outfile

report-card: ## Generate static analysis report
	goreportcard-cli -v
