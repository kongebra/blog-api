all: test lint build
build:
	docker build -t kongebra/blog-api:latest .
test:
	go test -v ./...
lint:
	golint -v ./...