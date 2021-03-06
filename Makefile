VERSION = 0.8

PKG = frost-live-services
TOOLS = frostools

SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
DATADIR = $(PREFIX)/share

FMODE = -m0644
DMODE = -dm0755
BMODE = -m0755

BIN = \
	bin/frost-live

LIBS = $(wildcard lib/*.sh)

SHARED = \
	$(wildcard data/*.map) \
	data/live.conf

RC = \
	data/rc/gnupg-mount \
	data/rc/pacman-init \
	data/rc/frost-live

RUNIT_SVD = \
	data/runit/live

RUNIT_SV = \
	data/runit/pacman-init.run

S6_LIVE = \
	$(wildcard data/s6/frost-live/*)

S6_PI = \
	$(wildcard data/s6/pacman-init/*)

S6_BUNDLE = \
	$(wildcard data/s6/live/*)

S6_SV = \
	data/s6/pacman-init.run

XDG = $(wildcard data/*.desktop)

XBIN = bin/desktop-items


install_base:
	install $(DMODE) $(DESTDIR)$(BINDIR)
	install $(BMODE) $(BIN) $(DESTDIR)$(BINDIR)

	install $(DMODE) $(DESTDIR)$(LIBDIR)/$(TOOLS)
	install $(FMODE) $(LIBS) $(DESTDIR)$(LIBDIR)/$(TOOLS)

	install $(DMODE) $(DESTDIR)$(DATADIR)/$(TOOLS)
	install $(FMODE) $(SHARED) $(DESTDIR)$(DATADIR)/$(TOOLS)

install_rc:
	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/init.d
	install $(BMODE) $(RC) $(DESTDIR)$(SYSCONFDIR)/init.d

install_runit:
	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/rc/sysinit
	install $(DMODE) $(DESTDIR)$(LIBDIR)/rc/sv.d

	install $(BMODE) $(RUNIT_SVD) $(DESTDIR)$(LIBDIR)/rc/sv.d
	ln -sf $(LIBDIR)/rc/sv.d/live $(DESTDIR)$(SYSCONFDIR)/rc/sysinit/98-live

	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/runit/sv/pacman-init
	install $(BMODE) $(RUNIT_SV) $(DESTDIR)$(SYSCONFDIR)/runit/sv/pacman-init/run

install_s6:
	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/s6/sv

	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/s6/sv/pacman-init
	install $(BMODE) $(S6_PI) $(DESTDIR)$(SYSCONFDIR)/s6/sv/pacman-init/

	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/s6/sv/frost-live
	install $(BMODE) $(S6_LIVE) $(DESTDIR)$(SYSCONFDIR)/s6/sv/frost-live/

	install $(DMODE) $(DESTDIR)$(SYSCONFDIR)/s6/sv/live
	install $(BMODE) $(S6_BUNDLE) $(DESTDIR)$(SYSCONFDIR)/s6/sv/live/

install_xdg:
	install -dm0755 $(DESTDIR)$(PREFIX)/bin
	install -m0755 ${XBIN} $(DESTDIR)$(PREFIX)/bin

	install -dm0755 $(DESTDIR)$(SYSCONFDIR)/skel/.config/autostart
	install -m0755 ${XDG} $(DESTDIR)$(SYSCONFDIR)/skel/.config/autostart

install: install_base install_rc install_runit install_s6 install_xdg

.PHONY: install
