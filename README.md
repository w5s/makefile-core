# Makefile core module

> Core functions for makefiles (module management, help)

## Getting Started

Makefile technology has some drawbacks but it is reliable, language agnostic and available by default on most platform.
This project aims to standardize most common functionalities. Simply copy and include `core.mk` in your project and start building your project !

## Features

- 📦 Simple dependency manager (using git submodule)
  - ✓ No extra dependency
  - ✓ Lightweight implementation
  - ✓ Compatible dependency maintainer bot (Renovate)
- ℹ️ Automatic help generator, based on comments
- ⚒️ Everything is customizable using `Makefile.local`

## Installation

### Installer (Recommended)

```console
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/w5s/makefile-core/main/install.sh)"
```

### Manual (Alternate)

**1. Copy `core.mk` to your project**

```shell
my-project/
├─ .modules/
│  ├─ core.mk <- COPY https://raw.githubusercontent.com/w5s/makefile-core/main/core.mk
├─ Makefile
```

**2. Include `.modules/core.mk` in your `Makefile`**

```makefile
# At the start of Makefile

include .modules/core.mk
```

**3. Test that everything is working**

```console
> make help

```

## Usage

### `make help`

Display all available targets and flags

> [!TIP]
>
> Help command output is automatically generated by reading annotations in the Makefiles.
>
> Here is an example of annotated Makefile
>
> ```makefile
> # For a target, add a comment at the end of line
> my_target: ## Do something
>
> # For a variable, add a comment on the line before and declare using ?=
> ## This is a variable
> MY_VARIABLE ?= my-value
>
> ```
>
> Will display
>
> ```console
>> make help
>
> ...
> Targets :
> ...
>     my_target       Do something
> ...
> Flags:
> ...
>     MY_VARIABLE      This is a variable
> ...
> ```

### `make self-add`

Add a makefile module (as git submodule). If a `./module.mk` is found it will be automatically included.

Example :

```console
> make self-add url=https://github.com/ianstormtaylor/makefile-assert
# It will add /.modules/makefile-assert git submodule
```

> [!NOTE]
>
> Running this command will create a folder inside `.modules/` using git subtree and a `module.json` file.
>
> All modification should be versioned in git.

### `make self-update`

Update all makefile modules

Example :

```console
> make self-update
```

### `make print-env`

Display all env variables exported by make. This is useful for debugging. Another use is for dumping environment and use it in `Makefile.local` to be loaded elsewhere.

Example :

```console
> make print-env > Makefile.local
# This will create a Makefile.local that can be used to initialize all environment variables used by the environment
```

### `make print-variables`

Print every declared variables (often for debugging)

Example :

```console
> make print-variables
```

### `make print-%`

Print a given variable

Example :

```console
> make print-VAR
# This will display the value of $(VAR)
```

## Configuration

Override any variables/targets by creating `Makefile.local` / `Makefile.config`

```shell
my-project/
├─ .modules/
│  ├─ ...
├─ Makefile
├─ Makefile.config <- Will override (versioned)
├─ Makefile.local <- Will override (not versioned)
```

> [!NOTE]
>
> Including  `.modules/core.mk`  will also include files in the following order
>
> 1. `<projectDir>/Makefile.local` (not versioned file)
> 2. `<projectDir>/Makefile.config` (versioned file)
> 3. `<projectDir>/.modules/core.mk` (default values)
> 4. `<projectDir>/.modules/*/module.mk`

## Contributing

TODO

## Acknowledgement

This repository is a copy of [Captive-Studio/makefile-core](https://github.com/Captive-Studio/makefile-core) . jpolo was the author of both, but Captive-Studio team will keep on maintaining their copy.

These repository were inspirations to build makefile-core :

- [https://github.com/ianstormtaylor/makefile-help](https://github.com/ianstormtaylor/makefile-help)
- [https://github.com/tmatis/42make](https://github.com/tmatis/42make)

## License

<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[${license}][license-url] © ${author}) -->

[MIT][license-url] © Julien Polo

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- VARIABLES -->

<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[package-version-svg]: https://img.shields.io/npm/v/${name}.svg?style=flat-square) -->

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[package-url]: https://www.npmjs.com/package/${name}) -->

<!-- AUTO-GENERATED-CONTENT:END -->

<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[license-image]: https://img.shields.io/badge/license-${license}-green.svg?style=flat-square) -->

<!-- AUTO-GENERATED-CONTENT:END -->

[license-image]: https://img.shields.io/badge/license-MIT-green.svg?style=flat-square
[license-url]: ./LICENSE
