vim.opt.guifont = "UDEV Gothic NF:h10"
vim.cmd('colorscheme tokyonight')
-- nvy_config.lua の記述例

-- 1. カーソル形状の制御
-- NvyはGUICursorの設定を忠実に守ります。
-- もしカーソル点滅などが重いと感じたら、blinkwaitなどを調整します。
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- 2. マウスの挙動
-- GUIならではのマウススクロールの感度調整などが有効な場合があります。
-- (Nvyが対応している範囲に限られますが、誤操作防止に)
vim.opt.mouse = "a" 
-- 右クリックメニューを無効化してVim本来の挙動にする(Nvyは元々メニューが無いですが念の為)
vim.opt.mousemodel = "extend"

-- 3. FPS制限 (もしNvyが対応していれば)
-- 多くのGUIクライアントはリフレッシュレートの設定を持っていますが、
-- Nvyはコマンドライン引数や環境変数で制御する場合が多いです。
-- (例: 描画更新が速すぎてチラつく場合の対策として覚えておいてください)

