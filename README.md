README
================================================================================

Unlike most Neovim configurations that tend to push towards getting vim closer
to an (IDE)-like experience, vimless is a configuration designed to _feel_ like
an enhanced vanilla Neovim with the objective of achieving optimal efficiency.
This means when you open vimless for the first time, it pretty much just looks
like neovim:

The primary aim of vimless is to navigate codebases at remarkable speed while
keeping the user interface clutter free. You still get LSP, diagnostics, error
information but the focus is shifted from high-density UI to high-speed
navigation. You can start with vimless as if it were standard vim and nothing
should be a surprise. The basic editor will feel just like vim, but you can
adopt several seemingly small improvements that combined will greatly increase
your editing efficiency.

Don't want to read? Install and press `<space>h` to get started.


Installing
--------------------------------------------------------------------------------

Neovim's configuration file typically goes in the following locations:

- Linux/Unix:               `~/.config/nvim/`
- macOS:                    `~/.config/nvim/`
- Windows (PowerShell):     `$HOME\AppData\Local\nvim\` or `$HOME\vimfiles\`
- Windows (Command Prompt): `%USERPROFILE%\AppData\Local\nvim\`

You can clone this repository into the apropriate folder above for your system.
When you first open vimless you will likely see errors. Run:

```
:PackerInstall
```

And restart vim. At some point I will automate this so it doesn't suck so much
but for now this project is still "just me".


Quick Tips and Features
--------------------------------------------------------------------------------

You can explore the config to find all the features available, or read the help
sections throughout this document, but as a nice introduction to get started
fast here are the features and binds you will find useful:

- Press `-` to immediately access the filesystem, pressing `-` again traverses up.
- Switch to a terminal with `Ctrl+\` instantly.
- You can edit the filesystem tree directly in the editor! Just `:w` your changes! (dirbuf)
- Rapidly navigate windows and tabs with `<space>w` / `<space>t`.
- Display all project errors with `<space>vt`. (trouble)
- Toggle comments with `gcc` or entire selections with `gc`.
- Better marks with `m<letter>` to set and `dm<letter>` to delete, with visible mark highlights.
- Discover Vimless features through `<space>h`. (hydra)
- Jump instantly to recently used files with `<space>j` with a single letter. (reach)
- Jump to any text in-buffer by pressing `s` or `S` followed by two characters. (leap)
- Jump to any text on-screen with `gs` to jump around multiple windows. (leap)
- Find anything you can think of with `<space>f`. (hydra, telescope, lsp, git)
- Access all LSP powers with `<space>l`. I.E: Try `<space>lR` to do rename refactoring. (lsp)
- Powerful Git integration with combined plugins. See "Using Git".
- Manage Github PR's/Issues easily through `<space>o`. (octo.nvim)
- Strong integrated Rust support via `<space>r` (rust-tools, rust, crates)
- Powerful auto-completion powered by `nvim-cmp` that should "Just Work". (cmp, lsp)

See more later in the README.

Of the above, the key things added that make navigation extra fast:

- `s`, `S` and `gs` leap commands.
- `<space>j` jumplist for moving around open files.
- `<space>ff` and LSP jumps.
- Mastering `Ctrl+o` / `Ctrl+p` for moving back and forward through all the
  above moves to fast forward around the document you're exploring.

Not that much to learn!


Workflows
--------------------------------------------------------------------------------

There are lot's of neat tricks this configuration aims to provide for working
efficiently. Efficient here does not just mean fast, but also the aim to try
and provide as many ways to avoid going to your browser as possible. The main
thing you will want to get started though is to make sure you have LSP setup
correctly.

### Setup LSP

You will need to do this once per language you wish to work with, for example
with Rust:

- `<space>vm` to open Mason.
- `Ctrl+F` in the Mason window to search for Rust.
- `i` on `rust-analyzer` and `rustfmt` to instantly install them.
- `:TSInstall rust` to get treesitter powered syntax highlighting.

Restart neovim for good measure.

Once you have LSP, Vimless provides a ton of power for working with your code
base. You get all the IDE features you'd likely want, but hidden behind the
`<space>l` and `<space>fl` keymaps.

### Example LSP Usage

There is a lot of power to LSP but the following are the absolute most useful
commands that I suggeset trying if you haven't leveraged these before. By
having these a quick mapping away you can rapidly navigate and edit your code
with LSP:

- `<space>lR` allows rename refactoring. ALL files will be edited (remember to `:wa`)
- `<space>la` over a symbol will suggest LSP powered refactoring actions.
- `<space>ld` is the fastest way to jump to the definition of any variable.
- `<space>lt` is the fastest way to jump from a variable to its type.
- `<space>lK` (which mirrors vim's bulit-in K) shows documentation for anything.
- `<space>ln` and `<space>lp` jump back and forward between errors.

Try the other binds that show when pressing `<space>l` to play around.

While these directly plug into Neovim's LSP support, there is also a Telescope
powered LSP mode that is a lot more powerful. The binds are the same as the LSP
ones but additionally prefixed with `f`:

- `<space>fld` jump to a definition if one, list if many.
- `<space>flr` list all references to the symbol under the cursor.
- `<space>flc` list all locations that call the current function.
- `<space>flC` over function name, shows all calls made by that function.
- `<space>fll` list all diagnostics for easy jumping to any error.

Unlike `<space>l` the Telescope `<space>fl` binds will show you an FZF powered
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

Pressing `<space>flt` (find lsp type) to request the type definnition for `Foo`
will provide a list of `Arc`, `Mutex` and `usize` so you can jump to any part
of a complex type quickly.

I heavily suggest playing with these features to get a feel for how rapidly you
can navigate your code. LSP is more than just diagnostics.

### Copilot & GPT

This repository comes with Copilot, which can be setup the standard way by
running `:Copilot auth` to configure your setup. You may need the `gh` CLI
tool installed for this. Once setup completions should automatically work
in any supported buffer.

It also comes with a very thin wrapper around the ChatGPT API. THis requires
you to set your API key in an environment variable named `OPENAI_API_KEY` and
provides helpful commands for refactoring with ChatGPT. Visually select lines
you want to act on and:

- Press `<space>cr` to generate a code review.
- Press `<space>ci` to improve the code. ChatGPT will attempt to rewrite.
- Press `<space>ce` to get an explanation for the code.
- Press `<space>cg` to generate code from a short English explanation.

There are additionally two slightly more free-form ways to interact with
ChatGPT, the first allows you to specify your own instructions to perform on
the selected text:

- Press `<space>cc` to get a prompt to instruct ChatGPT with any request.

The second is closer to how ChatGPT's web UI works, simply write out your chat
message the way you would in the UI and use the following to get an answer.
Unlike the others which send the lines as context with an instruction this one
uses the text itself as the question/instruction:

- Press `<space>cp` to use the selected lines as a question.

### Utilising Git

By default, fugitive and gitsigns provide most of the interaction with Git.
Gitsigns provides the visual aspect (signs in gutter) and fugitive provides
interacting with git itself. You can hit `<space>g` to get access to some
commong Git interactions.

To get started however, your best bet is to hit `<space>ge` to enter Git edit
mode. This provides a window from fugitive with the current repository status
in full view. The most common actions I perform personally:

- `-` toggles staging of an item.
- `=` shows diffs for a file.
- `czz` stashes everything, `czp` pops a stash.
- `cc` creates a new commit, write a message and `:wa`
- `cf` while hovering over an unpushed commit creates a fixup commit.
- `ca` amends the previous commit.
- `rf` does a forced rebase, this is useful if you use fixup commits.
- `:Git <command>` can be used to perform any git command.

You can toggle visual line diffs in your project with `<space>gd` which
highlights lines to quickly see what you've been modifying. `<space>gn` and
`<space>gp` will jump back and forward between changes in the file to
quickly move around a large file.

Finally, it is possible to do full repository git management by pressing the
`<space>gV` keymap, which you can navigate diffs and stage/unstage files with
full context of the repository. Once done, switching back to `<space>ge` to
finalise commits and push is the way to go.

### Utilising Octo

If you have the Github `gh` CLI tool you can also do all your PR reviewing via
this plugin. Once in a repository, hit `<space>o` to access pull requests and
issues. It's worth exploring the Octo docs for this one, but a common process I
find useful is to hit `<space>op` to access a PR list, once choosing one to
focus on you can use:

- `<space>ca` to add a comment
- `<space>pd` for a diff
- `<space>pf` for a list of modified files in the PR
- `<space>pc` for a list of commits in the PR
- `<space>r+` for a thumbs up emoji (see octo.nvim for other reactions)
- `:Octo review start` to review the PR within vim
- `<space>cs` to suggest code changes (`ca` still works)
- `]q` to move forward through the file list.

These are all you need to effectively review code, but it is thoroughly
suggested to read the Octo.nvim README because there's a lot of power in being
able to work with repos without leaving the editor.
