-- codeium
-- disabled by default
vim.g.codeium_disable_bindings = true
vim.g.codeium_enabled = false

function Toggle_codeium()
	vim.g.codeium_enabled = not vim.g.codeium_enabled

	if vim.g.codeium_enabled then
		-- HACK: why do we have to do this?
		vim.cmd(':Codeium EnableBuffer')

		-- set keybinds for ai completions
		vim.keymap.set('i', '<right>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
		vim.keymap.set('i', '<up>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
		vim.keymap.set('i', '<down>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
	else
		-- HACK: why do we have to do this?
		vim.cmd(':Codeium DisableBuffer')

		-- unset keybinds for ai completions
		vim.keymap.del('i', '<right>')
		vim.keymap.del('i', '<up>')
		vim.keymap.del('i', '<down>')
	end
end

vim.api.nvim_set_keymap('n', '<leader>ai', ':lua Toggle_codeium()<cr>', { noremap = true, silent = true })

	if handle ~= nil then
		local key = string.gsub(handle:read("*a"), "\n", "")
		handle:close()
		return key
	end
end

require("gp").setup({
	providers = {
		openai = {
			endpoint = "https://api.groq.com/openai/v1/chat/completions",
			secret = fetch_groq_key(),
		},
	},
	agents = {
		{
			name = "dev",
			provider = "openai",
			chat = true,
			command = false,
 			model = { model = "llama3-70b-8192", temperature = 1.1, top_p = 1 },
			system_prompt = "You are an AI assistant for a professional programmer.\n\n"
				.. "The user provided the additional info about how they would like you to respond:\n\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide a better answer.\n"
				.. "- Think deeply and carefully from first principles, going through the problem step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use the Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't exclude any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n",
		},
	},
	chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/ai/chats",
	chat_user_prefix = "## prompt",
	chat_assistant_prefix = "## response ",
})
