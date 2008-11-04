VERSION = `head -n1 debian/changelog | sed 's/.*(\([^-]*\)-.*/\1/'`

PROF_DIR = docs/example-profiles

PREFIX ?= /usr
MANPREFIX ?= $(PREFIX)/share/man

tarball: clean
	rm -rf debirf-$(VERSION)
	mkdir -p debirf-$(VERSION)/docs/example-profiles
	ln -s ../../docs/README ../../docs/default-package-list debirf-$(VERSION)/docs
	(cd $(PROF_DIR) && tar c --exclude='*~' minimal/) | gzip -n > debirf-$(VERSION)/docs/example-profiles/minimal.tgz
	(cd $(PROF_DIR) && tar c --exclude='*~' rescue/) | gzip -n > debirf-$(VERSION)/docs/example-profiles/rescue.tgz
	(cd $(PROF_DIR) && tar c --exclude='*~' xkiosk/) | gzip -n > debirf-$(VERSION)/docs/example-profiles/xkiosk.tgz
	ln -s ../COPYING ../Makefile ../man ../src debirf-$(VERSION)
	tar ch --exclude='*~' debirf-$(VERSION) | gzip -n > debirf_$(VERSION).orig.tar.gz
	rm -rf debirf-$(VERSION)

debian-package: tarball
	tar xzf debirf_$(VERSION).orig.tar.gz
	cp -a debian debirf-$(VERSION)
	(cd debirf-$(VERSION) && debuild -uc -us)
	rm -rf debirf-$(VERSION)

install: installman
	mkdir -p $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/share/debirf $(DESTDIR)$(PREFIX)/share/doc/debirf
	install src/debirf $(DESTDIR)$(PREFIX)/bin
	install src/common src/devices.tar.gz src/modules $(DESTDIR)$(PREFIX)/share/debirf
	install doc/* $(DESTDIR)$(PREFIX)/share/doc/monkeysphere

installman:
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	gzip -n man/*/*
	install man/man1/* $(DESTDIR)$(MANPREFIX)/man1
	gzip -d man/*/*

clean:
	rm -f debirf_*

.PHONY: tarball debian-package install installman clean
