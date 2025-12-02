-- 2025/12/02 15:56 first stable-check ended
local options = {
	number = true,

	cursorline = true,

	hlsearch = true,

	wrap = true,

	smartindent = true,

	list = true,

	listchars = { tab = '»-', trail = '-', eol = '↲', extends = '»', precedes = '«', nbsp = '%' },

	timeoutlen = 500,

	autochdir = true,
}

vim.opt.clipboard:append({ "unnamed", "unnamedplus" })


for k, v in pairs(options) do
	vim.opt[k] = v
end


-- vim.opt.clipboard = 'unnamedplus'

-- oh... yes...

