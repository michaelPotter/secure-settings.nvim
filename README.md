A plugin to securely edit secrets files in Neovim.

Another interesting plugin is: https://github.com/bgaillard/readonly.nvim

This plugin sets certain security settings (or unsets insecure settings) when modifying a file that contains secrets.

## Setup

```lua

require('secure-settings').setup({
  notify = true,
  file_patterns = {
    "~/.ssh/*",
    "~/.aws/*",
  }
})

```

## Securing

There are two levels of security: buffer level and session level.

Buffer level security includes things like disabling swapfile or undofile for that buffer. Session level security means
that backup files or shada files (which contain e.g. register changes) won't be written for any files in this vim
session. See the source code for exact settings.

By default (and there isn't a way to change this yet) Session level security will be used if the first file edited
in a session is a secrets file (i.e. the VimEnter autocmd). Otherwise, if a secrets file is opened in an existing session, buffer level security
will be used.

## Future (potential) work
- add an option to configure security level
- add an option to add additional security settings
