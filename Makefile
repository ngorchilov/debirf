#!/usr/bin/make -f

# (c) 2007 Jameson Rollins <jrollins@fifthhorseman.net>
# Licensed under GPL v3 or later

# this makefile is used to build the archives of the example 
# profile directories

PROF_DIR=example-profiles

all:

$(PROF_DIR)/minimal.tgz:
	cd $(PROF_DIR) && tar czf minimal.tgz minimal/

$(PROF_DIR)/rescue.tgz:
	cd $(PROF_DIR) && tar czf rescue.tgz rescue/

$(PROF_DIR)/xkiosk.tgz:
	cd $(PROF_DIR) && tar czf xkiosk.tgz xkiosk/

release: $(PROF_DIR)/minimal.tgz $(PROF_DIR)/rescue.tgz $(PROF_DIR)/xkiosk.tgz
	mkdir -p build/upstream
	ln -s ../.. build/upstream/debirf-$(VERSION)
	(cd build/upstream && tar czf ../debirf_$(VERSION).tar.gz --exclude=.svn --exclude=*~ debirf-$(VERSION)/{fs,COPYING,Makefile,example-profiles})
	rm -f build/upstream/debirf-$(VERSION)

clean:
	rm $(PROF_DIR)/minimal.tgz
	rm $(PROF_DIR)/rescue.tgz
	rm $(PROF_DIR)/xkiosk.tgz
