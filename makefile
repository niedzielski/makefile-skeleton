include config.make

dist_dir := dist
src_dir := src

src_files := $(wildcard $(src_dir)/*.foo)
dist_files := $(src_files:$(src_dir)/%.foo=$(dist_dir)/%.bar)

# The default rule is build.
.PHONY: build
build: $(dist_files) bundle

# Copy doesn't have a watch mode so use Make to rebuild the target whenever any
# file in the repo changes. This may be a no-op if the file changed was
# irrelevant but that's what Make evaluates by examining the target's
# dependencies.
.PHONY: build\:watch
build\:watch:
  watchexec -i dist '$(MAKE) --silent build'

$(dist_dir)/%.bar: $(src_dir)/%.foo | $(dist_dir)/
  $(cp) '$<' '$@'

.PHONY: dev
dev: build\:watch bundle\:watch

.PHONY: bundle\:watch
bundle\:watch: | $(dist_dir)/
  $(deno) bundle '$(src_dir)/index.ts' '$(dist_dir)/index.js' --watch

# Unlike `gcc --dependencies`, most tools do not generate Make dependency
# listings. For targets that may have their own dependency trees, such as a
# source file that imports other sources, the tool itself must be invoked to
# determine if the target is outdated.
.PHONY: bundle
bundle: | $(dist_dir)/
  $(deno) bundle '$(src_dir)/index.ts' '$(dist_dir)/index.js'

$(dist_dir)/:; $(mkdir) '$@'

.PHONY: clean
clean:; $(rm) '$(dist_dir)/'
