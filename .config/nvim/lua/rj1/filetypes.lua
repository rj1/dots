local filetype_map = {
	[vim.fn.expand("$HOME/.ssh/servers")] = "sshconfig",
	[vim.fn.expand("$XDG_CONFIG_HOME/yambar/config.yml##hostname.empy")] = "yaml",
	[vim.fn.expand("$XDG_CONFIG_HOME/yambar/config.yml##hostname.splitty")] = "yaml",
	[vim.fn.expand("$XDG_CONFIG_HOME/alot/config")] = "toml",
	[vim.fn.expand("$XDG_CONFIG_HOME/sway/config##hostname.empy")] = "swayconfig",
	[vim.fn.expand("$XDG_CONFIG_HOME/sway/config##hostname.splitty")] = "swayconfig",
	[vim.fn.expand("$XDG_CONFIG_HOME/waybar/config*")] = "json",
}

for filename, filetype in pairs(filetype_map) do
	vim.api.nvim_create_autocmd("bufread", {
		pattern = filename,
		callback = function()
			vim.api.nvim_buf_set_option(0, "filetype", filetype)
		end,
	})
end
