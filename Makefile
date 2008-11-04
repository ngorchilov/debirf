VERSION := `head -n1 debian/changelog | sed 's/.*(\([^-]*\)-.*/\1/'`

PROF_DIR = doc/example-profiles

PREFIX ?= /usr
MANPREFIX ?= $(PREFIX)/share/man

build:
	

tarball: clean
	rm -rf debirf-$(VERSION)
	mkdir -p debirf-$(VERSION)/doc/example-profiles
	ln -s ../../doc/README ../../doc/default-package-list debirf-$(VERSION)/doc
	(cd $(PROF_DIR) && tar c --exclude='*~' --exclude='*.svn*' minimal/) | gzip -n > debirf-$(VERSION)/doc/example-profiles/minimal.tgz
	(cd $(PROF_DIR) && tar c --exclude='*~' --exclude='*.svn*' rescue/) | gzip -n > debirf-$(VERSION)/doc/example-profiles/rescue.tgz
	(cd $(PROF_DIR) && tar c --exclude='*~' --exclude='*.svn*' xkiosk/) | gzip -n > debirf-$(VERSION)/doc/example-profiles/xkiosk.tgz
	ln -s ../COPYING ../Makefile ../man ../src debirf-$(VERSION)
	tar ch --exclude='*~' --exclude='*.svn*' debirf-$(VERSION) | gzip -n > debirf_$(VERSION).orig.tar.gz
	rm -rf debirf-$(VERSION)

debian-package: tarball
	tar xzf debirf_$(VERSION).orig.tar.gz
	tar c --exclude='*~' --exclude='*.svn*' debian | tar x -C debirf-$(VERSION)
	(cd debirf-$(VERSION) && debuild -uc -us)
	rm -rf debirf-$(VERSION)

install: installman
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	mkdir -p $(DESTDIR)$(PREFIX)/share/doc/debirf/example-profiles
	mkdir -p $(DESTDIR)$(PREFIX)/share/debirf/modules
	install src/debirf $(DESTDIR)$(PREFIX)/bin
	install src/common $(DESTDIR)$(PREFIX)/share/debirf
	install --mode=644 src/devices.tar.gz $(DESTDIR)$(PREFIX)/share/debirf
	install src/modules/* $(DESTDIR)$(PREFIX)/share/debirf/modules
	install doc/README doc/default-package-list $(DESTDIR)$(PREFIX)/share/doc/debirf
	install doc/example-profiles/* $(DESTDIR)$(PREFIX)/share/doc/debirf/example-profiles

installman:
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	gzip -n man/*/*
	install man/man1/* $(DESTDIR)$(MANPREFIX)/man1
	gzip -d man/*/*

clean:
	rm -f debirf_*

.PHONY: build tarball debian-package install installman clean
