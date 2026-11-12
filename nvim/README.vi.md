# sungp Neovim

Ngôn ngữ: [English](README.md) | [Tiếng Việt](README.vi.md)

Cấu hình Neovim theo kiểu IDE cho Python, Go, JavaScript/TypeScript, Java,
C/C++, Lua, Shell, YAML/TOML và Markdown. Dựa trên LSP có sẵn của Neovim 0.12,
`lazy.nvim`, Blink, FzfLua, Treesitter, DAP và Neotest, có dashboard Snacks và
14 bộ theme nạp khi cần.

- **Nhanh**: mọi plugin chỉ nạp khi cần (theo sự kiện, lệnh, phím hoặc loại
  file); chỉ theme đang dùng được nạp; file lớn tự chuyển sang chế độ nhẹ.
- **Đầy đủ**: LSP, gợi ý code, Copilot, format, lint, debug, test, Git,
  session, terminal và chat AI (CodeCompanion).
- **Dễ tuỳ chỉnh**: cài đặt riêng nằm trong một file không đưa lên Git,
  `lua/config/local.lua`; theme và nền trong suốt được ghi nhớ.
- **Đa nền tảng**: một cấu hình cho macOS, Linux/WSL2 và Windows.

## Mục lục

- [Cài đặt](#cài-đặt)
- [Yêu cầu](#yêu-cầu)
- [Sau khi cài](#sau-khi-cài)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Cài đặt riêng](#cài-đặt-riêng)
- [Theme và giao diện](#theme-và-giao-diện)
- [Phím tắt](#phím-tắt)
- [Ngôn ngữ](#ngôn-ngữ)
- [Plugin](#plugin)
- [Bảo trì](#bảo-trì)
- [Xử lý sự cố](#xử-lý-sự-cố)

## Cài đặt

Chạy **một lệnh cho hệ điều hành của bạn** bằng tài khoản thường (không phải
root). Bộ cài dùng Homebrew trên macOS/Linux và Scoop trên Windows, sao lưu
config cũ thành `nvim.backup-<thời-gian>`, cài plugin đúng phiên bản đã khoá,
rồi cài language server, công cụ và parser Treesitter. Cần internet, vài phút
và vài GB ổ đĩa. Chạy lại đúng lệnh đó để cài tiếp nếu bị gián đoạn.

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

Lệnh này nâng cấp toàn hệ thống để tránh nâng cấp dở dang.

```bash
sudo pacman -Syu --needed --noconfirm curl && bash -c 'p=$(mktemp) && curl --fail --location --retry 3 https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.sh -o "$p" && bash "$p"; s=$?; rm -f "$p"; exit "$s"'
```

### Windows 10/11 x64

Chạy trong cửa sổ PowerShell thường, không chạy quyền Administrator.

```powershell
& { $ErrorActionPreference = 'Stop'; Set-ExecutionPolicy Bypass -Scope Process -Force; $p = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.ps1'); Invoke-WebRequest 'https://raw.githubusercontent.com/sung2708/nvim-config/main/bin/install.ps1' -UseBasicParsing -OutFile $p; try { & $p } finally { Remove-Item $p } }
```

Cài xong, mở **terminal mới** và chạy `nvim .`. Chọn một Nerd Font trong
terminal để hiện icon.

Bộ cài thêm vào máy: Neovim, Git, ripgrep, fd, fzf, lazygit, make, unzip,
Node 24, Python 3.13, Go, JDK 25, Maven và clang-format (Windows thêm Zig, GCC,
LLVM để build parser); `tree-sitter-cli` cố định phiên bản trong thư mục data
của Neovim; và file `lua/config/toolchain.lua` (tự sinh, không đưa lên Git) để
Neovim dùng đúng các runtime đó.

### Cài thủ công

```bash
git clone https://github.com/sung2708/nvim-config.git ~/.config/nvim
sh ~/.config/nvim/bin/check-environment.sh   # Windows: bin\check-environment.ps1
nvim
```

lazy.nvim cài plugin ở lần mở đầu tiên; sau đó Mason tự cài language server và
công cụ ở chế độ nền.

## Yêu cầu

Nếu cài thủ công hoặc dùng Stow trên macOS/Linux, dùng Volta cho Node/npm
và uv cho `clang-format`, `basedpyright`. Xem các lệnh cài và cách sửa
wrapper Mason bị hỏng trong [Manual install](README.md#manual-install).
Cài compiler C, JDK 25 và Maven qua trình quản lý gói hệ thống khi cần.
Nếu Neovim trong tmux đang chạy không thấy đường dẫn công cụ tùy chỉnh,
xem [cách làm mới PATH của tmux](../README.md#refresh-tmux-path).

| Bắt buộc | Để làm gì |
| --- | --- |
| Neovim **0.12+** | LSP có sẵn, inline completion (Copilot), Treesitter `main` |
| git, curl, unzip | Cài plugin và gói Mason |
| ripgrep, fzf | Tìm kiếm và danh sách chọn |
| Trình biên dịch C (`cc`/`clang`/`gcc`; Windows dùng Zig) và `tree-sitter` CLI | Build parser Treesitter |

| Tuỳ chọn | Dùng cho |
| --- | --- |
| fd | Tìm file nhanh hơn (không có thì dùng ripgrep) |
| Node.js / npm | Nhiều language server, máy chủ Copilot |
| Python 3, Go, JDK 25 + Maven/Gradle | Công cụ Python, Go, Java |
| lazygit, lazydocker | `Space gG`, `Space ld` |
| codex, codex-acp | Chat AI CodeCompanion |
| pngpaste (macOS), xclip hoặc wl-clipboard (Linux) | Clipboard và dán ảnh vào chat AI |

`bin/check-environment.sh` (hoặc `.ps1`) báo những gì còn thiếu.

## Sau khi cài

1. Mở Neovim, chạy `:ConfigHealth` để kiểm tra cấu hình và các công cụ.
2. Nếu Copilot yêu cầu đăng nhập, chạy `:LspCopilotSignIn` một lần (đã đăng
   nhập trong copilot.vim hoặc VS Code thì dùng lại được).
3. Chọn theme bằng `Space ut`; theme đó sẽ thành mặc định.
4. Bấm `Space` rồi chờ: which-key hiện tất cả nhóm phím tắt.

## Cấu trúc thư mục

```text
init.lua                 điểm bắt đầu: require("config")
lua/config/              lõi: options, keymaps, autocmds, lazy.nvim, theme,
                         copilot, health, parsers, local.example.lua
lua/plugins/             khai báo plugin cho lazy.nvim, mỗi mảng một file
                         (ui, themes, editor, search, navigation, lsp,
                         completion, git, debug, terminal, sessions, ai, ...)
lua/integrations/        phần setup của plugin lớn (lsp, snacks, noice,
                         lualine, hlchunk, codecompanion, java, dap, ...)
lua/helper/              hàm dùng chung (nạp trễ, gốc dự án, format)
after/ftplugin/          thụt lề theo ngôn ngữ
bin/                     bộ cài, bootstrap, kiểm tra môi trường
tests/                   test chạy headless
lazy-lock.json           phiên bản plugin đã khoá
```

File riêng của từng máy, không đưa lên Git: `lua/config/local.lua` (cài đặt
của bạn), `lua/config/toolchain.lua` (bộ cài sinh ra), `.nvim-data/` (thư mục
tạm của test) và các file log.

## Cài đặt riêng

Sao chép `lua/config/local.example.lua` thành `lua/config/local.lua`. File này
được nạp trước mọi thứ và không đưa lên Git.

| Cài đặt | Mặc định | Tác dụng |
| --- | --- | --- |
| `vim.g.sungp_low_spec = true` | `false` | Chế độ nhẹ cho máy yếu (tắt dashboard, breadcrumb, số dòng tương đối) |
| `vim.g.sungp_transparent = false` | `true` | Mở với nền đặc (`Space uT` bật/tắt và ghi nhớ) |
| `vim.g.sungp_indent_guide_hl = "Comment"` | tự động | Màu đường thụt lề (tên nhóm màu hoặc `"#rrggbb"`) |
| `vim.g.sungp_diagnostic_lines = false` | `true` | Hiện lỗi đầy đủ dưới dòng con trỏ (`Space uv`) |
| `vim.g.sungp_inlay_hints = true` | `false` | Tự bật gợi ý kiểu/tham số của LSP (`Space ci` theo buffer) |
| `vim.g.sungp_copilot = false` | `true` | Tắt hẳn Copilot (`Space uA` bật/tắt gợi ý) |
| `vim.g.sungp_animations = true` | `false` | Hiệu ứng cho thông báo |
| `vim.g.sungp_bigfile_lines` / `_line_length` | `10000` / `2000` | Ngưỡng file lớn (và > 1 MiB) |
| `vim.g.autoformat_timeout_ms` | `1000` | Thời gian chờ format khi lưu |
| `vim.g.python3_host_prog` | không đặt | Bật lại Python provider (đang tắt vì không plugin nào cần) |
| `vim.env.JAVA_HOME` | tự dò | JDK cho jdtls |

Theme mặc định đặt trong `lua/config/theme.lua` (`M.name`).

## Theme và giao diện

Theme đã cài (mặc định nền trong suốt): Kanagawa, Catppuccin, Tokyo Night,
Rosé Pine, Nightfox (carbonfox, duskfox, nordfox, terafox, dawnfox, dayfox),
OneDark, Gruvbox Material, Everforest, Cyberdream, Vague, Nordic, VS Code,
Dracula và Solarized Osaka.

- `Space ut` chọn theme có xem trước. Theme bạn giữ lại (hoặc đặt bằng
  `:colorscheme`) sẽ dùng cho lần mở sau; `:ThemeReset` quay về mặc định.
- `Space uT` bật/tắt nền trong suốt cho mọi theme và ghi nhớ. Biến thể sáng
  (latte, day, dawn, lotus, light) luôn có nền riêng để dễ đọc.
- Khi nền trong suốt, đường thụt lề và số dòng được làm sáng hơn để không chìm
  vào nền terminal trong suốt.
- Cửa sổ nổi, danh sách chọn, menu gợi ý, Noice, which-key, Trouble dùng chung
  một kiểu nền và viền cho mọi theme.

Thành phần giao diện: dashboard và thông báo Snacks, dòng lệnh Noice, Lualine
(nhánh Git/diff lấy từ Gitsigns, tiến trình LSP, server đang chạy, venv
Python), Bufferline, breadcrumb Dropbar, viền khối và đường thụt lề hlchunk,
render-markdown, gập code nvim-ufo.

## Phím tắt

`Space` là phím leader (`\` là local leader). Bấm `Space` rồi chờ để xem các
nhóm phím, hoặc tìm mọi phím bằng `Space fk`.

### Cơ bản và cửa sổ

| Phím | Chức năng |
| --- | --- |
| `Alt+h/j/k/l` | Chuyển cửa sổ (cả khi đang ở terminal) |
| `Ctrl+Mũi tên` | Đổi kích thước cửa sổ |
| `Esc` | Xoá tô sáng tìm kiếm |
| `n` / `N`, `Ctrl+d` / `Ctrl+u` | Tìm tiếp và cuộn nửa trang, giữ ở giữa màn hình |
| `Space j` / `Space k` | Chuyển dòng hoặc vùng chọn xuống / lên |
| `Space mh` / `Space ml` | Chuyển dòng hoặc vùng chọn sang trái / phải |
| `<` / `>` (Visual) | Thụt lề và giữ vùng chọn |
| `Space uz` / `Space uZ` | Chế độ Zen / phóng to cửa sổ |
| `Space u.` / `Space uS` | Ghi chú nháp / chọn ghi chú nháp |

### File, tìm kiếm và cây thư mục

| Phím | Chức năng |
| --- | --- |
| `Space ff` | Tìm file trong dự án |
| `Space fF` / `Space fe` | Tìm file trong cwd / trong thư mục của file đang mở |
| `Space fg` | Tìm chữ trong dự án (`Space fI` có glob, `Space fG` cwd, `Space fE` thư mục file) |
| `Space fw` | Tìm từ dưới con trỏ hoặc vùng chọn |
| `Space fb` / `Space fO` | Buffer đang mở / file gần đây |
| `Space fl` / `Space fh` / `Space fk` | Dòng trong buffer / help / phím tắt |
| `Space fy` | Lịch sử yank |
| `Space fR` | Mở lại danh sách chọn gần nhất |
| `Space fr` | Tìm và thay thế (grug-far); trên vùng chọn: thay vùng chọn |
| `Space fm` / `Space fM` | Đánh dấu file (Grapple) / xem file đã đánh dấu |
| `Space f1`…`Space f4` | Mở file đánh dấu số 1–4 |
| `Space E` | Bật/tắt cây thư mục Neo-tree |
| `Ctrl+n` | Mở Neo-tree tại file đang mở |
| `-` | Mở thư mục cha bằng Oil (sửa tên như văn bản, `:w` để áp dụng) |
| `Space fo` | Oil trong cửa sổ nổi |
| `Space sd` | Mở dashboard |

Phím trên dashboard: `f` file, `g` tìm chữ, `b` buffer, `e` cây thư mục, `s`
Git status, `d` diff, `x` lỗi, `t` test, `c` file config, `n` file mới, `q`
thoát.

### Buffer

| Phím | Chức năng |
| --- | --- |
| `]b` / `[b` | Buffer sau / trước |
| `Space bc` | Đóng buffer, giữ nguyên bố cục cửa sổ |
| `Space bp` | Ghim buffer |
| `Space be` / `Space bq` | Dời buffer sang phải / trái |

### Chỉnh sửa

| Phím | Chức năng |
| --- | --- |
| `s` / `S` | Nhảy nhanh Flash / chọn theo Treesitter (`Space mS` ở Visual) |
| `ys{chuyển động}{ký tự}`, `ds{ký tự}`, `cs{cũ}{mới}` | Thêm / xoá / đổi cặp bao quanh (`S` ở Visual; `f` = lời gọi hàm, `t` = thẻ) |
| `gS` | Tách hoặc gộp tham số (Visual: bao quanh trên dòng mới) |
| `gc`, `gcc` | Comment theo chuyển động / theo dòng |
| `Alt+n` / `Alt+p` | Thêm con trỏ ở kết quả khớp sau / trước |
| `Alt+a` / `Alt+x` | Con trỏ ở mọi kết quả khớp / bỏ qua một kết quả |
| `Alt+Down` / `Alt+Up` | Thêm con trỏ bên dưới / bên trên |
| `Esc` | Bỏ nhiều con trỏ |
| `Ctrl+a` / `Ctrl+x` | Tăng / giảm số, ngày, true/false, semver |
| `p` / `P`, `[y` / `]y` | Dán, rồi xoay vòng lịch sử yank |
| `Alt+e` (Insert) | Bọc nhanh bằng autopairs |
| `Space mp` / `Space mP` | Đổi chỗ với tham số sau / trước |
| `zR` / `zM` / `zr` / `zm` / `zK` | Gập code: mở hết / gập hết / mở một mức / gập một mức / xem trước |

Text object: `af`/`if` lời gọi hàm, `am`/`im` hàm, `ac`/`ic` class, `as` phạm
vi, `iH` khối đang tô, cùng bộ của mini.ai (`a(`, `i"`, `aq`, `ab`, …).

### Di chuyển trong code

| Phím | Chức năng |
| --- | --- |
| `]m` / `[m`, `]M` / `[M` | Đầu / cuối hàm |
| `]]` / `[[`, `][` / `[]` | Đầu / cuối class |
| `]o` / `[o` | Vòng lặp |
| `]C` / `[C` | Câu điều kiện |
| `]s`, `]z` | Phạm vi, nếp gập |
| `]d` / `[d` | Lỗi (kèm cửa sổ chi tiết) |
| `]q` / `[q` | Mục quickfix |
| `]t` / `[t` | Comment TODO |
| `]c` / `[c` | Thay đổi Git (hunk) |
| `]x` / `[x`, `]i` / `[i`, `]j` / `[j`, `]w` / `[w` | Dấu conflict, mức thụt lề, danh sách nhảy, cửa sổ |
| `Space ;`, `[;`, `];` | Chọn symbol trên breadcrumb, đầu ngữ cảnh, ngữ cảnh kế |

### LSP và lỗi

| Phím | Chức năng |
| --- | --- |
| `gd` / `gy` / `gI` | Định nghĩa / định nghĩa kiểu / implementation (FzfLua) |
| `grr` / `gO` | Tham chiếu / symbol trong file |
| `Space cS` | Symbol cả workspace |
| `K` (hoặc `Space e`) | Xem tài liệu |
| `Space rn` | Đổi tên có xem trước |
| `Space ca` | Code action |
| `Space cd` | Lỗi của dòng hiện tại |
| `Space ci` | Bật/tắt gợi ý kiểu/tham số |
| `Space cR` | Đổi tên file và cập nhật import |
| `Space xx` / `Space xX` | Lỗi trong Trouble: toàn workspace / buffer |
| `Space cs` / `Space cl` | Symbol / tham chiếu LSP trong Trouble |
| `Space xD` | Đưa lỗi vào quickfix |
| `Space xt` / `Space xf` / `Space xq` | TODO trong Trouble / Snacks picker / quickfix |
| `Space xF` / `Space xR` | Chỉ TODO/FIX/FIXME trong FzfLua / Trouble |
| `Space qf` / `Space qF` | Bật/tắt / chuyển vào quickfix |
| `Space uv` / `Space ud` | Bật/tắt dòng lỗi dưới con trỏ / mọi lỗi |

Các phím có sẵn của Neovim `gra`, `grn`, `gri`, `grt` và `Ctrl+s` (gợi ý tham
số khi gõ) vẫn dùng được.

### Gợi ý code và Copilot

| Phím (Insert) | Chức năng |
| --- | --- |
| `Tab` | Nhận mục gợi ý → nhảy trong snippet → nhận gợi ý Copilot → thụt lề |
| `Shift+Tab` | Mục trước / nhảy lùi trong snippet |
| `Ctrl+n` / `Ctrl+p`, `Ctrl+j` / `Ctrl+k` | Chọn mục sau / trước |
| `Ctrl+Space` | Mở menu hoặc tài liệu |
| `Ctrl+y` / `Ctrl+e` | Nhận / đóng |
| `Ctrl+b` / `Ctrl+f` | Cuộn tài liệu |
| `Ctrl+l` | Gợi ý tham số hàm |
| `Alt+]` / `Alt+[` | Gợi ý Copilot sau / trước |

`Enter` không bao giờ nhận gợi ý. Copilot dùng inline completion có sẵn của
Neovim với `copilot-language-server` từ Mason; `Space uA` bật/tắt.

### Format và lint

| Phím / lệnh | Chức năng |
| --- | --- |
| `Space cf` | Format buffer hoặc vùng chọn |
| `Space uf` / `Space uF` | Bật/tắt format khi lưu cho mọi file / buffer này |
| `:FormatDisable[!]`, `:FormatEnable` | Như trên bằng lệnh (`!` = buffer) |
| `Space cL` | Chạy linter ngay |
| `Space cm` | Mở Mason |

File được format khi lưu (Java format ngay sau khi lưu để lưu vẫn nhanh).

### Git

| Phím | Chức năng |
| --- | --- |
| `Space gg` | Neogit |
| `Space gG` | Lazygit (nếu đã cài) |
| `Space gs` / `Space gc` / `Space gp` / `Space gl` | Fugitive status / commit / push / pull |
| `Space gd` / `Space gD` | Mở / đóng Diffview |
| `Space gh` | Lịch sử file |
| `Space go` | Mở file hoặc vùng chọn trên GitHub/GitLab |
| `Space hs` / `Space hr` | Stage / bỏ thay đổi của hunk (cả vùng chọn) |
| `Space hS` / `Space hR` | Stage / bỏ thay đổi cả buffer |
| `Space hp` / `Space hi` | Xem trước hunk / ngay trong dòng |
| `Space hb`, `Space hd` / `Space hD` | Blame dòng, so với index / commit trước |
| `Space hq` / `Space hQ` | Hunk vào quickfix: buffer / tất cả |
| `Space tb` / `Space tw` / `Space tl` / `Space tn` | Bật/tắt blame dòng / diff theo từ / tô dòng / tô số dòng |

### Debug và test

| Phím | Chức năng |
| --- | --- |
| `F5` / `F10` / `F11` / `F12` | Chạy tiếp / bước qua / bước vào / bước ra |
| `Space db` / `Space dB` | Breakpoint / breakpoint có điều kiện |
| `Space dc` / `Space dl` / `Space dt` | Chạy tới con trỏ / chạy lại / dừng |
| `Space du` / `Space dr` | Bật/tắt giao diện DAP / REPL |
| `Space nt` / `Space nf` / `Space nT` | Test gần nhất / cả file / cả dự án |
| `Space nd` / `Space nD` | Debug test gần nhất / cả file |
| `Space ns` / `Space no` / `Space nO` | Tóm tắt / kết quả / bảng kết quả |
| `Space nw` / `Space nx` | Theo dõi / dừng |

### Terminal, task và session

| Phím | Chức năng |
| --- | --- |
| `Ctrl+\` | Bật/tắt terminal |
| `Space th` / `Space tv` / `Space tf` | Terminal ngang / dọc / nổi |
| `Space s` (Visual) | Gửi vùng chọn sang terminal |
| `Space py` | REPL Python (uv, python3 hoặc python) |
| `Space ld` | Lazydocker (nếu đã cài) |
| `Esc` (trong terminal) | Về chế độ Normal |
| `Space or` / `Space ot` | Chạy task / danh sách task (Overseer) |
| `Space qs` / `Space ql` / `Space qS` | Khôi phục session: thư mục này / gần nhất / chọn |
| `Space qd` | Ngừng lưu session |
| `Space td` / `Space tD` / `Space tN` | Danh sách việc: chung / theo dự án / sắp đến hạn |

### Bật/tắt giao diện

| Phím | Chức năng |
| --- | --- |
| `Space ut` / `Space uT` | Theme / nền trong suốt (đều được ghi nhớ) |
| `Space ui` / `Space uc` | Đường thụt lề / viền khối |
| `Space ub` | Breadcrumb |
| `Space uw` | Xuống dòng tự động |
| `Space uh` / `Space un` | Lịch sử thông báo / ẩn thông báo |
| `Space up` / `Space uP` | Thời gian nạp plugin / profiler Lua |

### AI (CodeCompanion + Codex ACP)

| Phím | Chế độ | Chức năng |
| --- | --- | --- |
| `Space aa` / `Space a?` | Normal | Bảng hành động |
| `Space aa` | Visual | Thêm vùng chọn vào chat |
| `Space am` | Visual | Menu cho vùng chọn (Hỏi, Giải thích, Sửa, Test, …) |
| `Space aq` / `Space ae` / `Space af` | Visual | Hỏi / giải thích / sửa vùng chọn |
| `Space al` / `Space at` / `Space aR` | Visual | Giải thích lỗi / sinh test / refactor |
| `Space ac` | Normal/Visual | Thêm bình luận review |
| `Space ai` / `Space an` | Normal/Visual | Bật/tắt chat / chat mới |
| `Space aM` / `Space ao` | Normal | Đổi nhà cung cấp và model / model ACP và mức suy luận |
| `Space av` / `Space aV` / `Space ax` | Normal | Xem thay đổi của agent / mọi thay đổi / file đã đổi |
| `Space ar` / `Space aS` | Normal | Làm mới cache / dừng yêu cầu |

Trong chat: `Enter` hoặc `Ctrl+s` để gửi, `q` dừng, `ga` đổi model, `?` xem
mọi phím của chat, `#{buffer}` thêm file đang mở, `/file` và `/buffer` chọn
ngữ cảnh, `Space aP` dán ảnh từ clipboard. Cần `codex` và `codex-acp` trong
`PATH` (chạy `codex login` một lần nếu dùng nhà cung cấp ChatGPT).

### Phím theo ngôn ngữ

| Phím | Ngôn ngữ | Chức năng |
| --- | --- | --- |
| `Space pv` | Python | Chọn virtualenv |
| `Space Gi` / `Space Gs` / `Space GI` | Go | Thêm `if err` / điền struct / implement interface |
| `Space Gt` / `Space GT` | Go | Thêm / xoá tag JSON |
| `Space Gf` / `Space GF` / `Space Ga` | Go | Sinh test cho hàm / cả file, chuyển sang file test |
| `Space Gc` | Go | Sinh comment |
| `Space Ti` / `Space Ta` / `Space Tu` / `Space Tf` | TypeScript | Sắp import / thêm import thiếu / xoá thừa / sửa tất cả |
| `Space Jo` | Java | Sắp xếp import |
| `Space Jv` / `Space Jc` / `Space Jm` | Java | Tách biến / hằng / hàm |
| `Space Jt` / `Space JT` | Java | Test hàm gần nhất / cả class |
| `Space Ju` | Java | Cập nhật cấu hình dự án |

## Ngôn ngữ

| Ngôn ngữ | LSP | Format | Lint / thêm | Debug | Test |
| --- | --- | --- | --- | --- | --- |
| Python | basedpyright, ruff | ruff | ruff, venv-selector | debugpy | neotest-python |
| Go | gopls | goimports, gofumpt | staticcheck (qua gopls), go.nvim | delve | neotest-golang |
| JS / TS | ts_ls, eslint | prettier | eslint | js-debug | neotest-jest |
| Java | jdtls (nvim-jdtls) | google-java-format | — | java-debug | neotest-java |
| C / C++ | clangd (clang-tidy) | clang-format | — | codelldb | — |
| Lua | lua_ls + lazydev | stylua | — | — | — |
| HTML / CSS / JSON | html, cssls, jsonls (SchemaStore) | prettier | — | — | — |
| YAML / TOML | yamlls (SchemaStore), taplo | LSP | kiểm tra schema | — | — |
| Shell | bashls (ShellCheck) | — | ShellCheck | — | — |
| Markdown | marksman | prettier | markdownlint-cli2, render-markdown | — | — |
| Dockerfile | dockerls | — | — | — | — |

Language server do Mason cài và bật bằng `vim.lsp.enable` có sẵn của Neovim.
Gợi ý kiểu/tham số đã cấu hình cho TypeScript, Go, Python và Lua (`Space ci`).
Python tự dùng `.venv` của dự án; chỉnh mức kiểm tra kiểu cho từng dự án trong
`pyproject.toml` (`[tool.basedpyright] typeCheckingMode`).

## Plugin

| Mảng | Plugin |
| --- | --- |
| Lõi | lazy.nvim, snacks.nvim, mini.nvim (ai, splitjoin, move, bracketed), plenary, nui |
| Giao diện | 14 theme, lualine, bufferline, noice, which-key, dropbar, hlchunk, render-markdown, nvim-web-devicons |
| Tìm kiếm / file | fzf-lua, grug-far, neo-tree, oil, grapple, quicker |
| Chỉnh sửa | flash, nvim-surround, multicursor.nvim, nvim-autopairs, ts-comments, nvim-ts-autotag, dial, yanky, nvim-ufo, inc-rename |
| Code | nvim-treesitter (main) + textobjects, nvim-lspconfig, mason (+ lspconfig, tool-installer, nvim-dap), blink.cmp, friendly-snippets, conform, nvim-lint, lazydev, SchemaStore, tiny-code-action, trouble, todo-comments |
| Ngôn ngữ | go.nvim, nvim-jdtls, venv-selector |
| Git | gitsigns, neogit, vim-fugitive, diffview (bản fork được duy trì `dlyongemallo/diffview-plus.nvim`) |
| Debug / test | nvim-dap, dap-ui, dap-virtual-text, dap-go, neotest + adapter |
| Làm việc | toggleterm, overseer, persistence, dooing |
| AI | codecompanion.nvim (+ img-clip), Copilot có sẵn |

## Bảo trì

| Lệnh | Dùng để |
| --- | --- |
| `:ConfigHealth` | Kiểm tra cấu hình và công cụ |
| `:Lazy` / `:Lazy profile` | Plugin / thời gian nạp (`Space up`) |
| `:Lazy sync` | Cập nhật plugin (rồi commit `lazy-lock.json`) |
| `:Lazy restore` | Quay về phiên bản trong `lazy-lock.json` |
| `:Mason`, `:MasonToolsUpdate` | Language server và công cụ |
| `:TSUpdate` | Parser Treesitter |
| `:LspInfo`, `:LspRestart [tên]` | Trạng thái / khởi động lại LSP |
| `:ThemeReset`, `:ThemeTransparentToggle` | Theme mặc định / nền trong suốt |

Cập nhật an toàn: commit trước, chạy `:Lazy sync`, mở lại Neovim, chạy
`:ConfigHealth` và các test bên dưới, rồi commit `lazy-lock.json` mới (hoặc
`:Lazy restore` để quay lại).

Test headless (chạy trong thư mục config):

```bash
for t in config_validation performance regressions audit textobjects terminal lsp_lifecycle bootstrap ai upgrades startup ide; do
  nvim --headless -u NONE -i NONE -l tests/$t.lua || echo "LỖI: $t"
done
python3 tests/installer.py
```

`tests/ide.lua` và `tests/format.lua` chạy server và formatter thật nên cần
cài đủ công cụ.

Đo khởi động: `nvim --startuptime /tmp/startup.log +qa`, rồi `:Lazy profile`
hoặc `Space uP` để đo lúc đang chạy.

## Xử lý sự cố

**`:checkhealth` chung báo lỗi Snacks hoặc `vim.pack`.** Snacks kiểm tra cả
các phần cấu hình này không bật (image, bigfile, explorer), còn `vim.pack`
không dùng vì lazy.nvim quản lý plugin. Dùng `:ConfigHealth` hoặc
`:checkhealth lazy vim.lsp vim.treesitter vim.deprecated`.

**Copilot không gợi ý.** Chạy `:checkhealth vim.lsp` và tìm client `copilot`;
cài server bằng `:MasonInstall copilot-language-server`, rồi
`:LspCopilotSignIn`.

**Đường thụt lề hoặc số dòng khó nhìn.** Có thể terminal đang trong suốt. Bấm
`Space uT` để dùng nền đặc, hoặc đặt `vim.g.sungp_indent_guide_hl` trong
`config/local.lua`.

**Treesitter không build được parser.** Kiểm tra
`:checkhealth nvim-treesitter`, trình biên dịch C (`cc`, `clang`, `gcc`;
Windows dùng Zig) và `tree-sitter` CLI, rồi chạy `:TSUpdate`. Lỗi ABI:
`:TSUninstall <ngôn-ngữ>` rồi `:TSInstall <ngôn-ngữ>`.

**clangd không tìm thấy header chuẩn.** Đảm bảo `g++ --version` hoặc
`clang++ --version` chạy được trong shell mở Neovim, tạo
`compile_commands.json` cho dự án lớn, rồi `:LspRestart clangd`.

**jdtls không chạy.** Cần JDK 25: kiểm tra `:echo $JAVA_HOME` và mở Neovim
trong thư mục có `pom.xml`, `build.gradle`, `mvnw`, `gradlew` hoặc `.git`. Để
chạy test: `:Lazy load neotest` rồi `:NeotestJava setup`.

**Tìm kiếm không ra kết quả.** Kiểm tra `:echo executable('rg')` và
`executable('fd')`. Các thư mục như `node_modules`, `dist`, `build`, `target`,
`.venv`, `vendor`, `coverage` được bỏ qua có chủ đích; dùng `Space fI` để tìm
với glob riêng.

**Codex ACP báo lỗi SQLite hoặc `arg0`.** Không đặt `CODEX_HOME`; chạy
`codex login` và `codex doctor --summary`, đóng các tiến trình Neovim/ACP cũ
rồi mở lại. Cấu hình để dữ liệu chạy của ACP trong
`stdpath("data")/nvim-config/codex-sqlite`.

**Neovim chỉ chạy đúng sau `:source %`.** Biến môi trường `VIMINIT` cũ đang
ghi đè `init.lua`; xoá nó khỏi file cấu hình shell.

**`module 'helper.utils' not found`.** `:echo stdpath('config')` phải trỏ thẳng
vào thư mục này (có `init.lua` và `lua/`), không phải một bản sao lồng bên
trong.

**Clipboard trên Linux không chạy.** Cài `wl-clipboard` (Wayland) hoặc `xclip`
(X11).

**Lệnh PowerShell headless in lỗi PSReadLine.** Bọc phần prediction trong
profile PowerShell:
`if (-not [Console]::IsOutputRedirected) { Set-PSReadLineOption -PredictionSource History }`.
