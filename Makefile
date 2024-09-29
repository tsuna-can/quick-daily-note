BIN = daily
PREFIX = /usr/local

install:
	sudo install $(BIN) $(PREFIX)/bin/
	daily initialize

uninstall:
	sudo rm $(PREFIX)/bin/$(BIN)
