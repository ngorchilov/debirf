#!/usr/bin/make -f

# (c) 2007 Jameson Rollins <jrollins@fifthhorseman.net>
# Licensed under GPL v3 or later

# this makefile is used to build the archives of the example 
# profile directories

PROF_DIR=example-profiles

all: $(PROF_DIR)/minimal.tgz $(PROF_DIR)/rescue.tgz $(PROF_DIR)/xkiosk.tgz

$(PROF_DIR)/minimal.tgz:
	cd $(PROF_DIR) && tar cz -f minimal.tgz minimal/

$(PROF_DIR)/rescue.tgz:
	cd $(PROF_DIR) && tar cz -f rescue.tgz rescue/

$(PROF_DIR)/xkiosk.tgz:
	cd $(PROF_DIR) && tar cz -f xkiosk.tgz xkiosk/

clean:
	rm $(PROF_DIR)/minimal.tgz
	rm $(PROF_DIR)/rescue.tgz
	rm $(PROF_DIR)/xkiosk.tgz
