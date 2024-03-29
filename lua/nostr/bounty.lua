local M = {}

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local popup_options = {
	position = "40%",
	size = 40,
	border = {
		style = "rounded",
		text = {
			top_align = "left",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal",
	},
}

local function add_binds(input)
	input:mount()

	-- unmount component when cursor leaves buffer
	-- input:on(event.BufLeave, function()
	-- 	input:unmount()
	-- end)

	input:map("n", "<Esc>", function()
		input:unmount()
	end, { noremap = true })
end

function M.post()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local buffer_content = table.concat(lines, "\n")
	popup_options.border.text.top = "Enter summary"
	local summary_input = Input(popup_options, {
		prompt = "> ",
		default_value = "",
		on_submit = function(summary)
			popup_options.border.text.top = "Enter value (in Sats)"
			local value_input = Input(popup_options, {
				prompt = "> ",
				default_value = "",
				on_submit = function(value)
					vim.ui.select({ "yes", "no" }, {
						prompt = "Post bounty?",
					}, function(choice)
						if choice == "yes" then
							vim.fn["NostrPublishReplaceableParameterizedNote"](
								30050,
								buffer_content,
								{ { "summary", summary }, { "value", value }, {"status", "open"} }
							)
						end
					end)
				end,
			})

			add_binds(value_input)
		end,
	})

	add_binds(summary_input)
end

return M
