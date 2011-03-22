#!/usr/bin/make -f

# Makefile for debirf

# (c) 2008-2011 Jameson Graef Rollins <jrollins@finestructure.net>
#               Daniel Kahn Gillmor <dkg@fifthhorseman.net>
# Licensed under GPL v3 or later

VERSION := `head -n1 debian/changelog | sed 's/.*(\([^-]*\).*/\1/'`

PREFIX ?= /usr
MANPREFIX ?= $(PREFIX)/share/man

PROFILES = doc/example-profiles/minimal.tgz doc/example-profiles/rescue.tgz doc/example-profiles/xkiosk.tgz

default: $(PROFILES)

doc/example-profiles/%.tgz: doc/example-profiles/%
	(cd doc/example-profiles && tar c --exclude='*~' $(notdir $<)) | gzip -9 -n > "$@"

install: installman profiles
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/debirf/example-profiles
	mkdir -p $(DESTDIR)$(PREFIX)/share/debirf/modules
	install src/debirf $(DESTDIR)$(PREFIX)/bin
	install src/common $(DESTDIR)$(PREFIX)/share/debirf
	install --mode=644 src/devices.tar.gz $(DESTDIR)$(PREFIX)/share/debirf
	install src/modules/* $(DESTDIR)$(PREFIX)/share/debirf/modules
	install doc/README $(DESTDIR)$(PREFIX)/share/doc/debirf
	install doc/example-profiles/*.tgz $(DESTDIR)$(PREFIX)/share/doc/debirf/example-profiles

installman:
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	gzip -n man/*/*
	install man/man1/* $(DESTDIR)$(MANPREFIX)/man1
	gzip -d man/*/*

clean:
	rm -f $(PROFILES)

.PHONY: default install installman profiles clean
