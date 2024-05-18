-- codeium
-- vim.g.codeium_enabled = false
-- vim.g.codeium_disable_bindings = 1

--[[ function Codeium_status()
	local status = vim.fn["codeium#GetStatusString"]()
	status = string.gsub(status, "^%s+", "")
	status = string.lower(status)
	return status
end ]]

-- use <leader>ai to toggle codeium
--[[ vim.keymap.set("n", "<leader>ai", function()
	if Codeium_status() == "on" then
		vim.g.codeium_enabled = false
	else
		vim.g.codeium_enabled = true
	end
end, { noremap = true }) ]]


local function fetch_openai_key()
	local handle = io.popen("pass dev/openai.com/openai_key")
	if handle ~= nil then
		local key = string.gsub(handle:read("*a"), "\n", "")
		handle:close()
		return key
	end
end

local function fetch_groq_key()
	local handle = io.popen("pass dev/groq.com/nvim_key")
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
