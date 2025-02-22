PROJECT := github.com/juju/pubsub

default: check

check: check-licence check-go
	go test $(PROJECT)/...

docs:
	godoc2md github.com/juju/pubsub > README.md
	sed -i 's|\[godoc-link-here\]|[![GoDoc](https://godoc.org/github.com/juju/pubsub?status.svg)](https://godoc.org/github.com/juju/pubsub)|' README.md

check-licence:
	@(fgrep -rl "Licensed under the LGPLv3" .;\
		fgrep -rl "MACHINE GENERATED BY THE COMMAND ABOVE; DO NOT EDIT" .;\
		find . -name "*.go") | sed -e 's,\./,,' | sort | uniq -u | \
		xargs -I {} echo FAIL: licence missed: {}

check-go:
	$(eval GOFMT := $(strip $(shell gofmt -l .| sed -e "s/^/ /g")))
	@(if [ x$(GOFMT) != x"" ]; then \
		echo go fmt is sad: $(GOFMT); \
		exit 1; \
	fi )
	@(go vet -all .)

.PHONY: default check docs check-licence check-go
