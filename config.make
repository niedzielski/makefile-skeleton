# debug with `V=1 make --jobs=1`.

# fail recipes on the first failing command.
.POSIX:

# report unitialized variable usage.
MAKEFLAGS += --warn-undefined-variables

# only use the rules and variables supplied.
MAKEFLAGS += --no-builtin-rules --no-builtin-variables

# parallelize by default. Everything should have correct dependencies. this also
# allows multiple watch tasks to execute in parallel without `xargs -P`.
MAKEFLAGS += --jobs

# use spaces instead of tabs for recipes.
empty :=
space := $(empty) $(empty)
.RECIPEPREFIX := $(space)

# execute each recipe in one shell and fail on first error and undefined
# variable usage within the recipe.
.ONESHELL:
.SHELLFLAGS := -euc

# don't echo recipes.
ifndef V
.SILENT:
endif

# if a recipe fails, delete the target.
.DELETE_ON_ERROR:

# preserve intermediate targets.
# this breaks shell autocomplete. See
# https://github.com/scop/bash-completion/issues/215.
.SECONDARY:

# preserve all and overwrite.
cp := cp --archive --force

# Only report warnings and errors.
# https://github.com/denoland/deno/issues/10558
# https://github.com/denoland/deno/issues/15828
# https://github.com/denoland/deno/issues/8890
deno := deno $(if $(value V),,--quiet)

# pverwrite destination.
ln := ln --force

# create directory hierarchies.
mkdir := mkdir --parents

# overwrite destination.
mv := mv --force

# delete hierarchy if present.
rm := rm --force --recursive

# silence sub-makes.
make = $(MAKE) $(if $(value V),,--quiet)
