-- 2025/12/02 15:56 first stable-check ended
-- ###############################################
-- !!! warning !!! this file is under the test !!!
-- ###############################################

local function rgb_to_hex(n)
  if not n then return "NONE" end
  return string.format("#%06x", n)
end

local function export_from_live_theme(name)
  local groups = vim.fn.getcompletion("", "highlight")

  local lines = {
    "vim.cmd [[",
    "highlight clear",
    "if exists('syntax_on')",
    "  syntax reset",
    "endif",
    "set background=dark",
    "]]",
    "",
    string.format("vim.g.colors_name = '%s'", name),
    "",
  }

  table.insert(lines, "local function H(group, opts)")
  table.insert(lines, "  vim.api.nvim_set_hl(0, group, opts)")
  table.insert(lines, "end\n")

  for _, group in ipairs(groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
    if ok and hl then
      local fg = rgb_to_hex(hl.fg)
      local bg = rgb_to_hex(hl.bg)
      local sp = rgb_to_hex(hl.sp)

      local opts = {}
      if fg ~= "NONE" then table.insert(opts, string.format("fg = '%s'", fg)) end
      if bg ~= "NONE" then table.insert(opts, string.format("bg = '%s'", bg)) end
      if sp ~= "NONE" then table.insert(opts, string.format("sp = '%s'", sp)) end
      if hl.bold then table.insert(opts, "bold = true") end
      if hl.italic then table.insert(opts, "italic = true") end
      if hl.underline then table.insert(opts, "underline = true") end

      local opts_str = "{ " .. table.concat(opts, ", ") .. " }"
      table.insert(lines, string.format("H('%s', %s)", group, opts_str))
    end
  end

  local outfile = vim.fn.stdpath("config") .. "/colors/" .. name .. ".lua"
  local f = io.open(outfile, "w")
  for _, line in ipairs(lines) do
    f:write(line .. "\n")
  end
  f:close()

  print("Exported to " .. outfile)
end

