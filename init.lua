-- 2025/12/02 15:56 first stable-check ended
-- ==========================================================================
-- part 0. 最初に実行したいコマンド(キーマッピング関連の準備設定)
-- ==========================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- ==========================================================================
-- part 1. mini.deps のインストール (ブートストラップ)
-- ==========================================================================
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.deps`..."')
	vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.deps', mini_path })
	vim.cmd('packadd mini.deps | helptags ALL')
	vim.cmd('echo "Installed `mini.deps`"')
end

-- ==========================================================================
-- part 2. mini.deps のセットアップ
-- ==========================================================================
local MiniDeps = require('mini.deps')
MiniDeps.setup({ path = { package = path_package } })

-- 一応他の追加方法も簡略化
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- ==========================================================================
-- part 3. プラグインの追加 (修正箇所)
-- ==========================================================================
-- !! プラグインの追加そのものは遅延しないこと !!

-- ==== mini.nvimのコアプラグイン
-- mini.deps 自身を管理下に置く
add('echasnovski/mini.deps')
-- mini.nvim (色々なminiモジュールを全部インストール?するプラグイン。require().setup()で任意呼び出そう)
-- ## もしかするとこれも mini.deps 配下にあるかも(つまり不要かもしれない) ##
-- ↳ 要るよ by Gemini (ありがとう Gemini)
add('echasnovski/mini.nvim')

-- ==== カラースキームのプラグイン群
-- サブ
add('folke/tokyonight.nvim')		-- 既存
add('rebelot/kanagawa.nvim')		-- 新規: 和風で目に優しい
add('sainnhe/everforest')		-- 新規: 森のようなアースカラー
add({ source = "catppuccin/nvim", name = "catppuccin" })	-- すごい盛況してるらしいカラースキーム開発のnvim支部(うおおマキモカ!)
add({ source = "rose-pine/neovim", name = "rose-pine" })	-- エモいカラースキーム。(なんか優しいvaporwave感する...しない...?)
-- 3. カラースキーム切り替えツール
add("zaldih/themery.nvim")

-- ステータスバーの拡張をするプラグイン
add({
	source = 'nvim-lualine/lualine.nvim',
	-- Supply dependencies near target plugin
	depends = { 'nvim-tree/nvim-web-devicons' },
})

-- ==== その他のプラグイン
-- 日本語ヘルプ
add("https://github.com/vim-jp/vimdoc-ja")

-- ==========================================================================
-- part 4. プラグインの設定(と基本設定)
-- ==========================================================================

-- 念のため、プラグインがダウンロードされるのを待ってから実行するように設定
-- (now() を使うと、ダウンロード済みであれば即座に実行してくれます)


-- ==== #### 優先読み込み #### ====
now(function()
	-- nord font 依存のアイコン
	require('mini.icons').setup()
	vim.cmd('colorscheme chalkboard')

	-- mini.nvim の機能セットアップ
	require('mini.starter').setup()
	require('mini.basics').setup()

	-- nvim-tree と lualine も最初に読み込んどこう
	require('lualine').setup()
	-- mini.files の設定
	require('mini.files').setup({
		windows = {
			preview = true, -- ファイルの中身をプレビュー表示
			width_focus = 30,
			width_preview = 30,
		},
	})
	vim.api.nvim_create_user_command(
		'Files',
		function()
			MiniFiles.open()
		end,
		{ desc  = "エクスプローラを開く" }
	)
end)

-- globalにアンダーラインを消し飛ばすコマンドを定義
-- 多少負荷がかかるかもしれないが、致し方ない
-- もしかしたら、これが他プラグインの同名関数と干渉するかもしれないので注意
-- グローバル関数: 下線抹殺 & Nvy最適化
function kill_underline()
	-- 1. 安全に CursorLine の背景色を取得
	local cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })
	-- 背景色が取得できなかった場合のフォールバック色（例: Normalの背景、あるいは無指定）
	local bg_color = cursorline.bg or vim.api.nvim_get_hl(0, { name = "Normal" }).bg

	-- 2. 設定を適用する対象グループの定義
	local target_groups = {
		"Underlined",
		"MatchParen",
		"@markup.underline",
		"MiniCursorwordCurrent",
		"MiniCursorword",
		-- 念の為、診断系の下線もここに入れておくと安心です
		-- "DiagnosticUnderlineError", 
	}

	-- 3. ループで適用
	for _, name in ipairs(target_groups) do
		-- 既存の設定を取得
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		
		-- 下線属性を強制剥奪する処理
		-- どうしてもうまく行かないときの奥の手
		-- でも、gui=true だけを実行したほうが体感上手くいきやすい
		hl.underline = false
		hl.undercurl = false
		hl.sp = "NONE" -- Nvy対策の核心

		-- 代わりの装飾 (MiniCursorwordCurrent以外は背景色追従など)
		if name == "MiniCursorwordCurrent" then
			hl.bold = true
			-- minicursorword 系はこの方が上手く行った
			-- hl = { bg = bg_color, bold = true }
		else
			hl.bold = true
			if bg_color then
				hl.bg = bg_color
			end
		end

		-- 強制適用
		vim.api.nvim_set_hl(0, name, hl)
	end
end
-- 
-- ==== カラースキーム関連設定の遅延読み込み
later(function()
	-- global定義にしたのは、カラースキームの変化ごとに対応するため
	-- カラースキームはThemeryのみで変えるので、create_autocmdは不要と判断(重い処理を入れたくない!)
	-- 自作カラースキームだと、何故かMiniCursorwordからあらかじめunderlineを剥奪しないと上手く行かないので、
	-- 消してからにしてね
	local colorthemes = {
		-- 長くなりそうなので、変数であらかじめ定義
		{
		-- \nvim\colors\chalkboard.lua(自作カラースキーム)
			name = "prototype",
			colorscheme = "chalkboard",
			after = [[
				vim.api.nvim_set_hl(0, "MiniCursorword", { underline = false })
				kill_underline()
			]],
		},
		{
		-- \nvim\colors\chalkboard-classic.lua(自作カラースキーム)
			name = "classic-class",
			colorscheme = "chalkboard-classic",
			after = [[
				vim.api.nvim_set_hl(0, "MiniCursorword", { underline = false })
				kill_underline()
			]],
		},
		{
		-- \nvim\colors\chalkboard-modern.lua(自作カラースキーム)
			name = "modern-slate",
			colorscheme = "chalkboard-modern",
			after = [[
				vim.api.nvim_set_hl(0, "MiniCursorword", { underline = false })
				kill_underline()
			]],
		},
		{
		-- \nvim\colors\chalkboard-matte.lua(自作カラースキーム)
			name = "dusty-matte",
			colorscheme = "chalkboard-matte",
			after = [[
				vim.api.nvim_set_hl(0, "MiniCursorword", { underline = false })
				kill_underline()
			]],
		},
		{
			name = "rose-pine",
			colorscheme = "rose-pine-main",
			after = [[ kill_underline() ]],
		},
		{
			name = "moon",
			colorscheme = "rose-pine-moon",
			after = [[ kill_underline() ]],
		},
		{
			name = "macchi",
			colorscheme = "catppuccin-macchiato",
			after = [[ kill_underline() ]],
		},
		{
			name = "mocha",
			colorscheme = "catppuccin-mocha",
			after = [[ kill_underline() ]],
		},
		{
		-- ハイライトが下線を持たない様子なのでkillしない
			name = "forest",
			colorscheme = "everforest",
		},
		{
		-- ハイライトが下線を持たない様子なのでkillしない
			name = "night",
			colorscheme = "tokyonight",
		},
		{
			name = "wave",
			colorscheme = "kanagawa-wave",
			after = [[ kill_underline() ]],
		},
		{
			name = "dragon",
			colorscheme = "kanagawa-dragon",
			after = [[ kill_underline() ]],
		},
		-- defaultは文字通り"デフォルト"としてこのまま
		"default",
	}
	-- Themery の設定 ( <Leader>t でテーマ切り替えメニューを開く)
	-- mini.cursorword -> themery の順だといいかも
	require('mini.cursorword').setup()
	require('themery').setup({
		themes = colorthemes,
		livePreview = true, -- 選択中にリアルタイムで色を変えて見せる
	})
	-- 仕上げにカラースキーム確定直後に下線消去
	vim.api.nvim_set_hl(0, "MiniCursorword", { underline = false })
	kill_underline()
end)

-- 便利形プラグイン集
later(function()
	require('mini.indentscope').setup()
	require('mini.pairs').setup()
	require('mini.surround').setup()
	require('mini.align').setup()
end)

-- ==== vimdoc-ja
later(function()
	-- 基本は日本語ヘルプを優先
	vim.opt.helplang:prepend('ja')
end)

-- ==========================================================================
-- part 5. NEOVIMの設定
-- ==========================================================================
-- 設定ファイルの保護下実行関数
local loadModule = function(module)
  local ok, _ = pcall(require, module)
  if not ok then
    print('unloadable module: '..module)
  end
end

-- Neovim本体の基本設定ファイルの読み込み
loadModule('options')
loadModule('keymaps')

-- Nvyが起動している場合のみ実行されるブロック
if vim.g.nvy then
	loadModule('nvy_config')
end

