#!/usr/bin/make

SHELL = /bin/sh

program_name  = mymc
program_id    = mymc
program       = mymc
package_name  = mymc
description   = Utility for working with PlayStation 2 memory card images.
program_version = 2.6

PYTHON ?= python2

WGET ?= wget

MAKE ?= make

INSTALL ?= install
INSTALL_PROGRAM = $(INSTALL) -D -o $(USER) -g $(USER) -m 755
INSTALL_DATA    = $(INSTALL) -D -o $(USER) -g $(USER) -m 644

srcdir = .

TMPDIR ?= /tmp
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
datarootdir = $(prefix)/share
datadir = $(datarootdir)/$(program_name)
docdir = $(datarootdir)/doc/$(program_name)
sysconfdir = /etc
hicolordir = /usr/share/icons/hicolor
applicationsdir = /usr/share/applications

configure:
	$(WGET) https://extras.wxpython.org/wxPython4/extras/linux/gtk3/fedora-23/wxPython-4.0.2-cp27-cp27mu-linux_x86_64.whl
	$(PYTHON) -m pip install wxPython-4.0.2-cp27-cp27mu-linux_x86_64.whl
	rm -rf wxPython-4.0.2-cp27-cp27mu-linux_x86_64.whl

install:
	# Executable $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(bindir)/
	echo -e "#!/bin/bash\ncdir=\$$(dirname \$$BASH_SOURCE)\n\$$cdir/../share/mymc/mymc.py" > $(DESTDIR)$(bindir)/$(program)
	chmod +x $(DESTDIR)$(bindir)/$(program)
	
	# Launcher $(DESTDIR)$(applicationsdir)
	$(INSTALL_DATA) $(program_id).desktop $(DESTDIR)$(applicationsdir)/$(program_id).desktop
	
	# Icons $(DESTDIR)$(hicolordir)
	$(INSTALL_DATA) $(program_name).png $(DESTDIR)$(hicolordir)/48x48/apps/$(program_name).png
	
	# Software data $(DESTDIR)$(datadir)
	$(INSTALL_DATA) $(srcdir)/gui.py $(DESTDIR)$(datadir)/gui.py
	$(INSTALL_DATA) $(srcdir)/guires.py $(DESTDIR)$(datadir)/guires.py
	$(INSTALL_DATA) $(srcdir)/lzari.py $(DESTDIR)$(datadir)/lzari.py
	$(INSTALL_PROGRAM) $(srcdir)/mymc.py $(DESTDIR)$(datadir)/mymc.py
	$(INSTALL_DATA) $(srcdir)/ps2mc.py $(DESTDIR)$(datadir)/ps2mc.py
	$(INSTALL_DATA) $(srcdir)/ps2mc_dir.py $(DESTDIR)$(datadir)/ps2mc_dir.py
	$(INSTALL_DATA) $(srcdir)/ps2mc_ecc.py $(DESTDIR)$(datadir)/ps2mc_ecc.py
	$(INSTALL_DATA) $(srcdir)/ps2save.py $(DESTDIR)$(datadir)/ps2save.py
	$(INSTALL_DATA) $(srcdir)/round.py $(DESTDIR)$(datadir)/round.py
	$(INSTALL_DATA) $(srcdir)/sjistab.py $(DESTDIR)$(datadir)/sjistab.py
	$(INSTALL_DATA) $(srcdir)/verbuild.py $(DESTDIR)$(datadir)/verbuild.py

uninstall:
	rm -rf $(DESTDIR)$(bindir)/$(program)
	rm -rf $(DESTDIR)$(applicationsdir)/$(program_id).desktop
	rm -rf $(DESTDIR)$(hicolordir)/48x48/apps/$(program_name).png
	rm -rf $(DESTDIR)$(datadir)
	rm -rf $(DESTDIR)$(docdir)

install-user:
	# Install in home dir without root
	$(MAKE) \
		prefix=~/.local \
		sysconfdir=~/.config \
		hicolordir=~/.local/share/icons/hicolor \
		applicationsdir=~/.local/share/applications \
		install
	sed -i "s/Exec=/Exec=~\/.local\/bin\//" ~/.local/share/applications/$(program_id).desktop

uninstall-user:
	# Uninstall from home dir without root
	$(MAKE) \
		prefix=~/.local \
		sysconfdir=~/.config \
		hicolordir=~/.local/share/icons/hicolor \
		applicationsdir=~/.local/share/applications \
		uninstall

clean:
	rm -rf $(program_name).AppDir
	rm -rf *.AppImage

dist-app:
	rm -rf $(program_name).AppDir
	mkdir $(program_name).AppDir
	$(MAKE) DESTDIR=./$(program_name).AppDir install
	# Setting AppImage icon
	$(INSTALL_DATA) $(program_name).png $(program_name).AppDir/$(program_name).png
	# Setting AppImage launcher
	$(INSTALL_DATA) $(program_id).desktop $(program_name).AppDir/$(program_name).desktop
	
	# Dependencies
	mkdir -p $(program_name).AppDir/usr/lib/python2.7/site-packages
	if [ -d "/usr/lib/python2.7/site-packages/wx" ]; then \
		cp -r /usr/lib/python2.7/site-packages/wx $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/wxPython-4.0.2.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/six.py $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/six-1.16.0.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/pubsub $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/PyPubSub-3.3.0.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/attrdict $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r /usr/lib/python2.7/site-packages/attrdict-2.0.1.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
	else \
		cp -r ~/.local/lib/python2.7/site-packages/wx $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/wxPython-4.0.2.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/six.py $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/six-1.16.0.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/pubsub $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/PyPubSub-3.3.0.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/attrdict $(program_name).AppDir/usr/lib/python2.7/site-packages; \
		cp -r ~/.local/lib/python2.7/site-packages/attrdict-2.0.1.dist-info $(program_name).AppDir/usr/lib/python2.7/site-packages; \
	fi
	
	echo -e "#!/bin/bash\ncdir=\$$(dirname \$$BASH_SOURCE)\n\$$cdir$(bindir)/$(program)" > $(program_name).AppDir/AppRun
	chmod +x $(program_name).AppDir/AppRun
	ARCH=`uname -m` appimagetool $(program_name).AppDir

.PHONY: install uninstall clean

