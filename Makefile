all: build

build:
	wget http://downloads.sourceforge.net/project/nethack/nethack/3.4.2/nethack-342.tgz
	tar xf nethack-342.tgz
	ln -s /usr/bin/gcc-5 /usr/bin/gcc
	ln -s /usr/bin/gcc-5 /usr/bin/cc
	(cd nethack-3.4.2; /bin/sh sys/unix/setup.sh)
	(cd nethack-3.4.2; patch -p0 <../nethack.patch; make all)

install:
	install -m755 nethack-3.4.2/src/nethack $(DESTDIR)
	install -m755 nethack.sh $(DESTDIR)
	install -m644 nethack-3.4.2/dat/nhdat $(DESTDIR)
	install nethack-3.4.2/dat/license $(DESTDIR)
	install -d nethack-3.4.2/doc $(DESTDIR)
	rm $(DESTDIR)/lib/systemd/system/multi-user.target.wants/console-setup.service
