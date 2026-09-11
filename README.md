# Homebrew Tap

Install by fully-qualified name to trust only the formula or cask you need
and avoid Homebrew's untrusted-tap warning:

```console
brew install mattt/tap/emcee
brew install mattt/tap/jishuken
brew install mattt/tap/olleh
brew install --cask mattt/tap/companion
brew install --cask mattt/tap/imcp
```

If you've already tapped and install by short name, trust the formula or cask once:

```console
brew trust --formula mattt/tap/emcee
brew trust --cask mattt/tap/companion
```

## Formulas

- **[emcee](https://github.com/mattt/emcee)** - MCP generator for OpenAPIs 🫳🎤💥
- **[jishuken](https://github.com/mattt/jishuken)** - Self-verifying memory for agents; installs the `ken` command
- **[olleh](https://github.com/mattt/olleh)** - Ollama-compatible CLI for Apple's Foundation Models

## Casks

- **[companion](https://github.com/mattt/Companion)** - Your neighborhood friendly MCP utility for macOS, iOS, and visionOS
- **[imcp](https://github.com/mattt/iMCP)** - A macOS app that provides an MCP server to your Messages, Contacts, Reminders and more

## Jishuken releases

Jishuken installs precompiled `ken` binaries for macOS 11 or later (Apple
Silicon and Intel) and Linux (ARM64 and x86-64). Rust is not required.

The **Update jishuken** workflow checks hourly for the latest stable release.
It waits for all four archives and `SHA256SUMS`, verifies each download, then
installs and tests the formula before committing the update. Run the workflow
manually to update immediately. No cross-repository token is needed.
