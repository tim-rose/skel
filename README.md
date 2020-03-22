# Skel: Create Files from Skeleton Templates

Software is rarely written in a vacuum, created from nothing but
imagination.  Despite the best intentions of the language designer and
the developer, there will always be some "boiler plate" code; code
that includes common definitions, or performs common tasks.

**Skel** is designed to make it easy to manage and use boilerplate code.
It is structured as a library of template files, and a shell script
to unpack a skeleton template while making some systematic substitutions.

The names and the contents of the files in the skeleton are modified
such that the text "skeleton" is substituted with a generated name.

e.g., if the core name is foo_bar:

* `skeleton` is changed to `foo_bar`
* `Skeleton` is changed to `FooBar`
* `SKELETON` is changed to `FOO_BAR`.

**Skel** is written as a POSIX shell script, so it should run fine
in any sufficiently POSIX environment (e.g. Linux, Darwin, Cygwin,
etc.).

Binary files are opportunistically opened as **zip** files, and (if
successful) the contents undergo substitution.

**Skel** is inspired by *Unix's* skeleton home directory facility, and
of course the purpose-built facilities used by some common complex
frameworks (e.g. *Rails*, *Django*, *Android* etc.). However, it
aims to be more general in its application.

## Requirements

* [devkit](https://github.com/tim-rose/devkit) --a make-based build system
* [midden](https://github.com/tim-rose/midden) --a library of shell code

## Installation

```bash
$ make install
```

## Getting Started

To create a file based on a skeleton, type `skel -n <name> <skeleton>`:

```bash
$ skel -v -n my_thing c-project.sha
skel info: skel version local.latest
skel info: loading skeleton "/usr/local/share/skel/c-project.sha"
skel info: my_thing/my_thing.c text
skel info: my_thing/LICENSE text
skel info: my_thing/test/test-my_thing.c text
skel info: my_thing/test/Makefile text
skel info: my_thing/libmy_thing/my_thing.c text
skel info: my_thing/libmy_thing/Makefile text
skel info: my_thing/libmy_thing/my_thing.h text
skel info: my_thing/Makefile text
skel info: my_thing/README.md text
skel info: my_thing/my_thing.1 text
skel info: my_thing/my_thing.conf text
$ ls -l my_thing
total 28
-rw-rw-r-- 1 timmo admin 1053 Mar 13 18:07 LICENSE
-rw-rw-r-- 1 timmo admin  273 Mar 13 18:07 Makefile
-rw-rw-r-- 1 timmo admin  837 Mar 13 18:07 README.md
drwxrwxr-x 5 timmo admin  160 Mar 13 18:07 libmy_thing
-rw-rw-r-- 1 timmo admin 2954 Mar 13 18:07 my_thing.1
-rw-rw-r-- 1 timmo admin 4216 Mar 13 18:07 my_thing.c
-rw-rw-r-- 1 timmo admin  230 Mar 13 18:07 my_thing.conf
drwxrwxr-x 4 timmo admin  128 Mar 13 18:07 test
```

There are two parts to **skel**:

 * the command
 * a library of skeleton files.

Although **skel** installs a set of skeletons, it is very likely that
you'll want to create your own skeletons to suit the files and file
types that you're working with.

To see the list of skeletons installed, type `skel -l`; it will list
all the skeleton files it can find:

```bash
$ skel -l

/usr/local/lib/skel:
c-project.sha  python-project.sha
```

By default, **skel** searches for skeletons files in
*/usr/local/lib/skel*, but you can specify an alternative list of
(colon-separated) paths in the environment variable `SKELPATH`, or via
the command option `--include`.

## Usage

## Licence
copyright &copy; Tim Rose 2020.
This code is licensed under the MIT licence.

## TODO

* `bash` autocompletion
* lots more skeletons!
