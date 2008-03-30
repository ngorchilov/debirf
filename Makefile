#!/usr/bin/make -f

# (c) 2007 Jameson Rollins <jrollins@fifthhorseman.net>
# Licensed under GPL v3 or later

# this makefile is used to build the archives of the example 
# profile directories

PREFIX=/usr

PROF_DIR=docs/example-profiles

all:
	echo "debirf is composed of scripts, so no compilation is necessary"

$(PROF_DIR)/minimal.tgz:
	cd $(PROF_DIR) && tar czf minimal.tgz minimal/

$(PROF_DIR)/rescue.tgz:
	cd $(PROF_DIR) && tar czf rescue.tgz rescue/

$(PROF_DIR)/xkiosk.tgz:
	cd $(PROF_DIR) && tar czf xkiosk.tgz xkiosk/

build-profiles: $(PROF_DIR)/minimal.tgz $(PROF_DIR)/rescue.tgz $(PROF_DIR)/xkiosk.tgz

install: build-profiles
	install -d $(PREFIX)/bin
	install -d $(PREFIX)/share/debirf/modules
	install -d $(PREFIX)/share/doc/debirf/example-profiles
	install -d $(PREFIX)/share/man/man1
	install fs/usr/bin/debirf $(PREFIX)/bin/debirf
	install fs/usr/share/debirf/common $(PREFIX)/share/debirf/
	install fs/usr/share/debirf/modules/* $(PREFIX)/share/debirf/modules/
	install -m 0644 fs/usr/share/debirf/devices.tar.gz $(PREFIX)/share/debirf/
	install -m 0644 fs/usr/share/man/man1/debirf.1 $(PREFIX)/share/man/man1/debirf.1
	install -m 0644 docs/example-profiles/*.tgz $(PREFIX)/share/doc/debirf/example-profiles/

release: 
	mkdir -p build/upstream
	ln -s ../.. build/upstream/debirf-$(VERSION)
	(cd build/upstream && tar czf ../debirf_$(VERSION).tar.gz --exclude=.svn --exclude=*~ debirf-$(VERSION)/{fs,COPYING,Makefile,docs})
	rm -f build/upstream/debirf-$(VERSION)

clean:
	rm $(PROF_DIR)/minimal.tgz
	rm $(PROF_DIR)/rescue.tgz
	rm $(PROF_DIR)/xkiosk.tgz
