-- 2025/12/02 15:56 first stable-check ended
-- ================================================
-- 		c テーブル : カラーパレット
-- ================================================
local c = {
	ChalkBoard_green = "#3C503C",
	chalk_white = "#F0F0D2",
	chalk_gray = "#8C8C8C",
	middle_gray = "#767676",
	dark_gray = "#606060",
	pastel_rad = "#D78C96",
	pastel_green = "#A0D28C",
	pastel_yellow = "#F0DC96",
	pastel_purple = "#BE8CE2",
	pastel_blue = "#78AAEE",
	CB_light_green = "#4C644C",
	CB_light_shade_green = "#455945",
	absolute_white = "#FFFFFF",
	CB_bold_green = "#607860",
}


-- ================================================================
-- 		highlight テーブル : カラーパレット
-- ================================================================
local highlight = {
	-- ============================================
	--         builtin highlighting groups         
	-- ============================================
	-- 'Normal'グループは背景と文字色なので、前回成功した設定を再利用
	Normal = { fg = c.chalk_white, bg = c.ChalkBoard_green },
	-- 行番号と空白文字の視認性向上
	-- LineNr (行番号): 中間色を使用
	LineNr = { fg = c.middle_gray, bg = "None" },
	-- 空白文字/タブ文字 (listchars): 控えめな暗めのグレー
	-- SpecialKey (listchars、タブ、空白文字): 中間色を使用
	SpecialKey = { fg = c.middle_gray, bg = "None" },
	-- NonText: ウィンドウの区切り、行末の文字など、補助的なテキスト
	NonText = { fg = c.middle_gray, bg = "None" },
	-- 折り畳みテキスト: わずかに明るい背景色で目立たせる
	Folded = { fg = c.chalk_white, bg = c.CB_light_green },
	-- カーソル行と検索ハイライトの視認性向上
	-- 現在の行の背景色: 黒板よりわずかに明るい緑で控えめにハイライト
	CursorLine = { bg = c.CB_light_shade_green, bold = true },
	-- 現在行の行番号: 最も目立つように白とCursorLineの背景色を使用
	CursorLineNr = { fg = c.absolute_white, bg = c.CB_light_shade_green, bold = true },
	-- 検索ハイライト: チョーク色の背景に黒板色の文字で目に優しく強調
	Search = { fg = c.ChalkBoard_green, bg = c.pastel_yellow },
	-- ステータスライン：アクティブな行はパステル緑
	StatusLine = { fg = c.ChalkBoard_green, bg = c.pastel_green, bold = true },
	-- ステータスライン：非アクティブな行はチョーク色の背景
	StatusLineNC = { fg = c.dark_gray, bg = c.chalk_white, italic = true },
	-- 選択範囲のハイライト：控えめな緑がかったグレーで目に優しく
	Visual = { bg = c.CB_bold_green },
	-- ポップアップメニューの背景と文字色
	Pmenu = { fg = c.chalk_white, bg = c.CB_light_shade_green },
	-- ポップアップメニューの選択項目：パステル青で明確に強調
	PmenuSel = { fg = c.ChalkBoard_green, bg = c.pastel_blue },


	-- =========================================
	--                 syntax                   
	-- =========================================
	-- Statement: 制御文
	-- キーワードやコメントなど、特定のハイライトグループにパステルカラーを割り当てます
	-- パステル紫 -- 例: キーワード（if, else, functionなど）
	Statement = { fg = c.pastel_purple },
	-- 例: コメント-- グレーチョーク
	Comment = { fg = c.chalk_gray },
	-- 例: 定数・変数 -- パステル黄
	Constant = { fg = c.pastel_yellow },
	-- 例: 型名 -- パステル青
	Type = { fg = c.pastel_blue },
	-- 例: 文字列 -- パステル緑
	String = { fg = c.pastel_green },
	-- Identifier: 変数名/関数名 (チョーク色 + 太字で区別)
	Identifier = { fg = c.chalk_white, bold = true },
	-- PreProc: プリプロセッサディレクティブ (パステル青で外部依存を強調)
	PreProc = { fg = c.pastel_blue },
	-- Special: 特殊文字 (パステル黄で注意を引く)
	Special = { fg = c.pastel_yellow },
	-- Ignore: 無視要素 (背景色と同じにして非表示に)
	Ignore = { fg = c.ChalkBoard_green },
	-- Error: 最優先の警告として最大限に強調
	Error = { fg = c.absolute_white, bg = c.pastel_rad, bold = true },
	-- Todo: 控えめな黄色でメモとして認識できるように (CursorLineの背景色に近いです)
	Todo = { fg = c.pastel_yellow, bg = c.CB_light_green, bold = true },

	-- ----------------------------------------------------
	--  2. ファイル比較 (Diff) グループ (Git作業の効率化)
	-- ----------------------------------------------------
	-- DiffAdd: 追加された行 (パステル緑)
	DiffAdd = { bg = c.pastel_green, fg = c.ChalkBoard_green },
	-- DiffChange: 変更された行 (パステル黄)
	DiffChange = { bg = c.pastel_yellow, fg = c.ChalkBoard_green },
	-- DiffDelete: 削除された行 (最も落ち着いたパステル赤)
	DiffDelete = { bg = c.pastel_rad, fg = c.ChalkBoard_green },
	-- DiffText: 変更行内の変更されたテキスト (DiffChangeの背景を太字で強調)
	DiffText = { bg = c.pastel_yellow, fg = c.ChalkBoard_green, bold = true },

}

-- ==== カラーパレット適応

local set_hl = function(tbl)
	for group, conf in pairs(tbl) do
		vim.api.nvim_set_hl(0, group, conf)
	end
end


	-- ====================================================
-- ==== 確実なカラースキーム反映のための諸設定

vim.g.colors_name = "chalkboard_eye_friendly"

-- 1. 全てのハイライト定義をクリアし、ターミナルから色を受け取る準備
-- vim.cmd('hi clear')
vim.cmd.highlight("clear")

-- 2. ターミナルの色を使うための設定を有効化
-- vim.cmd('set termguicolors')
-- vim.cmd('set background=dark')

vim.opt.termguicolors = true
vim.o.background = "dark"

-- 3. 強制的にターミナルのデフォルトの色に依存させる
-- これが前回成功した設定です
-- vim.cmd('highlight Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE')
vim.api.nvim_set_hl(0, "Normal", { fg = "NONE", bg = "NONE" }) 

-- vim.cmd('highlight EndOfBuffer guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE')
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "NONE", bg = "NONE" }) 

set_hl(highlight)


