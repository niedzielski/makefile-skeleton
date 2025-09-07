# 🦴 makefile-skeleton

A template for small makefiles with defaults I've found useful. There are two
parts:

- **config.make**: the default settings I wish Make had plus some command
  aliases. This file probably won't change much from project to project. It's
  the most important part of this skeleton.
- **makefile**: an example makefile that imports config.make. Most projects will
  have very different project-specific recipes but still import config.make.

## Complementary tools

- [watchexec](https://watchexec.github.io) for tools that don't have a watch
  command.

V=1 make --directory=atlas-pack rebuild

## License (public domain)

All code in this repository is public domain and may be used without limitation.
