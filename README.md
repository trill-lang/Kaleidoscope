# Kaleidoscope

Kaleidoscope is a language used in tutorials for the
[LLVM Compiler Project](llvm.org/docs/tutorial)

This repo contains an implementation of the Kaleidoscope compiler in Swift,
as it was presented to Playgrounds Conference on Feb. 23rd, 2017.

There are a few build instructions you'll need to follow before the
project will build:

- Install LLVM 3.9 using your favorite package manager. For example:
  - `brew install llvm`
- Ensure `llvm-config` is in your `PATH`
  - That will reside in the `/bin` folder wherever your package manager
    installed LLVM.
- `git clone https://github.com/trill-lang/LLVMSwift.git`
- Run `swift LLVMSwift/utils/make-pkgconfig.swift`
