local chat = require("CopilotChat")

------ Open chat window
----chat.open()
----
------ Open chat window with custom options
----chat.open({
----  window = {
----    layout = 'float',
----    title = 'My Title',
----  },
----})
----
------ Close chat window
----chat.close()
----
------ Toggle chat window
----chat.toggle()
----
------ Toggle chat window with custom options
----chat.toggle({
----  window = {
----    layout = 'float',
----    title = 'My Title',
----  },
----})
----
------ Reset chat window
----chat.reset()
----
------ Ask a question
----chat.ask("Explain how it works.")
----
------ Ask a question with custom options
----chat.ask("Explain how it works.", {
----  selection = require("CopilotChat.select").buffer,
----})
----
------ Ask a question and do something with the response
----chat.ask("Show me something interesting", {
----  callback = function(response)
----    print("Response:", response)
----  end,
----})
----
-- Get all available prompts (can be used for integrations like fzf/telescope)
local prompts = chat.prompts()

-- Get last copilot response (also can be used for integrations and custom keymaps)
local response = chat.response()

-- Pick a prompt using vim.ui.select
local actions = require("CopilotChat.actions")

-- Pick help actions
actions.pick(actions.help_actions())

-- Pick prompt actions
actions.pick(actions.prompt_actions({
    selection = require("CopilotChat.select").visual,
}))
