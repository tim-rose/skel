# The Skel Templates Library

This repository contains a collection of templates that can be used as
a starting point for common software, document, project artefacts.

It comprises:

* *bones* --some samples of files that are common to several skeletons
* *skeletons* --some templates of either a complete project, or
  fragments thereof.

The templates are built into self-extracting **sh** archives.  These
can be extracted using the **skel** utility.

## Installation

To build and install these templates, run the following commands.

```bash
$ make build
$ make install
```

## Usage

To list currently available templates:

```bash
$ skel --list

c-module
c-project
python-project
sh-project
```

To actually apply/use a template use **skel**, e.g.

```bash
$ skel --verbose --name new_name c-project

skel info: skel version v0.2.0
skel info: loading skeleton "/usr/local/share/skel/c-project.sha"
skel info: new_name/doxygen_config text
skel info: new_name/new_name.c text
skel info: new_name/LICENSE text
skel info: new_name/test/test-new_name.c text
skel info: new_name/test/Makefile text
skel info: new_name/test/test-exec.sh text
skel info: new_name/libnew_name/new_name.c text
skel info: new_name/libnew_name/Makefile text
skel info: new_name/libnew_name/new_name.h text
skel info: new_name/Makefile text
skel info: new_name/README.md text
skel info: new_name/new_name.1 text
skel info: new_name/new_name.conf text
skel info: new_name/Doxyfile text
```

## Requirements

[makeshift](https://github.com/tim-rose/makeshift)
: a make-based build system

[skel](https://github.com/tim-rose/skel)
: a simple template expander that does keyword substitution.

# Make Your Own Templates

It's easy to make your own template:

* Create a set of files or directoies using the word "skeleton" for a
  name that will be substited later, when the skeleton is expanded.
  (Both in the name of the directory or file, or in the file contents).

* Package the collection into a self-extracting **sh**(1) archive
  using the **skel-shar** command:

```bash
$ skel-shar some-files... >/usr/local/share/skel/my-template.sha
```

Note that **skel**(1) looks for templates in */usr/local/share/skel/*
by default, but you can create and nominate other directories as you
wish.  See **skel**'s manual page for details.

Of course if you're adding a template to *this* repository, just add
your new files to a new directory in *skeletons/", and the build
system will take care of the rest.
