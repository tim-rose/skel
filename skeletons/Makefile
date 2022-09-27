#
# Makefile --Rules for building skeleton archives.
#
# Remarks:
# This just blindly builds a shell archive from the contents
# of each of the sub-directories.
#
subdir = skel
include makeshift.mk

SKELDIRS = $(subst /,,$(wildcard */))

%.sha:
	(cd $* && find -L * -type f | xargs skel-shar -h) >$@

build: $(SKELDIRS:%=%.sha)

install: $(SKELDIRS:%=$(datadir)/%.sha)
uninstall: uninstall-skel
uninstall-skel:
	$(RM) $(SKELDIRS:%=$(datadir)/%.sha)

distclean clean: clean-skel
clean-skel:
	$(RM) $(SKELDIRS:%=%.sha)
