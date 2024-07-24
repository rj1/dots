-- gitsigns
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 0,
		virt_text_pos = 'eol'
	},
	attach_to_untracked = true,
	_on_attach_pre = function(_, callback)
		vim.schedule(function()
			-- if buffer is not a file, don't change anything
			local file = vim.fn.expand("%:p")
			if not vim.fn.filereadable(file) then
				return callback()
			end
			local repo = vim.fn.expand("~/.local/share/yadm/repo.git")
			-- use yadm ls-files to check if the file is tracked
			require("plenary.job")
				:new({
					command = "yadm",
					args = { "ls-files", "--error-unmatch", file },
					on_exit = vim.schedule_wrap(function(_, return_val)
						if return_val == 0 then
							return callback({
								gitdir = repo,
								toplevel = os.getenv("HOME"),
							})
						else
							return callback()
						end
					end),
				})
			:sync()
		end)
	end,
})
