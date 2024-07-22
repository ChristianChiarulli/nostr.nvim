# nostr.nvim

![demo](https://private-user-images.githubusercontent.com/29136904/346804750-a6d39df0-1e17-4333-8efc-91c05ea20a33.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjA0OTc2NjAsIm5iZiI6MTcyMDQ5NzM2MCwicGF0aCI6Ii8yOTEzNjkwNC8zNDY4MDQ3NTAtYTZkMzlkZjAtMWUxNy00MzMzLThlZmMtOTFjMDVlYTIwYTMzLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA3MDklMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwNzA5VDAzNTYwMFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTcyODUzNjM0ODM0YmM4OTFiNGM2YmY5NzBkMmY2NDhlZDBjNjVmYTk0YzZlZjkwOWJjZjc2YzZmMzY2OTdiYjEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.684mmfATlY6LbNKMFiVhr_KMJZLfC6YJoAYyJBaGVRQ)

## Install

```bash
npm i -g neovim # this package is required
```

Lazy spec:

```lua
local M = {
  "nodetec/nostr.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = { "npm install", "npm run build", ":UpdateRemotePlugins" },
}

function M.config()
  require("nostr").setup {}
end

return M
```

## Getting Started

To get started run the command:

```
:NostrGenerateConfig
```

This will create a config file at `~/.local/share/nostr.nvim/config.json` where you can change your `nsec` and `npub` if you already have a keypair.

## Post a note to nostr

```
:NostrSendNote Hello Nostr from Neovim!
```

## Troubleshooting

If you're having issues with the commands not being available try running:

```
:UpdateRemotePlugins
```

## A function you can add to your init.lua to enable a command, NostrSendNoteBuffer, to send the current neovim file as notes
#### Unforunately, it sends every single line as its own note. Would like to enhance this function or make a new one, which would allow an entire file (such as a markdown file) to be added as a nostr note as a singular note.
```
require("config.lazy")
function SendBufferToNostrSendNote()
  -- Get all lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Process each line
  for i, line in ipairs(lines) do
    -- Escape the line content
    local escaped_line = vim.fn.shellescape(line)
    
    -- Execute NostrSendNote with pcall to catch errors
    local ok, result = pcall(function()
      vim.cmd('NostrSendNote ' .. escaped_line)
    end)
    
    -- Check for errors
    if not ok then
      -- Display error message
      print("Error on line " .. i .. ": " .. result)
      return
    end
  end
  
  print("NostrSendNote executed successfully for all lines")
end

-- Create the user command
vim.api.nvim_create_user_command('NostrSendNoteBuffer', SendBufferToNostrSendNote, {})


```
