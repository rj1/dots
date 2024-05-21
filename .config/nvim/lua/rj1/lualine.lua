local colors = require("onedarkpro.helpers").get_colors()

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local function random_icon()
	local symbols = { "󰊠", "󰊮", "󰣐", "󰊓", "󰊔", "󰇥" }
	local randomIndex = math.random(1, #symbols)
	return symbols[randomIndex]
end

local function lsp_servers()
	local servers = {}
	for _, server in pairs(vim.lsp.buf_get_clients()) do
		table.insert(servers, server.name)
	end
	return table.concat(servers, ", ")
end

local navic = require("nvim-navic")

local function is_codeium_enabled()
  if vim.g.codeium_enabled then
		return "on"
	else
		return "off"
	end
end

-- lualine
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "onedark",
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		disabled_filetypes = { "NvimTree" },
	},
	sections = {
		lualine_a = {
			{
				"mode",
				-- 󰊠
				icon = random_icon(),
				color = { gui = "bold" },
				fmt = string.lower,
			},
		},
		lualine_c = {
			{
				"branch",
				color = { fg = colors.fg },
			},
			{
				"diff",
				source = diff_source,
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.yellow },
					removed = { fg = colors.red },
				},
				symbols = { added = " ", modified = "⊡ ", removed = " " },
			},
			{
				"diagnostics",
				symbols = {
					error = "󰅗 ",
					warn = "󰅉 ",
					info = "󰅍 ",
					hint = "󰌵 ",
				},
			},
			{
				lsp_servers,
				icon = "",

				color = function()
					if vim.lsp.status()[1] then
						return { fg = colors.red }
					end
					return { fg = colors.purple }
				end,
			},
			{
				is_codeium_enabled,
				icon = "󰧑 ai:",

				color = function()
					if vim.g.codeium_enabled then
						return { fg = colors.green }
					else
						return { fg = colors.red }
					end
				end,
			},
			--[[ {
				"navic",
				color_correction = nil,
				navic_opts = nil
			}, ]]
		},
		lualine_b = {
			{
				Session_name,
				icon = "",
				color = { fg = colors.fg },
			},
		},
		lualine_x = {
			{
				"encoding",
        color = { fg = colors.purple },

			},
			{
				"fileformat",
			},
			{
				"filetype",
        color = { fg = colors.blue },
			},
		},
		lualine_y = { { "progress", color = { fg = colors.fg }, fmt = string.lower } },
	},
})
