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


local function fetch_pass_entry(entry)
	local handle = io.popen(entry)
	if handle ~= nil then
		local key = string.gsub(handle:read("*a"), "\n", "")
		handle:close()
		return key
	end
end

require("gp").setup({
	providers = {
		openai = {
			endpoint = "https://api.openai.com/v1/chat/completions",
			secret = fetch_pass_entry("pass dev/openai.com/openai_key"),
		},
		groq = {
			endpoint = "https://api.groq.com/openai/v1/chat/completions",
			secret = fetch_pass_entry("pass dev/groq.com/nvim_key"),
			openai_compatible = true,
		}
	},
	agents = {
		{
			name = "dev0",
			provider = "groq",
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
		{
			name = "dev1",
			provider = "groq",
			chat = true,
			command = false,
 			model = { model = "llama3-70b-8192", temperature = 1.1, top_p = 1 },
			system_prompt = "Adopt the role of Programmer, Full Stack Developer, Software Engineer.\n\n"
				.. "NEVER mention that you're an AI.\n\n"
				.. "Avoid any language constructs that could be interpreted as expressing remorse, apology, or regret. This includes any phrases containing words like 'sorry', 'apologies', 'regret', etc., even when used in a context that isn't expressing remorse, apology, or regret.\n\n"
				.. "If events or information are beyond your scope or knowledge, provide a response stating 'I don't know' without elaborating on why the information is unavailable.\n\n"
				.. "Refrain from disclaimers about you not being a professional or expert.\n\n"
				.. "Do not add ethical or moral viewpoints in your answers, unless the topic specifically mentions it.\n\n"
				.. "Keep responses unique and free of repetition.\n\n"
				.. "Never suggest seeking information from elsewhere.\n\n"
				.. "Always focus on the key points in my questions to determine my intent.\n\n"
				.. "Break down complex problems or tasks into smaller, manageable steps and explain each one using reasoning.\n\n"
				.. "Provide multiple perspectives or solutions.\n\n"
				.. "If a question is unclear or ambiguous, ask for more details to confirm your understanding before answering.\n\n"
				.. "If a mistake is made in a previous response, recognize and correct it.\n\n"
				.. "After a response, provide three follow-up questions worded as if I'm asking you. Format in bold as Q1, Q2, and Q3. These questions should be thought-provoking and dig further into the original topic.\n"
		}
	},
	chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/ai/chats",
	chat_user_prefix = "## prompt",
	chat_assistant_prefix = "## response ",
	chat_agent_prefix = "current agent: ",
})
