include defaults.make

dist_dir := dist
src_dir := src

src_files := $(wildcard $(src_dir)/*.foo)
dist_files := $(src_files:$(src_dir)/%.foo=$(dist_dir)/%.bar)

# The default rule is a development watch.
.PHONY: dev
dev: build\:watch

# Copy doesn't have a watch mode so use Make to rebuild the target whenever any
# file in the repo changes. This may be a no-op if the file changed was
# irrelevant but that's what Make evaluates by examining the target's
# dependencies.
.PHONY: build\:watch
build\:watch:
  watchexec -i dist '$(MAKE) --silent build'

.PHONY: build
build: $(dist_files)

$(dist_dir)/%.bar: $(src_dir)/%.foo | $(dist_dir)/
  $(cp) '$<' '$@'

$(dist_dir)/:; $(mkdir) '$@'

.PHONY: clean
clean:; $(rm) '$(dist_dir)/'
