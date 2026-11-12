# sungp Neovim

Language: [English](README.md) | [Tiếng Việt](README.vi.md)

An IDE-style Neovim configuration for Python, Go, JavaScript/TypeScript, Java,
C/C++, Lua, Shell, YAML/TOML and Markdown. It is built on Neovim 0.12's native
LSP, `lazy.nvim`, Blink completion, FzfLua, Treesitter, DAP and Neotest, with a
Snacks dashboard and 14 lazy-loaded themes.

- **Fast**: every plugin is lazy-loaded by event, command, key or filetype;
  only the active theme is sourced; large files switch to a light mode.
- **Complete**: LSP, completion, Copilot, formatting, linting, debugging,
  testing, Git, sessions, terminals and an AI chat (CodeCompanion).
- **Configurable**: personal settings live in one ignored file,
  `lua/config/local.lua`; theme and transparency choices are remembered.
- **Portable**: one configuration for macOS, Linux/WSL2 and Windows.

## Contents

- [Install](#install)
- [Requirements](#requirements)
- [After installing](#after-installing)
- [Layout](#layout)
- [Personal settings](#personal-settings)
- [Themes and UI](#themes-and-ui)
- [Keymaps](#keymaps)
- [Languages](#languages)
- [Plugins](#plugins)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

## Install

Run **one command for your system** as your regular user (not root). The
installer uses Homebrew on macOS/Linux and Scoop on Windows, backs up an
existing config as `nvim.backup-<timestamp>`, installs plugins at the locked
versions, then installs language servers, tools and Treesitter parsers. It
needs internet access, several minutes and a few GB of disk space. Rerun the
same command to resume an interrupted install.

### macOS

```bash
bash -c 'p=$(mktemp) && curl --fail --location --retry 3 https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.sh -o "$p" && bash "$p"; s=$?; rm -f "$p"; exit "$s"'
```

### Ubuntu / Debian / WSL2

```bash
sudo apt-get update && sudo apt-get install -y curl && bash -c 'p=$(mktemp) && curl --fail --location --retry 3 https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.sh -o "$p" && bash "$p"; s=$?; rm -f "$p"; exit "$s"'
```

### Fedora

```bash
sudo dnf install -y curl && bash -c 'p=$(mktemp) && curl --fail --location --retry 3 https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.sh -o "$p" && bash "$p"; s=$?; rm -f "$p"; exit "$s"'
```

### Arch Linux

This command performs a full system upgrade to avoid partial upgrades.

```bash
sudo pacman -Syu --needed --noconfirm curl && bash -c 'p=$(mktemp) && curl --fail --location --retry 3 https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.sh -o "$p" && bash "$p"; s=$?; rm -f "$p"; exit "$s"'
```

### Windows 10/11 x64

Run in a regular, non-administrator PowerShell window.

```powershell
& { $ErrorActionPreference = 'Stop'; Set-ExecutionPolicy Bypass -Scope Process -Force; $p = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.ps1'); Invoke-WebRequest 'https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.ps1' -UseBasicParsing -OutFile $p; try { & $p } finally { Remove-Item $p } }
```

Open a **new terminal** afterwards and run `nvim .`. Use a Nerd Font in the
terminal for icons.

What the installer adds: Neovim, Git, ripgrep, fd, fzf, lazygit, make, unzip,
Node 24, Python 3.13, Go, JDK 25, Maven and clang-format (Windows: Zig, GCC and
LLVM for parsers); a pinned `tree-sitter-cli` under Neovim's data directory;
and a generated, ignored `lua/config/toolchain.lua` that points Neovim at those
runtimes.

### Manual install

```bash
git clone https://github.com/sung2708/nvim-config.git ~/.config/nvim
sh ~/.config/nvim/bin/check-environment.sh   # Windows: bin\check-environment.ps1
nvim
```

lazy.nvim installs the plugins on first start; Mason then installs language
servers and tools in the background.

On macOS/Linux, for a manual or Stow setup, Volta can supply Node and npm,
and uv can supply Python-based tools in isolated environments:

```sh
volta install node@24
uv python install 3.13
uv tool install --managed-python --python 3.13 clang-format
uv tool install --managed-python --python 3.13 basedpyright
npm install --prefix "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/nvim-config/toolchain" \
  --save-exact tree-sitter-cli@0.26.11
```

Neovim discovers the default Volta and uv bin directories and the installed
Tree-sitter binary. Use `VOLTA_HOME` and `UV_TOOL_BIN_DIR` for custom locations.
If a custom tool path is missing inside an existing tmux session, follow the
[tmux PATH refresh steps](../README.md#refresh-tmux-path).
Mason still manages the other language tools. After replacing a runtime,
run `:ConfigHealth` and `:ConformInfo`. If a Mason executable has a broken
link or interpreter, reinstall it with `:MasonInstall --force <package>`.
Install the C compiler, JDK 25 and Maven via your system package manager
when needed. `pngpaste` on macOS is optional for pasting images into chat.

## Requirements

| Required | Why |
| --- | --- |
| Neovim **0.12+** | Native LSP, inline completion (Copilot), Treesitter `main` |
| git, curl, unzip | Plugins and Mason packages |
| ripgrep, fzf | Search and pickers |
| A C compiler (`cc`/`clang`/`gcc`; Zig on Windows) and `tree-sitter` CLI | Building Treesitter parsers |

| Optional | Used for |
| --- | --- |
| fd | Faster file search (ripgrep is the fallback) |
| Node.js / npm | Many language servers, Copilot language server |
| Python 3, Go, JDK 25 + Maven/Gradle | Python, Go and Java tooling |
| lazygit, lazydocker | `Space gG`, `Space ld` |
| codex, codex-acp | CodeCompanion AI chat |
| pngpaste (macOS), xclip or wl-clipboard (Linux) | Clipboard and pasting images into AI chat |

`bin/check-environment.sh` (or `.ps1`) reports what is missing.

## After installing

1. Open Neovim and run `:ConfigHealth` — it checks this configuration and its
   external tools.
2. Run `:LspCopilotSignIn` once if Copilot asks you to sign in (an existing
   copilot.vim/VS Code sign-in is reused).
3. Pick a theme with `Space ut`; it becomes the default.
4. Press `Space` and wait: which-key lists every group of shortcuts.

## Layout

```text
init.lua                 entry point: require("config")
lua/config/              core: options, keymaps, autocmds, lazy.nvim, theme,
                         copilot, health, parsers, local.example.lua
lua/plugins/             lazy.nvim plugin specs, one file per area
                         (ui, themes, editor, search, navigation, lsp,
                         completion, git, debug, terminal, sessions, ai, ...)
lua/integrations/        setup code for larger plugins (lsp, snacks, noice,
                         lualine, hlchunk, codecompanion, java, dap, ...)
lua/helper/              shared helpers (lazy-loading, project root, format)
after/ftplugin/          per-language indentation
bin/                     installers, bootstrap, environment checks
tests/                   headless regression tests
lazy-lock.json           locked plugin versions
```

Ignored, machine-local files: `lua/config/local.lua` (your settings),
`lua/config/toolchain.lua` (written by the installer), `.nvim-data/` (test
scratch) and logs.

## Personal settings

Copy `lua/config/local.example.lua` to `lua/config/local.lua`. It loads before
everything else and is ignored by Git.

| Setting | Default | Effect |
| --- | --- | --- |
| `vim.g.sungp_low_spec = true` | `false` | Lighter profile for slow machines (no dashboard, breadcrumbs, relative numbers) |
| `vim.g.sungp_transparent = false` | `true` | Start with opaque themes (`Space uT` toggles and remembers) |
| `vim.g.sungp_indent_guide_hl = "Comment"` | auto | Colour of indent guides (group name or `"#rrggbb"`) |
| `vim.g.sungp_diagnostic_lines = false` | `true` | Full diagnostic text under the cursor line (`Space uv`) |
| `vim.g.sungp_inlay_hints = true` | `false` | Show LSP inlay hints on attach (`Space ci` per buffer) |
| `vim.g.sungp_copilot = false` | `true` | Disable Copilot entirely (`Space uA` toggles suggestions) |
| `vim.g.sungp_animations = true` | `false` | Animated notifications |
| `vim.g.sungp_bigfile_lines` / `_line_length` | `10000` / `2000` | Large-file thresholds (also > 1 MiB) |
| `vim.g.autoformat_timeout_ms` | `1000` | Format-on-save timeout |
| `vim.g.python3_host_prog` | unset | Re-enable the Python provider (off; no plugin needs it) |
| `vim.env.JAVA_HOME` | detected | JDK used by jdtls |

The default theme is set in `lua/config/theme.lua` (`M.name`).

## Themes and UI

Installed themes (all transparent by default): Kanagawa, Catppuccin, Tokyo
Night, Rosé Pine, Nightfox (carbonfox, duskfox, nordfox, terafox, dawnfox,
dayfox), OneDark, Gruvbox Material, Everforest, Cyberdream, Vague, Nordic,
VS Code, Dracula and Solarized Osaka.

- `Space ut` picks a theme with live preview. The theme you keep (or set with
  `:colorscheme`) is restored next time; `:ThemeReset` returns to the default.
- `Space uT` toggles a transparent background for every theme and remembers
  it. Light variants (latte, day, dawn, lotus, light) always keep their own
  background so they stay readable.
- With a transparent background, indent guides and line numbers are lifted
  towards the Comment colour so they stay visible on translucent terminals.
- Floats, pickers, completion, Noice, which-key and Trouble share one surface
  and border style across themes.

UI pieces: Snacks dashboard and notifier, Noice command line, Lualine (Git
branch/diff from Gitsigns, LSP progress, active servers, Python venv),
Bufferline, Dropbar breadcrumbs, hlchunk block outlines and indent guides,
render-markdown, nvim-ufo folds.

## Keymaps

`Space` is the leader key (`\` is the local leader). Press `Space` and wait to
see every group, or search all mappings with `Space fk`.

### Basics and windows

| Key | Action |
| --- | --- |
| `Alt+h/j/k/l` | Move between windows (also from a terminal) |
| `Ctrl+Up/Down/Left/Right` | Resize the window |
| `Esc` | Clear search highlight |
| `n` / `N`, `Ctrl+d` / `Ctrl+u` | Search and half-page scroll, centred |
| `Space j` / `Space k` | Move line or selection down / up |
| `Space mh` / `Space ml` | Move line or selection left / right |
| `<` / `>` (Visual) | Indent and keep the selection |
| `Space uz` / `Space uZ` | Zen mode / zoom window |
| `Space u.` / `Space uS` | Scratch note / pick a scratch note |

### Files, search and explorer

| Key | Action |
| --- | --- |
| `Space ff` | Find files in the project |
| `Space fF` / `Space fe` | Find files in cwd / in the current file's folder |
| `Space fg` | Grep the project (`Space fI` with globs, `Space fG` cwd, `Space fE` file's folder) |
| `Space fw` | Grep the word under the cursor or the selection |
| `Space fb` / `Space fO` | Open buffers / recent files |
| `Space fl` / `Space fh` / `Space fk` | Lines in buffer / help / keymaps |
| `Space fy` | Yank history |
| `Space fR` | Resume the last picker |
| `Space fr` | Search and replace (grug-far); on a selection: replace it |
| `Space fm` / `Space fM` | Tag the file (Grapple) / list tagged files |
| `Space f1`…`Space f4` | Jump to tagged file 1–4 |
| `Space E` | Toggle the Neo-tree explorer |
| `Ctrl+n` | Reveal the current file in Neo-tree |
| `-` | Open the parent folder in Oil (edit names, `:w` to apply) |
| `Space fo` | Oil in a floating window |
| `Space sd` | Open the dashboard |

Dashboard keys: `f` files, `g` grep, `b` buffers, `e` explorer, `s` Git
status, `d` diff view, `x` diagnostics, `t` tests, `c` config files, `n` new
file, `q` quit.

### Buffers

| Key | Action |
| --- | --- |
| `]b` / `[b` | Next / previous buffer |
| `Space bc` | Close the buffer, keep the window layout |
| `Space bp` | Pin the buffer |
| `Space be` / `Space bq` | Move the buffer right / left |

### Editing

| Key | Action |
| --- | --- |
| `s` / `S` | Flash jump / Treesitter selection (`Space mS` in Visual) |
| `ys{motion}{char}`, `ds{char}`, `cs{old}{new}` | Add / delete / change surroundings (`S` in Visual; `f` = function call, `t` = tag) |
| `gS` | Split or join arguments (Visual: surround on new lines) |
| `gc`, `gcc` | Comment by motion / line |
| `Alt+n` / `Alt+p` | Add a cursor at the next / previous match |
| `Alt+a` / `Alt+x` | Cursors on all matches / skip a match |
| `Alt+Down` / `Alt+Up` | Add a cursor below / above |
| `Esc` | Clear multiple cursors |
| `Ctrl+a` / `Ctrl+x` | Increment / decrement numbers, dates, booleans, semver |
| `p` / `P`, `[y` / `]y` | Paste, then cycle through yank history |
| `Alt+e` (Insert) | Fast-wrap with autopairs |
| `Space mp` / `Space mP` | Swap with the next / previous parameter |
| `zR` / `zM` / `zr` / `zm` / `zK` | Folds: open all / close all / open level / close level / peek |

Text objects: `af`/`if` function call, `am`/`im` function, `ac`/`ic` class,
`as` scope, `iH` highlighted block, plus the mini.ai set (`a(`, `i"`, `aq`,
`ab`, …).

### Moving through code

| Key | Action |
| --- | --- |
| `]m` / `[m`, `]M` / `[M` | Function start / end |
| `]]` / `[[`, `][` / `[]` | Class start / end |
| `]o` / `[o` | Loop |
| `]C` / `[C` | Conditional |
| `]s`, `]z` | Scope, fold |
| `]d` / `[d` | Diagnostic (with float) |
| `]q` / `[q` | Quickfix item |
| `]t` / `[t` | TODO comment |
| `]c` / `[c` | Git hunk |
| `]x` / `[x`, `]i` / `[i`, `]j` / `[j`, `]w` / `[w` | Conflict marker, indent change, jump list, window |
| `Space ;`, `[;`, `];` | Breadcrumb symbol picker, context start, next context |

### LSP and diagnostics

| Key | Action |
| --- | --- |
| `gd` / `gy` / `gI` | Definitions / type definitions / implementations (FzfLua) |
| `grr` / `gO` | References / document symbols |
| `Space cS` | Workspace symbols |
| `K` (or `Space e`) | Hover |
| `Space rn` | Rename with live preview |
| `Space ca` | Code action |
| `Space cd` | Line diagnostics |
| `Space ci` | Toggle inlay hints |
| `Space cR` | Rename the file and update imports |
| `Space xx` / `Space xX` | Diagnostics in Trouble: workspace / buffer |
| `Space cs` / `Space cl` | Symbols / LSP references in Trouble |
| `Space xD` | Diagnostics to quickfix |
| `Space xt` / `Space xf` / `Space xq` | TODOs in Trouble / Snacks picker / quickfix |
| `Space xF` / `Space xR` | TODO/FIX/FIXME in FzfLua / Trouble |
| `Space qf` / `Space qF` | Toggle / focus quickfix |
| `Space uv` / `Space ud` | Toggle diagnostic lines / all diagnostics |

Neovim's own `gra`, `grn`, `gri`, `grt` and `Ctrl+s` (signature in Insert)
also work.

### Completion and Copilot

| Key (Insert) | Action |
| --- | --- |
| `Tab` | Accept the completion item → jump in a snippet → accept Copilot → indent |
| `Shift+Tab` | Previous item / snippet jump back |
| `Ctrl+n` / `Ctrl+p`, `Ctrl+j` / `Ctrl+k` | Select next / previous |
| `Ctrl+Space` | Open the menu or documentation |
| `Ctrl+y` / `Ctrl+e` | Accept / close |
| `Ctrl+b` / `Ctrl+f` | Scroll documentation |
| `Ctrl+l` | Signature help |
| `Alt+]` / `Alt+[` | Next / previous Copilot suggestion |

`Enter` never accepts a completion. Copilot uses Neovim's built-in inline
completion with Mason's `copilot-language-server`; `Space uA` toggles it.

### Formatting and linting

| Key / command | Action |
| --- | --- |
| `Space cf` | Format the buffer or selection |
| `Space uf` / `Space uF` | Toggle format-on-save globally / for this buffer |
| `:FormatDisable[!]`, `:FormatEnable` | Same as commands (`!` = buffer) |
| `Space cL` | Run linters now |
| `Space cm` | Open Mason |

Files are formatted on save (Java right after saving, so saving stays fast).

### Git

| Key | Action |
| --- | --- |
| `Space gg` | Neogit |
| `Space gG` | Lazygit (if installed) |
| `Space gs` / `Space gc` / `Space gp` / `Space gl` | Fugitive status / commit / push / pull |
| `Space gd` / `Space gD` | Open / close Diffview |
| `Space gh` | File history |
| `Space go` | Open the file or selection on GitHub/GitLab |
| `Space hs` / `Space hr` | Stage / reset hunk (also on a selection) |
| `Space hS` / `Space hR` | Stage / reset buffer |
| `Space hp` / `Space hi` | Preview hunk / inline |
| `Space hb`, `Space hd` / `Space hD` | Blame line, diff against index / last commit |
| `Space hq` / `Space hQ` | Hunks to quickfix: buffer / all |
| `Space tb` / `Space tw` / `Space tl` / `Space tn` | Toggle line blame / word diff / line highlight / number highlight |

### Debugging and tests

| Key | Action |
| --- | --- |
| `F5` / `F10` / `F11` / `F12` | Continue / step over / into / out |
| `Space db` / `Space dB` | Breakpoint / conditional breakpoint |
| `Space dc` / `Space dl` / `Space dt` | Run to cursor / run last / terminate |
| `Space du` / `Space dr` | Toggle DAP UI / REPL |
| `Space nt` / `Space nf` / `Space nT` | Test nearest / file / project |
| `Space nd` / `Space nD` | Debug nearest test / file |
| `Space ns` / `Space no` / `Space nO` | Summary / output / output panel |
| `Space nw` / `Space nx` | Watch / stop |

### Terminal, tasks and sessions

| Key | Action |
| --- | --- |
| `Ctrl+\` | Toggle the terminal |
| `Space th` / `Space tv` / `Space tf` | Horizontal / vertical / floating terminal |
| `Space s` (Visual) | Send the selection to the terminal |
| `Space py` | Python REPL (uv, python3 or python) |
| `Space ld` | Lazydocker (if installed) |
| `Esc` (terminal) | Back to Normal mode |
| `Space or` / `Space ot` | Run a task / task list (Overseer) |
| `Space qs` / `Space ql` / `Space qS` | Restore session: this folder / last / pick |
| `Space qd` | Stop saving the session |
| `Space td` / `Space tD` / `Space tN` | Todo lists: global / project / due items |

### UI toggles

| Key | Action |
| --- | --- |
| `Space ut` / `Space uT` | Theme / transparent background (both remembered) |
| `Space ui` / `Space uc` | Indent guides / block outline |
| `Space ub` | Breadcrumbs |
| `Space uw` | Wrap |
| `Space uh` / `Space un` | Notification history / dismiss |
| `Space up` / `Space uP` | Plugin load profile / Lua profiler |

### AI (CodeCompanion + Codex ACP)

| Key | Mode | Action |
| --- | --- | --- |
| `Space aa` / `Space a?` | Normal | Action palette |
| `Space aa` | Visual | Add the selection to the chat |
| `Space am` | Visual | Selection menu (Ask, Explain, Fix, Tests, …) |
| `Space aq` / `Space ae` / `Space af` | Visual | Ask / explain / fix the selection |
| `Space al` / `Space at` / `Space aR` | Visual | Explain diagnostics / generate tests / refactor |
| `Space ac` | Normal/Visual | Add a review comment |
| `Space ai` / `Space an` | Normal/Visual | Toggle chat / new chat |
| `Space aM` / `Space ao` | Normal | Change provider and model / ACP model and effort |
| `Space av` / `Space aV` / `Space ax` | Normal | Review agent changes / all changes / changed files |
| `Space ar` / `Space aS` | Normal | Refresh cache / stop the request |

In a chat: `Enter` or `Ctrl+s` sends, `q` stops, `ga` changes the model, `?`
lists every chat key, `#{buffer}` adds the current file, `/file` and `/buffer`
pick context, `Space aP` pastes a clipboard image. Requires `codex` and
`codex-acp` on `PATH` (`codex login` once for a ChatGPT-backed provider).

### Language-specific keys

| Key | Language | Action |
| --- | --- | --- |
| `Space pv` | Python | Select a virtualenv |
| `Space Gi` / `Space Gs` / `Space GI` | Go | Add `if err` / fill struct / implement interface |
| `Space Gt` / `Space GT` | Go | Add / remove JSON tags |
| `Space Gf` / `Space GF` / `Space Ga` | Go | Generate function / file tests, alternate test file |
| `Space Gc` | Go | Generate a comment |
| `Space Ti` / `Space Ta` / `Space Tu` / `Space Tf` | TypeScript | Organize imports / add missing / remove unused / fix all |
| `Space Jo` | Java | Organize imports |
| `Space Jv` / `Space Jc` / `Space Jm` | Java | Extract variable / constant / method |
| `Space Jt` / `Space JT` | Java | Test nearest method / class |
| `Space Ju` | Java | Update project configuration |

## Languages

| Language | LSP | Format | Lint / extra | Debug | Tests |
| --- | --- | --- | --- | --- | --- |
| Python | basedpyright, ruff | ruff | ruff, venv-selector | debugpy | neotest-python |
| Go | gopls | goimports, gofumpt | staticcheck (gopls), go.nvim | delve | neotest-golang |
| JS / TS | ts_ls, eslint | prettier | eslint | js-debug | neotest-jest |
| Java | jdtls (nvim-jdtls) | google-java-format | — | java-debug | neotest-java |
| C / C++ | clangd (clang-tidy) | clang-format | — | codelldb | — |
| Lua | lua_ls + lazydev | stylua | — | — | — |
| HTML / CSS / JSON | html, cssls, jsonls (SchemaStore) | prettier | — | — | — |
| YAML / TOML | yamlls (SchemaStore), taplo | LSP | schema validation | — | — |
| Shell | bashls (ShellCheck) | — | ShellCheck | — | — |
| Markdown | marksman | prettier | markdownlint-cli2, render-markdown | — | — |
| Dockerfile | dockerls | — | — | — | — |

Language servers are installed by Mason and enabled with Neovim's native
`vim.lsp.enable`. Inlay hints are configured for TypeScript, Go, Python and
Lua (`Space ci`). Python uses the project's `.venv` automatically; change the
type-checking level per project in `pyproject.toml`
(`[tool.basedpyright] typeCheckingMode`).

## Plugins

| Area | Plugins |
| --- | --- |
| Core | lazy.nvim, snacks.nvim, mini.nvim (ai, splitjoin, move, bracketed), plenary, nui |
| UI | 14 themes, lualine, bufferline, noice, which-key, dropbar, hlchunk, render-markdown, nvim-web-devicons |
| Search / files | fzf-lua, grug-far, neo-tree, oil, grapple, quicker |
| Editing | flash, nvim-surround, multicursor.nvim, nvim-autopairs, ts-comments, nvim-ts-autotag, dial, yanky, nvim-ufo, inc-rename |
| Code | nvim-treesitter (main) + textobjects, nvim-lspconfig, mason (+ lspconfig, tool-installer, nvim-dap), blink.cmp, friendly-snippets, conform, nvim-lint, lazydev, SchemaStore, tiny-code-action, trouble, todo-comments |
| Languages | go.nvim, nvim-jdtls, venv-selector |
| Git | gitsigns, neogit, vim-fugitive, diffview (maintained fork `dlyongemallo/diffview-plus.nvim`) |
| Debug / test | nvim-dap, dap-ui, dap-virtual-text, dap-go, neotest + adapters |
| Workflow | toggleterm, overseer, persistence, dooing |
| AI | codecompanion.nvim (+ img-clip), native Copilot |

## Maintenance

| Command | Use |
| --- | --- |
| `:ConfigHealth` | Check this configuration and its tools |
| `:Lazy` / `:Lazy profile` | Plugins / load timings (`Space up`) |
| `:Lazy sync` | Update plugins (then commit `lazy-lock.json`) |
| `:Lazy restore` | Go back to the versions in `lazy-lock.json` |
| `:Mason`, `:MasonToolsUpdate` | Language servers and tools |
| `:TSUpdate` | Treesitter parsers |
| `:LspInfo`, `:LspRestart [name]` | LSP status / restart |
| `:ThemeReset`, `:ThemeTransparentToggle` | Theme defaults |

Safe update: commit first, run `:Lazy sync`, restart, run `:ConfigHealth` and
the tests below, then commit the new `lazy-lock.json` (or `:Lazy restore` to
roll back).

Headless tests (run from the config folder):

```bash
for t in config_validation performance regressions audit textobjects terminal lsp_lifecycle bootstrap ai upgrades startup ide; do
  nvim --headless -u NONE -i NONE -l tests/$t.lua || echo "FAILED: $t"
done
python3 tests/installer.py
```

`tests/ide.lua` and `tests/format.lua` start real servers and formatters, so
they need the full toolchain installed.

Startup profiling: `nvim --startuptime /tmp/startup.log +qa`, then `:Lazy
profile` or `Space uP` for runtime profiling.

## Troubleshooting

**Generic `:checkhealth` shows Snacks or `vim.pack` errors.** Snacks checks
modules this config leaves off (image, bigfile, explorer), and `vim.pack` is
unused because lazy.nvim manages plugins. Use `:ConfigHealth` or
`:checkhealth lazy vim.lsp vim.treesitter vim.deprecated`.

**Copilot shows nothing.** Run `:checkhealth vim.lsp` and look for the
`copilot` client; install the server with `:MasonInstall
copilot-language-server`, then `:LspCopilotSignIn`.

**Indent guides or line numbers are hard to see.** Your terminal is probably
translucent. Press `Space uT` for an opaque theme, or set
`vim.g.sungp_indent_guide_hl` in `config/local.lua`.

**Treesitter cannot build parsers.** Check `:checkhealth nvim-treesitter`, a C
compiler (`cc`, `clang`, `gcc`; Zig on Windows) and the `tree-sitter` CLI, then
run `:TSUpdate`. For ABI errors: `:TSUninstall <lang>` and `:TSInstall <lang>`.

**clangd cannot find standard headers.** Make sure `g++ --version` or
`clang++ --version` works in the shell that starts Neovim, generate
`compile_commands.json` for larger projects, then `:LspRestart clangd`.

**jdtls does not start.** JDK 25 is required: check `:echo $JAVA_HOME` and
start Neovim inside a folder with `pom.xml`, `build.gradle`, `mvnw`, `gradlew`
or `.git`. For tests run `:Lazy load neotest` then `:NeotestJava setup`.

**Search returns nothing.** Check `:echo executable('rg')` and
`executable('fd')`. Ignored files and folders such as `node_modules`, `dist`,
`build`, `target`, `.venv`, `vendor` and `coverage` are skipped on purpose; use
`Space fI` to grep with your own globs.

**Codex ACP reports SQLite or `arg0` errors.** Do not set `CODEX_HOME`; run
`codex login` and `codex doctor --summary`, close old Neovim/ACP processes and
restart. The config keeps ACP's runtime database in
`stdpath("data")/nvim-config/codex-sqlite`.

**Neovim only works after `:source %`.** An old `VIMINIT` environment variable
is overriding `init.lua`; remove it from your shell profile.

**`module 'helper.utils' not found`.** `:echo stdpath('config')` must point
directly at this folder (containing `init.lua` and `lua/`), not a nested copy.

**Linux clipboard does not work.** Install `wl-clipboard` (Wayland) or `xclip`
(X11).

**Headless PowerShell commands print a PSReadLine error.** Guard prediction
setup in your PowerShell profile with
`if (-not [Console]::IsOutputRedirected) { Set-PSReadLineOption -PredictionSource History }`.
