<p align="center">
  <h1 align="center">vimless</h1>
  <img src="https://github.com/Reisen/vimless/assets/158967/292ea591-94f2-42f6-8e7d-0c0304287da6" alt="Vimless">
</p>

---

Unlike most Neovim configurations that tend to push towards getting vim closer
to an (IDE)-like experience, vimless is a configuration designed to _feel_ like
an enhanced vanilla Neovim with the objective of achieving optimal efficiency.
This means when you open vimless for the first time, it pretty much just looks
like neovim.

Vimless is a configuration focused on providing configuration focused on fast
editing with less emphasis on IDE-like UI features. The bindings defined are
hand-curated and intended to be focused on navigating and editing code quickly
with an uncluttered UI. The intent for this README is to provide an easy way to
get setup along with acollection of tricks for utilising the config to edit
code fast.

Don't want to read? Install and press `SPC h` to discover functionality on the
fly instead.


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
fast here is an assorted list of features and binds you might find useful to
get started:

- Discover Vimless features through `SPC h`. (hydra)
- Press `-` to immediately access the filesystem, pressing `-` again traverses up.
- You can edit the tree directly in this buffer! Just `:w` your changes! (dirbuf)
- Switch to a terminal with `Ctrl+\` instantly.
- Rapidly navigate windows and tabs with `SPC w` / `SPC t`.
- See all project errors/diagnostics with `SPC v t`. (trouble)
- Show a sidebar with currently open buffers with `SPC v n`. (neotree)
- Find anything with `SPC f`. (telescope)
- Toggle comments with `gcc` or entire selections with `gc`.
- Better mark experience when using `m<letter>` to set, adds `dm<letter>` to delete, adds visible mark gutter.
- Jump instantly to recently used files with `SPC j`.
- Jump to any text in-buffer by pressing `s` or `S` followed by two characters. (leap)
- Jump to any text on-screen with `gs` for multi-window. (leap)
- Access native LSP powers with `SPC l`. I.E: Try `<space>lR` to do rename refactoring. (lsp)
- Powerful Git integration with `SPC g`. (fugitive, octo)
- Strong integrated Rust support via `SPC r` (rust-tools, rust, crates)
- Powerful auto-completion powered by `nvim-cmp` that should just work. (cmp, lsp)
- Press `SPC z` to toggle focus a specific window when you want less clutter.
- Press `SPC v` to see vim related actions, I.E: `SPC v s` will sync your plugins.

The recommended set of commands to move around efficiently are the following:

- `s`, `S` and `gs` leap commands to move around buffers.
- `SPC j` for moving around open files.
- `Ctrl+o` / `Ctrl+i` for moving backwards and forwards through move history.
- `g;` for jumping to last edited position.
- `v` followed by `.` and `,` for treesitter selection expansion/reduction.
- `SPC f l d` / `SPC f l c` are powerful LSP commands for jumping to functions/call sites.
- `SPC l s` opens a function call in a pane to the right for function traversal.

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

- `SPC v m` to open Mason.
- `Ctrl+F` in the Mason window to search for Rust.
- `i` on `rust-analyzer` and `rustfmt` to instantly install them.
- `:TSInstall rust` to get treesitter powered syntax highlighting.

Restart neovim for good measure.

Once you have LSP, Vimless provides a ton of power for working with your code
base. You get all the IDE features you'd likely want, but hidden behind the
`SPC l` and `SPC f l` keymaps.

### Example LSP Usage

There is a lot of power to LSP but the following are the absolute most useful
commands that I suggeset trying if you haven't leveraged these before. By
having these a quick mapping away you can rapidly navigate and edit your code
with LSP:

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

### Copilot & GPT

This repository comes with Copilot, which can be setup the standard way by
running `:Copilot auth` to configure your setup. You may need the `gh` CLI
tool installed for this. Once setup completions should automatically work
in any supported buffer.

It also comes with a very thin wrapper around the ChatGPT API. THis requires
you to set your API key in an environment variable named `OPENAI_API_KEY` and
provides helpful commands for refactoring with ChatGPT. Visually select lines
you want to act on and:

- Press `SPC c r` to generate a code review.
- Press `SPC c i` to improve the code. ChatGPT will attempt to rewrite.
- Press `SPC c e` to get an explanation for the code.
- Press `SPC c g` to generate code from a short English explanation.

There are additionally two slightly more free-form ways to interact with
ChatGPT, the first allows you to specify your own instructions to perform on
the selected text:

- Press `SPC c c` to get a prompt to instruct ChatGPT with any request.

The second is closer to how ChatGPT's web UI works, simply write out your chat
message the way you would in the UI and use the following to get an answer.
Unlike the others which send the lines as context with an instruction this one
uses the text itself as the question/instruction:

- Press `SPC c p` to use the selected lines as a question.

### Utilising Git

By default, fugitive and gitsigns provide most of the interaction with Git.
Gitsigns provides the visual aspect (signs in gutter) and fugitive provides
interacting with git itself. You can hit `SPC g` to get access to some
common Git interactions.

To get started however, your best bet is to hit `SPC g e` to enter Git edit
mode. This provides a window from fugitive with the current repository status
in full view. The most common actions I perform personally:

- `-` toggles staging of an item.
- `=` shows diffs for a file.
- `czz` stashes everything, `czp` pops a stash.
- `cc` creates a new commit, write a message and `:wq` to save/quit/commit.
- `cf` while hovering over an unpushed commit creates a fixup commit.
- `ca` amends the previous commit.
- `rf` does a forced rebase, this is useful if you use fixup commits.
- `:Git <command>` can be used to perform any git command.

`SPC g n` and `SPC g p` will jump back and forward between changes in the file to
quickly move around a large file. `SPC g d` and `SPC g D` will show diff views
of the current repository.

Once done reviewing your changes, switching back to `SPC g e` to finalise
commits and push is the way to go (using fugitive).

### Utilising Octo

If you have the Github `gh` CLI tool you can also do all your PR reviewing via
this plugin. Once in a repository, hit `SPC o` to access pull requests and
issues. It's worth exploring the Octo docs for this one, but a common process I
find useful is to hit `<space>op` to access a PR list, once choosing one to
focus on you can use:

- `SPC c a` to add a comment
- `SPC p d` for a diff
- `SPC p f` for a list of modified files in the PR
- `SPC p c` for a list of commits in the PR
- `:Octo review start` to review the PR within vim
- `cs` to suggest code changes in a review (`ca` also works here)
- `]q` to move forward through the file list.

These are all you need to effectively review code, but it is thoroughly
suggested to read the Octo.nvim README because there's a lot of power in being
able to work with repos without leaving the editor.

### Dirbuf

As mentioned above, pressing `-` takes you to a view of the filesystem starting
at the current directory of the open file. This is very similar to what
`dirvish` and `vim-vinegar` show but dirbuf comes with extremely powerful file
management that neither of those plugins do.

The file list in this buffer is editable. You can enter insert mode and rename
all the files in the list, or add new lines. When you save this buffer, all the
changes made will be made by `dirbuf` atomically. It can handle recursively
renaming multiple files and tricky situations where you have cyclic renames
such as:

```
foo.txt -> bar.txt
bar.txt -> baz.txt
baz.txt -> foo.txt
```

It can figure out how to change these without mistakingly overwriting any file
unintentionally. You will never want to use `mv`/`cp` again.

### Terminals

The default `Ctrl+\` bind for terminals swaps between the editor view and a
full screen terminal. If you prefer to have an always showing terminal at the
bottom tray similar to other IDE's, you can use the following command:

```
:ToggleTerm direction=horizontal size=20
```

You can also modify `lua/plugins/toggleterm.lua` to make this the default if
preferred such that `Ctrl+\` opens the tray instead.
