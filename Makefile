PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=NewApp \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=voterd \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=votercli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) 

BUILD_FLAGS := -ldflags '$(ldflags)'

all: install

install: go.sum
		go install -mod=readonly $(BUILD_FLAGS) ./cmd/voterd
		go install -mod=readonly $(BUILD_FLAGS) ./cmd/votercli

go.sum: go.mod
		@echo "--> Ensure dependencies have not been modified"
		GO111MODULE=on go mod verify

init-pre:
	rm -rf ~/.votercli
	rm -rf ~/.voterd
	voterd init mynode --chain-id voter
	votercli config keyring-backend test

init-user1:
	votercli keys add user1 --output json 2>&1

init-user2:
	votercli keys add user2 --output json 2>&1

init-post:
	voterd add-genesis-account $$(votercli keys show user1 -a) 1000token,100000000stake
	voterd add-genesis-account $$(votercli keys show user2 -a) 500token
	votercli config chain-id voter
	votercli config output json
	votercli config indent true
	votercli config trust-node true
	voterd gentx --name user1 --keyring-backend test
	voterd collect-gentxs