-- 2025/12/02 15:56 first stable-check ended
-- lua/colors/chalkboard-classic.lua
--【Classic Class】 伝統的な深緑と生成りチョーク
-- **特徴:** 昔ながらの教室の黒板。温かみがあり、少し黄色がかった「生成り（きなり）」色のチョークをベースにします。最も目に優しい構成です。

-- 1. テーマの初期化 (お作法)
-- vim.cmd("hi clear")
vim.cmd.highlight("clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end


vim.g.colors_name = "chalkboard-classic"

-- ============================================================
-- 2. パレット定義 (あなたの色をここに書く)
-- ============================================================

local c = {
-- 背景 (Background)
	bg        = "#2B3328",	-- (深みのあるモスグリーン。落ち着き重視)
	bg_light  = "#3A4436",	-- (少し光が当たった黒板)
	bg_dark   = "#1E241C",	-- (黒板消しの影)
-- 文字色 (Foreground)
	fg        = "#E8E6D1",	-- (少しクリーム色がかったチョークの白)
	fg_dim    = "#8F998A",	-- (薄くなったチョーク跡)
	fg_bright = "#FFFFFF",	-- (新品のチョークの白)
-- アクセント (Accents) - 温かみのあるパステル
	red       = "#E68E8E",	-- (サーモンピンク系の赤)
	green     = "#A7C080",	-- (抹茶のような優しい緑)
	yellow    = "#DBBC7F",	-- (落ち着いた黄土色)
	blue      = "#7FBBB3",	-- (空色と緑の中間。背景に馴染む青)
	purple    = "#D699B6",	-- (あずき色に近い紫)
	cyan      = "#83C092",	-- (青緑色のチョーク)
	orange    = "#E69875",	-- (テラコッタ系のオレンジ)
-- その他
	selection = "#495644",	-- (黒板を水拭きしたような濃い色)
	comment   = "#7A8478",	-- (消えかかった文字のようなグレー)

	-- Diff Highlights
	DiffAdd     = "#304030", -- 追加 (背景を暗く調整)
	DiffChange  = "#404020", -- 変更
	DiffDelete  = "#402020", -- 削除
	DiffText    = "#606030", -- 変更箇所の強調
}

-- ============================================================
-- 3. ハイライトグループ定義関数
-- ============================================================
local function set_hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

-- ============================================================
-- 4. 基本グループの設定 (ここだけ調整すればOK)
-- ============================================================

-- エディタの基本 UI
set_hl("Normal",       { fg = c.fg, bg = c.bg })      -- 普通の文字と背景
set_hl("CursorLine",   { bg = c.bg_light })           -- カーソル行
set_hl("LineNr",       { fg = c.fg_dim })             -- 行番号
set_hl("CursorLineNr", { fg = c.fg_bright, bold = true }) -- アクティブな行番号
set_hl("Visual",       { bg = c.selection })          -- 選択範囲
set_hl("Search",       { fg = c.bg, bg = c.yellow })  -- 検索結果
set_hl("Pmenu",        { fg = c.fg, bg = c.bg_light }) -- ポップアップメニュー
set_hl("PmenuSel",     { fg = c.bg, bg = c.blue })    -- ポップアップ選択中

-- 基本構文 (Syntax)
set_hl("Comment",      { fg = c.comment, italic = true }) -- コメント
set_hl("Constant",     { fg = c.orange })             -- 定数 (123, true, null)
set_hl("String",       { fg = c.green })              -- 文字列 ("hello")
set_hl("Character",    { fg = c.green })              -- 文字 ('a')
set_hl("Identifier",   { fg = c.fg })                 -- 変数名
set_hl("Function",     { fg = c.blue })               -- 関数名
set_hl("Statement",    { fg = c.purple })             -- 構文 (if, for, return)
set_hl("Type",         { fg = c.yellow })             -- 型 (int, bool, struct)
set_hl("Special",      { fg = c.red })                -- 特殊記号
set_hl("PreProc",      { fg = c.cyan })               -- プリプロセッサ (#include)
set_hl("Error",        { fg = c.fg_bright, bg = c.red, bold = true }) -- エラー
set_hl("Todo",         { fg = c.bg, bg = c.yellow, bold = true })     -- TODO

-- ============================================================
-- 追記推奨: UI要素 (フローティングウィンドウ、ボーダーなど)
-- ============================================================

-- 1. フローティングウィンドウ (Themeryなどの枠)
-- bg_dark (少し暗い背景) を定義していない場合は、bg="#... " の部分で作ってください
-- 例: bg_dark = "#324232" 
set_hl("NormalFloat", { fg = c.fg, bg = c.bg_dark })
set_hl("FloatBorder", { fg = c.fg_dim, bg = c.bg_dark })

-- 2. ウィンドウの区切り線
set_hl("WinSeparator", { fg = c.bg_light }) 

-- 3. マッチした括弧の強調 (カーソルを置いた時の対応するカッコ)
set_hl("MatchParen", { fg = c.yellow, bold = true, underline = true })

-- 4. 診断メッセージのアンダーライン (エラー箇所などの波線)
set_hl("DiagnosticUnderlineError", { sp = c.red, underline = true })
set_hl("DiagnosticUnderlineWarn",  { sp = c.yellow, underline = true })

-- ============================================================
-- 5. 魔法のリンク設定 (ここが「作法」の正体)
-- ============================================================
-- TreeSitterやLSPの複雑なグループを、上記の「基本グループ」に紐づけます。
-- これにより、細かい知識がなくても自動的に色が付きます。

-- TreeSitter (標準的なリンク)
set_hl("@variable",          { link = "Identifier" }) -- 変数は Identifier と同じ色
set_hl("@function",          { link = "Function" })   -- 関数は Function と同じ色
set_hl("@function.builtin",  { link = "Special" })    -- 組み込み関数は Special と同じ色
set_hl("@keyword",           { link = "Statement" })  -- キーワードは Statement と同じ色
set_hl("@string",            { link = "String" })     -- 文字列は String と同じ色
set_hl("@comment",           { link = "Comment" })    -- コメントは Comment と同じ色
set_hl("@type",              { link = "Type" })       -- 型は Type と同じ色
set_hl("@constant",          { link = "Constant" })   -- 定数は Constant と同じ色
set_hl("@constructor",       { link = "Type" })       -- コンストラクタは Type と同じ色
set_hl("@property",          { fg = c.fg_bright })    -- プロパティは少し明るく(独自設定例)

-- LSP (診断エラーなど)
set_hl("DiagnosticError",    { fg = c.red })
set_hl("DiagnosticWarn",     { fg = c.yellow })
set_hl("DiagnosticInfo",     { fg = c.blue })
set_hl("DiagnosticHint",     { fg = c.fg_dim })

-- Git (Diff)
set_hl("DiffAdd",    { bg = c.DiffAdd, fg = c.green }) -- 追加 (背景を暗く調整)
set_hl("DiffChange", { bg = c.DiffChange, fg = c.yellow }) -- 変更
set_hl("DiffDelete", { bg = c.DiffDelete, fg = c.red })    -- 削除
set_hl("DiffText",   { bg = c.DiffText, fg = c.fg_bright }) -- 変更箇所の強調

-- その他プラグイン (mini.nvimなど)
set_hl("MiniStatuslineModeNormal", { fg = c.bg, bg = c.green, bold = true })
set_hl("MiniStatuslineModeInsert", { fg = c.bg, bg = c.blue, bold = true })
set_hl("MiniStatuslineModeVisual", { fg = c.bg, bg = c.purple, bold = true })



