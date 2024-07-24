local supermaven = require("supermaven-nvim.api")

function Toggle_supermaven()
	if supermaven.is_running() then
		supermaven.stop()
	else
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<right>",
				clear_suggestion = "<C-]>",
				accept_word = "<down>",
			},
			color = {
				suggestion_color = "#ffffff",
				cterm = 244,
			},
			disable_inline_completion = false,
			disable_keymaps = false
		})
	end
end

vim.api.nvim_set_keymap('n', '<leader>ai', ':lua Toggle_supermaven()<cr>', { noremap = true, silent = true })

local function fetch_pass_entry(entry)
	local handle = io.popen("pass " .. entry)
	if handle ~= nil then
		local key = string.gsub(handle:read("*a"), "\n", "")
		handle:close()
		return key
	end
end

local dev_prompt = "Adopt the role of Programmer, Full Stack Developer, Software Engineer.\n\n"
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


local assistant_prompt = "Adopt the role of a general assistant, helpful and polite, respectful and honest, interested in details, curious, knows best, and never fails to answer.\n\n"
.. "NEVER mention that you're an AI.\n\n"
.. "You are great at writing technical documentation, email responses, meeting notes, and all other manner of writing\n\n"

require("ai").setup({
	providers = {
		openai = {
			secret = fetch_pass_entry("dev/openai.com/openai_key")
		},
		groq = {
			secret = fetch_pass_entry("dev/groq.com/nvim_key")
		},
		anthropic = {
			secret = fetch_pass_entry("ai/anthropic.com/keys/ai.nvim")
		},
		google = {
			secret = fetch_pass_entry("aistudio.google.com/superchunk420@gmail.com/api_key")
		}
	},
	agents = {
		{
			name = "groq dev",
			provider = "groq",
			chat = true,
			command = false,
			model = { model = "llama-3.1-70b-versatile", temperature = 1.1, top_p = 1 },
			system_prompt = dev_prompt,
		},
		{
			name = "groq assistant",
			provider = "groq",
			chat = true,
			command = false,
			model = { model = "llama-3.1-70b-versatile", temperature = 1.1, top_p = 1 },
			system_prompt = assistant_prompt,
		},
		{
			name = "claude dev",
			provider = "anthropic",
			chat = true,
			command = false,
			model = { model = "claude-3-5-sonnet-20240620", temperature = 0.6, top_p = 1 },
			system_prompt = dev_prompt,
		},
		{
			name = "claude assistant",
			provider = "anthropic",
			chat = true,
			command = false,
			model = { model = "claude-3-5-sonnet-20240620", temperature = 0.6, top_p = 1 },
			system_prompt = assistant_prompt,
		},
		{
			name = "claude generic",
			provider = "anthropic",
			chat = true,
			command = false,
			model = { model = "claude-3-5-sonnet-20240620", temperature = 0.6, top_p = 1 },
			system_prompt = "You are a useful AI assistant."
		},
		{
			name = "openai dev",
			provider = "openai",
			chat = true,
			command = false,
			model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
			system_prompt = dev_prompt,
		},
		{
			name = "llama dev (local)",
			provider = "ollama",
			chat = true,
			command = false,
			model = { model = "llama3-70b-8192", temperature = 1.1, top_p = 1 },
			system_prompt = dev_prompt,
		},
		{
			name = "llama assistant (local)",
			provider = "ollama",
			chat = true,
			command = false,
			model = { model = "llama4-70b-8192", temperature = 1.1, top_p = 1 },
			system_prompt = assistant_prompt,
		},
		{
			provider = "ollama",
			name = "gemma2 dev (local)",
			chat = true,
			command = false,
			model = { model = "gemma-2-27b-it", temperature = 1.1, top_p = 1 },
			system_prompt = dev_prompt,
		},
	},
})
