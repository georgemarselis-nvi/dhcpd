include pandoc-man.mk

PANDOC ?= pandoc

MANSECTION ?= 5

MANPAGE.md = $(PANDOC) --standalone $(PANDOCFLAGS) --to man

%.$(MANSECTION): %.$(MANSECTION).md
	$(MANPAGE.md) $< -o $@

all: dhcpd.conf.md

.PHONY: all
