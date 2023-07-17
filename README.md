<p align="center">
  <h1 align="center">vimless</h1>
  <img src="https://github.com/Reisen/vimless/assets/158967/292ea591-94f2-42f6-8e7d-0c0304287da6" alt="Vimless">
</p>

---

Vimless is a thin wrapper around a curated plugin-set with reasonable defaults.
All plugins have been configured for a consistent experience, with a focus on
adding discoverability.

Vimless comes with an opinionated set of defaults that can be controlled and
configured through a single straightforward configuration file. Vimless can
be as thin or featureful as you desire, see the [shipped configuration file][]
to get a feel.

Vimless also comes with a few custom plugins to tie the experience together, 
and to add discoverability which is typically lacking in the neovim plugin
ecosystem:

- [Tusk][], a Telescope based command-line inspired by Emacs ivy/vertico.
- A [Hydra based menu system][] like WhichKey but plugin focused.


Installing
--------------------------------------------------------------------------------

Neovim's configuration file typically goes in the following locations:

- Linux/Unix:               `git clone https://github.com/Reisen/vimless ~/.config/nvim/`
- macOS:                    `git clone https://github.com/Reisen/vimless ~/.config/nvim/`
- Windows (PowerShell):     `git clone https://github.com/Reisen/vimless $HOME\AppData\Local\nvim\`
- Windows (Command Prompt): `git clone https://github.com/Reisen/vimless %USERPROFILE%\AppData\Local\nvim\`

On first run Lazy will install and setup all plugins, various dependencies are
required for this to succeed:

- A rust installation.
- A C/C++ compiler of some flavor (clang or gcc).
- A node installation, more recent the better.
- The `gh` binary for Copilot/Github interactions.


Workflows
--------------------------------------------------------------------------------

There are lot's of neat tricks this configuration aims to provide for working
efficiently. Efficient here does not just mean fast, but also the aim to try
and provide as many ways to avoid going to your browser as possible. The main
thing you will want to get started though is to make sure you have LSP setup
correctly.

### Setup LSP

Vimless uses `mason-lsp` to auto-configure most LSP servers, however you will
still need to install the servers you wish to use. You will need to do this
once per language you wish to work with, for example to setup Rust:

- `SPC l m` to open Mason.
- `Ctrl+F` in the Mason window to search for Rust.
- Press `i` on `rust-analyzer` and `rustfmt` to install them.
- `:TSInstall rust` to get treesitter powered syntax highlighting.

Restart neovim for good measure.

Use the `SPC l` and `SPC f l` keymaps to explore LSP powered functionality.


### Example LSP Usage

There is a lot of power to LSP but the following are useful commands that I
suggeset trying:

- `SPC l R` allows rename refactoring. ALL files will be edited (remember to `:wa`)
- `SPC l a` over a symbol will suggest LSP powered refactoring actions.
- `SPC l d` is the fastest way to jump to the definition of any variable.
- `SPC l t` is the fastest way to jump from a variable to its type.
- `SPC l K` (which mirrors vim's bulit-in K) shows documentation for anything.
- `SPC l n` and `<space>lp` jump back and forward between errors.

While these directly plug into Neovim's LSP support, there is also a Telescope
powered LSP mode that is a lot more powerful. The binds are the same as the LSP
ones but additionally prefixed with `f`:

- `SPC f l d` jump to a definition if one, list if many.
- `SPC f l r` list all references to the symbol under the cursor.
- `SPC f l c` list all locations that call the current function.
- `SPC f l C` over function name, shows all calls made by that function.
- `SPC f l l` list all diagnostics for easy jumping to any error.

Unlike `SPC l` the Telescope `SPC f l` binds will show you an FZF powered
suggestion list when there is more than one result. For example when hovering
over the following:

```rust
type Foo = Arc<Mutex<usize>>;

fn example() {
    let foo: Foo = Arc::new(Mutex::new(0));
             ^
             |
      Cursor is here.
}
```

Pressing `SPC f l t` (find lsp type) to request the type definition for `Foo`
will provide a list of `Arc`, `Mutex` and `usize` so you can jump to any part
of a complex type quickly.

I heavily suggest playing with these features to get a feel for how rapidly you
can navigate your code. LSP is more than just diagnostics.

### Copilot

This repository comes with Copilot, which can be setup the standard way by
running `:Copilot auth` to configure your setup.
