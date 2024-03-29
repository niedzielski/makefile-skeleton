include config.make

dist_dir := dist
src_dir := src

src_files := $(wildcard $(src_dir)/*.foo)
dist_files := $(src_files:$(src_dir)/%.foo=$(dist_dir)/%.bar)

bundle_args ?=

# The default rule is build.
.PHONY: build
build: $(dist_files) bundle

# Copy doesn't have a watch mode so use Make to rebuild the target whenever any
# file in the repo changes. This may be a no-op if the file changed was
# irrelevant but that's what Make evaluates by examining the target's
# dependencies.
.PHONY: build-watch
build-watch:; watchexec --ignore='*/$(dist_dir)/*' '$(MAKE) --silent build'

$(dist_dir)/%.bar: $(src_dir)/%.foo | $(dist_dir)/; $(cp) '$<' '$@'

.PHONY: watch
watch: build-watch bundle-watch

.PHONY: bundle-watch
bundle-watch: bundle_args += --watch
bundle-watch: bundle

# Unlike `gcc --dependencies`, most tools do not generate Make dependency
# listings. For targets that may have their own dependency trees, such as a
# source file that imports other sources, the tool itself must be invoked to
# determine if the target is outdated.
.PHONY: bundle
bundle: | $(dist_dir)/
  $(deno) bundle '$(src_dir)/index.ts' '$(dist_dir)/index.js' $(bundle_args)

$(dist_dir)/:; $(mkdir) '$@'

.PHONY: clean
clean:; $(rm) '$(dist_dir)/'

.PHONY: rebuild
rebuild:
  $(make) clean
  $(make) build

.PHONY: retest
retest:
  $(make) clean
  $(make) test
