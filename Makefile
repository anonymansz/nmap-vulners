# Extract the version string from nmap.h.
export NMAP_VERSION := $(shell echo NMAP_VERSION | $(CPP) -imacros nmap.h - | sed -n '$$s/[" ]//g;$$p')
NMAP_PLATFORM=x86_64-unknown-linux-gnu
datarootdir = ${prefix}/share
prefix = /usr/local
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
sbindir = ${exec_prefix}/sbin
mandir = ${datarootdir}/man
top_srcdir = .
srcdir = .
nmapdatadir = ${datarootdir}/nmap
deskdir = $(prefix)/share/applications
NMAPDEVDIR=~/nmap-private-dev

export NBASEDIR=nbase
export NSOCKDIR=nsock
export LIBLUADIR = liblua
export LIBLINEARDIR = liblinear
export NDIR=$(shell pwd)
export LIBLINEAR_LIBS = $(top_srcdir)/liblinear/liblinear.a
export NCATDIR=ncat
CC = gcc
CXX = g++
CCOPT =
DBGFLAGS =
STRIP = /usr/bin/strip
LIBPCAPDIR = libpcap
LIBSSH2DIR = libssh2
ZLIBDIR = libz
LIBPCREDIR = libpcre
export LIBDNETDIR = libdnet-stripped
ZENMAPDIR = zenmap
NDIFFDIR = ndiff
NPINGDIR = nping
PYTHON = /usr/bin/python2
DEFS = -DHAVE_CONFIG_H -DNMAP_PLATFORM=\"$(NMAP_PLATFORM)\" -DNMAPDATADIR=\"$(nmapdatadir)\"
# With GCC, add extra security checks to source code.
# http://gcc.gnu.org/ml/gcc-patches/2004-09/msg02055.html
# Level 1 only makes changes that don't affect "conforming" programs,
# while level 2 enforces additional restrictions.
DEFS += -D_FORTIFY_SOURCE=2
# For mtrace debugging -- see MTRACE define in main.cc for instructions
# Should only be enabled during debugging and not in any real release.
# DEFS += -DMTRACE=1
CXXFLAGS = -g -O2 -Wall -fno-strict-aliasing $(DBGFLAGS) $(CCOPT)
CPPFLAGS = -I$(top_srcdir)/liblinear -I$(top_srcdir)/liblua -I$(top_srcdir)/libdnet-stripped/include -I$(top_srcdir)/libssh2/include -I$(top_srcdir)/libpcre  -I$(top_srcdir)/nbase -I$(top_srcdir)/nsock/include $(DEFS)
CFLAGS = -g -O2 -Wall $(DBGFLAGS) $(CCOPT)
STATIC =
LDFLAGS = -Wl,-E  -Lnbase -Lnsock/src/ $(DBGFLAGS) $(STATIC)
LIBS =  -lnsock -lnbase libpcre/libpcre.a -lpcap $(LIBSSH2_LIBS) $(OPENSSL_LIBS) $(ZLIB_LIBS) libnetutil/libnetutil.a $(top_srcdir)/libdnet-stripped/src/.libs/libdnet.a $(top_srcdir)/liblua/liblua.a $(top_srcdir)/liblinear/liblinear.a -ldl 
OPENSSL_LIBS = -lssl -lcrypto
LIBSSH2_LIBS = libssh2/lib/libssh2.a
ZLIB_LIBS = -lz
# LIBS =  -lefence -ldl 
# LIBS =  -lrmalloc -ldl 
INSTALL = /usr/bin/install -c
# MAKEDEPEND = @MAKEDEPEND@
export RPMTDIR=$(HOME)/rpm
# Whether the user wants to install translated man pages. If "yes", then
# all translated man pages are installed, unless a subset is specified
# with the LINGUAS environment variable.
USE_NLS = yes
# A space-separated list of language codes supported (for man page
# installation). The user can install a subset of these with the LINGUAS
# environment variable or none of them with --disable-nls.
ALL_LINGUAS = de es fr hr hu it ja pl pt_BR pt_PT ro ru sk zh
# A space-separated list of language codes requested by the user.
LINGUAS ?= $(ALL_LINGUAS)


# DESTDIR is used by some package maintainers to install Nmap under
# its usual directory structure into a different tree.  See the
# CHANGELOG for more info.
DESTDIR =

TARGET = nmap
INSTALLNSE=install-nse
BUILDZENMAP=build-zenmap
BUILDNDIFF=build-ndiff
BUILDNPING=build-nping
BUILDNCAT=build-ncat
INSTALLZENMAP=install-zenmap
INSTALLNDIFF=install-ndiff
INSTALLNPING=install-nping
UNINSTALLZENMAP=uninstall-zenmap
UNINSTALLNDIFF=uninstall-ndiff
UNINSTALLNPING=uninstall-nping

ifneq (,yes)
NSE_SRC=nse_main.cc nse_utility.cc nse_nsock.cc nse_dnet.cc nse_fs.cc nse_nmaplib.cc nse_debug.cc nse_pcrelib.cc nse_lpeg.cc
NSE_HDRS=nse_main.h nse_utility.h nse_nsock.h nse_dnet.h nse_fs.h nse_nmaplib.h nse_debug.h nse_pcrelib.h nse_lpeg.h
NSE_OBJS=nse_main.o nse_utility.o nse_nsock.o nse_dnet.o nse_fs.o nse_nmaplib.o nse_debug.o nse_pcrelib.o nse_lpeg.o
ifneq (-lssl -lcrypto,)
NSE_SRC+=nse_openssl.cc nse_ssl_cert.cc
NSE_HDRS+=nse_openssl.h nse_ssl_cert.h
NSE_OBJS+=nse_openssl.o nse_ssl_cert.o
endif
ifneq (libssh2/lib/libssh2.a,)
NSE_SRC+=nse_libssh2.cc
NSE_HDRS+=nse_libssh2.h
NSE_OBJS+=nse_libssh2.o
endif
ifneq (-lz,)
NSE_SRC+=nse_zlib.cc
NSE_HDRS+=nse_zlib.h
NSE_OBJS+=nse_zlib.o
endif
endif

export SRCS = charpool.cc FingerPrintResults.cc FPEngine.cc FPModel.cc idle_scan.cc MACLookup.cc main.cc nmap.cc nmap_dns.cc nmap_error.cc nmap_ftp.cc NmapOps.cc NmapOutputTable.cc nmap_tty.cc osscan2.cc osscan.cc output.cc payload.cc portlist.cc portreasons.cc protocols.cc scan_engine.cc scan_engine_connect.cc scan_engine_raw.cc scan_lists.cc service_scan.cc services.cc string_pool.cc Target.cc NewTargets.cc TargetGroup.cc targets.cc tcpip.cc timing.cc traceroute.cc utils.cc xml.cc $(NSE_SRC)

export HDRS = charpool.h FingerPrintResults.h FPEngine.h idle_scan.h MACLookup.h nmap_amigaos.h nmap_dns.h nmap_error.h nmap.h nmap_ftp.h NmapOps.h NmapOutputTable.h nmap_tty.h nmap_winconfig.h osscan2.h osscan.h output.h payload.h portlist.h portreasons.h probespec.h protocols.h scan_engine.h scan_engine_connect.h scan_engine_raw.h service_scan.h scan_lists.h services.h string_pool.h NewTargets.h TargetGroup.h Target.h targets.h tcpip.h timing.h traceroute.h utils.h xml.h $(NSE_HDRS)

OBJS = charpool.o FingerPrintResults.o FPEngine.o FPModel.o idle_scan.o MACLookup.o nmap_dns.o nmap_error.o nmap.o nmap_ftp.o NmapOps.o NmapOutputTable.o nmap_tty.o osscan2.o osscan.o output.o payload.o portlist.o portreasons.o protocols.o scan_engine.o scan_engine_connect.o scan_engine_raw.o scan_lists.o service_scan.o services.o string_pool.o NewTargets.o TargetGroup.o Target.o targets.o tcpip.o timing.o traceroute.o utils.o xml.o $(NSE_OBJS)

# %.o : %.cc -- nope this is a GNU extension
.cc.o:
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

# FPModel.cc contains large numeric tables that exceed the capacity of
# debugging output with GCC 4.6.0 on AIX, causing "Error: value of 121716 too
# large for field of 2 bytes". Disable debugging for this one file.
FPModel.o: CXXFLAGS += -g0

all: $(TARGET) $(BUILDZENMAP) $(BUILDNDIFF) $(BUILDNPING) $(BUILDNCAT)

$(TARGET): build-netutil build-liblinear  build-libssh2  build-pcre build-nsock build-nbase build-dnet build-lua \
	$(OBJS) main.o
	@echo Compiling nmap
	rm -f $@
	$(CXX) $(LDFLAGS) -o $@ $(OBJS) main.o $(LIBS)

build-pcre: $(LIBPCREDIR)/Makefile
	@echo Compiling libpcre; cd $(LIBPCREDIR) && $(MAKE)

build-dnet: $(LIBDNETDIR)/Makefile
	@echo Compiling libdnet; cd $(LIBDNETDIR) && $(MAKE)

build-pcap: $(LIBPCAPDIR)/Makefile
	@echo Compiling libpcap; cd $(LIBPCAPDIR) && $(MAKE)

build-libssh2: $(LIBSSH2DIR)/src/Makefile
	@echo Compiling libssh2; cd $(LIBSSH2DIR)/src && $(MAKE);
	cd $(LIBSSH2DIR)/src && $(MAKE) libdir="/lib" prefix="" DESTDIR=$(NDIR)/$(LIBSSH2DIR) install-libLTLIBRARIES;

build-zlib: $(ZLIBDIR)/Makefile
	@echo Compiling zlib; cd $(ZLIBDIR) && $(MAKE);

build-nbase: $(NBASEDIR)/Makefile
	@echo Compiling libnbase;
	cd $(NBASEDIR) && $(MAKE)

build-nsock: $(NSOCKDIR)/src/Makefile build-nbase
	@echo Compiling libnsock;
	cd $(NSOCKDIR)/src && $(MAKE)

build-netutil: libnetutil/Makefile
	@echo Compiling libnetutil;
	cd libnetutil && $(MAKE)

build-ncat: $(NCATDIR)/Makefile build-nbase build-nsock $(NCATDIR)/ncat.h 
	cd $(NCATDIR) && $(MAKE)

build-lua: $(LIBLUADIR)/Makefile
	@echo Compiling liblua; cd $(LIBLUADIR) && $(MAKE) liblua.a CC="$(CC)" MYCFLAGS="$(CFLAGS) -DLUA_USE_POSIX -DLUA_USE_DLOPEN"

build-liblinear: $(LIBLINEARDIR)/Makefile
# -Wno-uninitialized avoids the warning "'Gnorm1_init' may be used uninitialized in this function"
	@echo Compiling liblinear; cd $(LIBLINEARDIR) && $(MAKE) liblinear.a CC="$(CC)" CXX="$(CXX)" CFLAGS="$(CFLAGS) -Wno-uninitialized"

# This is the last one to ensure specific build targets are preferred
build-%: %/Makefile
	cd $* && $(MAKE)

# Make a statically compiled binary for portability between distributions
static:
	$(MAKE) STATIC=-static

debug:
	$(MAKE) DBGFLAGS="-O0 -g -pg -ftest-coverage -fprofile-arcs"

# CALL THIS FROM ONE COMPUTER AND CHECK IN RESULTS BEFORE DOING ANYONE
# DOES A MAKE RELEASE
prerelease:
	cd $(NMAPDEVDIR) && $(MAKE) prerelease

# Make just the Nmap tarballs
release-tarballs:
	cd $(NMAPDEVDIR) && $(MAKE) release-tarballs

# Make the tarballs and RPMs (which are built from tarball)
release-rpms:
	cd $(NMAPDEVDIR) && $(MAKE) release-rpms

# Update the web site
web:
	cd $(NMAPDEVDIR) && $(MAKE) web

clean: clean-lua clean-liblinear  clean-pcre clean-dnet clean-libssh2 \
clean-nsock clean-nbase clean-netutil clean-nping clean-zenmap \
clean-ncat clean-ndiff clean-tests
	rm -f $(OBJS) main.o $(TARGET)
# Who generates dependencies.mk? If it is generated by ./configure and
# not by make it should be moved to distclean
	rm -f dependencies.mk

debugclean:
	rm -f *.gcov *.gcda *.gcno gmon.out

distclean: distclean-lua distclean-liblinear  distclean-libssh2\
 distclean-pcre distclean-dnet distclean-nping distclean-zenmap \
distclean-ncat distclean-netutil \
distclean-nsock distclean-nbase distclean-ndiff clean debugclean
	rm -f Makefile Makefile.bak makefile.dep nmap_config.h stamp-h \
	stamp-h.in config.cache config.log config.status

clean-pcap:
	-cd $(LIBPCAPDIR) && $(MAKE) clean && rm -f version.c pcap_version.h

clean-libssh2:
	-cd $(LIBSSH2DIR)/src && $(MAKE) prefix="" DESTDIR=$(NDIR)/$(LIBSSH2DIR) uninstall-libLTLIBRARIES
	-cd $(LIBSSH2DIR)/src && $(MAKE) prefix="" DESTDIR=$(NDIR)/$(LIBSSH2DIR) clean
	-cd $(LIBSSH2DIR) && $(MAKE) clean

clean-zlib:
	-cd $(ZLIBDIR) && $(MAKE) clean && cp zconf.h.clean zconf.h

clean-pcre:
	-cd $(LIBPCREDIR) && $(MAKE) clean

clean-dnet:
	-cd $(LIBDNETDIR) && $(MAKE) clean

clean-nbase:
	-cd $(NBASEDIR) && $(MAKE) clean

clean-nsock:
	-cd $(NSOCKDIR)/src && $(MAKE) clean

clean-netutil:
	-cd libnetutil && $(MAKE) clean

clean-ncat:
	-cd $(NCATDIR) && $(MAKE) clean

clean-lua:
	-cd $(LIBLUADIR) && $(MAKE) clean

clean-liblinear:
	-cd $(LIBLINEARDIR) && $(MAKE) clean

clean-zenmap:
	-cd $(ZENMAPDIR) && $(PYTHON) setup.py clean --all
	rm -f $(ZENMAPDIR)/zenmapCore/__init__.pyc
	rm -f $(ZENMAPDIR)/zenmapCore/Version.pyc
	rm -f $(ZENMAPDIR)/zenmapCore/Name.pyc

clean-ndiff:
	-cd $(NDIFFDIR) && $(PYTHON) setup.py clean --all

clean-nping:
	-cd $(NPINGDIR) && $(MAKE) clean

clean-tests:
	@rm -f tests/check_dns

distclean-pcap:
	-cd $(LIBPCAPDIR) && $(MAKE) distclean

distclean-libssh2:
	-cd $(LIBSSH2DIR)/src && $(MAKE) prefix="" DESTDIR=$(NDIR)/$(LIBSSH2DIR) distclean
	-cd $(LIBSSH2DIR) && $(MAKE) distclean

distclean-zlib:
	-cd $(ZLIBDIR) && $(MAKE) distclean

distclean-pcre:
	-cd $(LIBPCREDIR) && $(MAKE) distclean

distclean-dnet:
	-cd $(LIBDNETDIR) && $(MAKE) distclean

distclean-lua:
	-cd $(LIBLUADIR) && $(MAKE) clean

distclean-liblinear: clean-liblinear

distclean-nbase:
	-cd $(NBASEDIR) && $(MAKE) distclean

distclean-nsock:
	-cd $(NSOCKDIR)/src && $(MAKE) distclean

distclean-netutil:
	-cd libnetutil && $(MAKE) distclean

distclean-ncat:
	-cd $(NCATDIR) && $(MAKE) distclean

distclean-zenmap: clean-zenmap
	-cd $(ZENMAPDIR) && rm -rf MANIFEST build/ dist/ INSTALLED_FILES

distclean-ndiff: clean-ndiff
	-cd $(NDIFFDIR) && rm -rf ndiff.pyc build/ dist/ INSTALLED_FILES

distclean-nping:
	-cd $(NPINGDIR) && $(MAKE) distclean

clean-%:
	-cd $* && $(MAKE) clean

distclean-%: clean-%
	-cd $* && $(MAKE) distclean

install-nmap: $(TARGET)
	$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(mandir)/man1 $(DESTDIR)$(nmapdatadir)
	$(INSTALL) -c -m 755 nmap $(DESTDIR)$(bindir)/nmap
# Use strip -x to avoid stripping dynamically loaded NSE functions. See
# http://seclists.org/nmap-dev/2007/q4/0272.html.
	$(STRIP) -x $(DESTDIR)$(bindir)/nmap
	$(INSTALL) -c -m 644 docs/$(TARGET).1 $(DESTDIR)$(mandir)/man1/
	if [ "$(USE_NLS)" = "yes" ]; then \
	  for ll in $(filter $(ALL_LINGUAS),$(LINGUAS)); do \
	    $(INSTALL) -d $(DESTDIR)$(mandir)/$$ll/man1; \
	    $(INSTALL) -c -m 644 docs/man-xlate/$(TARGET)-$$ll.1 $(DESTDIR)$(mandir)/$$ll/man1/$(TARGET).1; \
	  done; \
	fi
	$(INSTALL) -c -m 644 docs/nmap.xsl $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 docs/nmap.dtd $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-services $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-payloads $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-rpc $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-os-db $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-service-probes $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-protocols $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 nmap-mac-prefixes $(DESTDIR)$(nmapdatadir)/

# Update the Ncat version number.
$(NCATDIR)/ncat.h: nmap.h
	sed -e 's/^#[ \t]*define[ \t]\+NCAT_VERSION[ \t]\+\(".*"\)/#define NCAT_VERSION "$(NMAP_VERSION)"/' $@ > $@.tmp
	mv -f $@.tmp $@

# Update the Nping version number. This is "0.NMAP_VERSION".
# If the 0. prefix is removed it must also be removed from nmap.spec.in.
$(NPINGDIR)/nping.h: nmap.h
	sed -e 's/^#[ \t]*define[ \t]\+NPING_VERSION[ \t]\+\(".*"\)/#define NPING_VERSION "0.$(NMAP_VERSION)"/' $@ > $@.tmp
	mv -f $@.tmp $@

# Update the version number used by Zenmap.
$(ZENMAPDIR)/zenmapCore/Version.py $(ZENMAPDIR)/share/zenmap/config/zenmap_version: nmap.h
	cd $(ZENMAPDIR) && $(PYTHON) install_scripts/utils/version_update.py "$(NMAP_VERSION)"

tests/check_dns: $(OBJS)
	 $(CXX) -o $@ $(CPPFLAGS) $(CXXFLAGS) $(LDFLAGS) $^ $(LIBS) tests/nmap_dns_test.cc

# By default distutils rewrites installed scripts to hardcode the
# location of the Python interpreter they were built with (something
# like #!/usr/bin/python2.4). This is the wrong thing to do when
# installing on a machine other than the one used to do the build. Use
# this as the location of the interpreter whenever we're not doing a
# local installation.
DEFAULT_PYTHON_PATH = /usr/bin/env python

build-zenmap: $(ZENMAPDIR)/setup.py $(ZENMAPDIR)/zenmapCore/Version.py
# When DESTDIR is defined, assume we're building an executable
# distribution rather than a local installation and force a generic
# Python interpreter location.
	cd $(ZENMAPDIR) && $(PYTHON) setup.py build $(if $(DESTDIR),--executable "$(DEFAULT_PYTHON_PATH)")

install-zenmap: $(ZENMAPDIR)/setup.py
	$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(mandir)/man1
	cd $(ZENMAPDIR) && $(PYTHON) setup.py --quiet install --prefix "$(prefix)" --force $(if $(DESTDIR),--root "$(DESTDIR)")
	$(INSTALL) -c -m 644 docs/zenmap.1 $(DESTDIR)$(mandir)/man1/
# Create a symlink from nmapfe to zenmap if nmapfe doesn't exist or is
# already a link.
	if [ ! -f $(DESTDIR)$(bindir)/nmapfe -o -L $(DESTDIR)$(bindir)/nmapfe ]; then \
		ln -sf zenmap $(DESTDIR)$(bindir)/nmapfe; \
	fi
# Create a symlink from xnmap to zenmap unconditionally.
	ln -sf zenmap $(DESTDIR)$(bindir)/xnmap

build-ndiff:
	cd $(NDIFFDIR) && $(PYTHON) setup.py build $(if $(DESTDIR),--executable "$(DEFAULT_PYTHON_PATH)")

build-nping: $(NPINGDIR)/Makefile build-nbase build-nsock build-netutil $(NPINGDIR)/nping.h build-dnet 
	@cd $(NPINGDIR) && $(MAKE)

install-ndiff:
	cd $(NDIFFDIR) && $(PYTHON) setup.py install --prefix "$(prefix)" $(if $(DESTDIR),--root "$(DESTDIR)")

NSE_FILES = scripts/script.db scripts/*.nse
NSE_LIB_LUA_FILES = nselib/*.lua nselib/*.luadoc

install-nse: $(TARGET)
	$(INSTALL) -d $(DESTDIR)$(nmapdatadir)/scripts
	$(INSTALL) -d $(DESTDIR)$(nmapdatadir)/nselib

# Remove obsolete scripts from a previous installation.
	(cd $(DESTDIR)$(nmapdatadir)/scripts && rm -f $(OLD_SCRIPT_NAMES))

	$(INSTALL) -c -m 644 nse_main.lua $(DESTDIR)$(nmapdatadir)/
	$(INSTALL) -c -m 644 $(NSE_FILES) $(DESTDIR)$(nmapdatadir)/scripts
	$(INSTALL) -c -m 644 $(NSE_LIB_LUA_FILES) $(DESTDIR)$(nmapdatadir)/nselib
	$(INSTALL) -d $(DESTDIR)$(nmapdatadir)/nselib/data
	for f in `find nselib/data -name .svn -prune -o -type d -print`; do \
		$(INSTALL) -d $(DESTDIR)$(nmapdatadir)/$$f; \
	done
	for f in `find nselib/data -name .svn -prune -o -type f -print`; do \
		$(INSTALL) -c -m 644 $$f $(DESTDIR)$(nmapdatadir)/$$f; \
	done

install-%: build-% %/Makefile
	cd $* && $(MAKE) install
uninstall-%: %/Makefile
	cd $* && $(MAKE) uninstall

install: install-nmap $(INSTALLNSE) $(INSTALLZENMAP) install-ncat $(INSTALLNDIFF) $(INSTALLNPING)
	@echo "NMAP SUCCESSFULLY INSTALLED"

uninstall: uninstall-nmap $(UNINSTALLZENMAP) uninstall-ncat $(UNINSTALLNDIFF) $(UNINSTALLNPING)

uninstall-nmap:
	rm -f $(DESTDIR)$(bindir)/$(TARGET)
	rm -f $(DESTDIR)$(mandir)/man1/$(TARGET).1
	rm -f $(DESTDIR)$(mandir)/*/man1/$(TARGET).1
	rm -rf $(DESTDIR)$(nmapdatadir)

uninstall-zenmap:
	cd $(ZENMAPDIR) && $(PYTHON) setup.py uninstall
	rm -f $(DESTDIR)$(mandir)/man1/zenmap.1
# Uninstall nmapfe only if it's a symlink.
	if [ -L $(DESTDIR)$(bindir)/nmapfe ]; then \
		rm -f $(DESTDIR)$(bindir)/nmapfe; \
	fi
	rm -f $(DESTDIR)$(bindir)/xnmap

uninstall-ndiff:
	cd $(NDIFFDIR) && $(PYTHON) setup.py uninstall

uninstall-ncat:
	@cd $(NCATDIR) && $(MAKE) uninstall

uninstall-nping:
	@cd $(NPINGDIR) && $(MAKE) uninstall

check-nse:
	./nmap -d --datadir . --script=unittest --script-args=unittest.run

check-ncat:
	@cd $(NCATDIR) && $(MAKE) check

check-ndiff:
	@cd $(NDIFFDIR) && $(PYTHON) ndifftest.py

check-nsock:
	@cd $(NSOCKDIR)/src && $(MAKE) check

check-zenmap:
	@cd $(ZENMAPDIR)/test && $(PYTHON) run_tests.py

check-dns: tests/check_dns
	$<

check: check-ncat check-nsock check-zenmap check-nse check-ndiff check-dns

${srcdir}/configure: configure.ac
	cd ${srcdir} && autoconf

## autoheader might not change config.h.in, so touch a stamp file.
#${srcdir}/config.h.in: stamp-h.in
#${srcdir}/stamp-h.in: configure.ac acconfig.h \
#	config.h.top config.h.bot
#	cd ${srcdir} && autoheader
#	echo timestamp > ${srcdir}/stamp-h.in
#
#config.h: stamp-h
#stamp-h: config.h.in config.status
#	./config.status

Makefile: Makefile.in config.status
	./config.status

config.status: configure
	./config.status --recheck

config.guess:
	wget -O $@ 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'

%/config.guess: config.guess
	cp $^ $@

config.sub:
	wget -O $@ 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'

%/config.sub: config.sub
	cp $^ $@

configfiles-update: config.guess config.sub nping/config.guess nping/config.sub ncat/config.guess ncat/config.sub

# Run the lua-format program to fix formatting of NSE files.
lua-format:
	./docs/style/lua-format -i scripts/*.nse

makefile.dep:
	$(CXX) -MM $(CPPFLAGS) $(SRCS) > $@
-include makefile.dep

# These the old names of scripts that have been renamed or deleted. Any
# scripts with these names will be deleted from the installation
# directory on "make install" so that duplicate, old copies of scripts
# are not run.
OLD_SCRIPT_NAMES = $(addsuffix .nse, \
anonFTP ASN asn-to-prefix brutePOP3 bruteTelnet chargenTest daytimeTest \
dns-safe-recursion-port dns-safe-recursion-txid dns-test-open-recursion \
domino-enum-passwords echoTest ftpbounce HTTPAuth HTTP_open_proxy HTTPpasswd \
HTTPtrace iax2Detect ircServerInfo ircZombieTest mac-geolocation MSSQLm \
MySQLinfo netbios-smb-os-discovery nfs-acls nfs-dirlist popcapa PPTPversion \
promiscuous RealVNC_auth_bypass ripeQuery robots showHTMLTitle \
showHTTPVersion showOwner showSMTPVersion showSSHVersion skype_v2-version \
smb-enumdomains smb-enumsessions smb-enumshares smb-enumusers \
smb-serverstats smb-systeminfo SMTPcommands SMTP_openrelay_test \
smtp-check-vulns SNMPcommunitybrute SNMPsysdescr SQLInject SSH-hostkey \
SSHv1-support SSLv2-support strangeSMTPport UPnP-info xamppDefaultPass \
zoneTrans db2-info db2-brute html-title robots.txt xmpp sql-injection \
http-robtex-reverse-ip http-vuln-zimbra-lfi http-vuln-0-day-lfi-zimbra \
whois db2-discover http-crossdomainxml http-email-harvest \
http-wordpress-plugins http-wp-plugins smb-check-vulns \
)

.PHONY: all clean install uninstall check static debug prerelease release-tarballs release-rpms web distclean lua-format
