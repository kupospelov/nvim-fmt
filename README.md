# nvim-fmt

A generic plugin that can be configured to run `gofmt`, `clang-format`, or anything else to format the current buffer.

Just call `format()` to run the formatter or configure the plugin to autoformat the buffer before writing to the file.

## Installation

[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua

require('packer').startup(function(use)
    use('kupospelov/nvim-fmt')
end)

```

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua

require('lazy').setup({
    { 'kupospelov/nvim-fmt' },
})

```

## Configuration

Settings can be changed using the `setup` function that accepts a table with the following fields:
* `formatters` is a map of formatters keyed by the associated [filetypes](https://neovim.io/doc/user/filetype.html#filetypes).
* `options` contains optional flags.
  * `create_autocmd` enables a `BufWritePre` autocmd that formats the current buffer before writing to the file.

`formatter` is a shell command that reads from standard input and writes to standard output. In case `formatter` returns a non-zero exit code, the output is shown as an error message.

### Example

```lua
local fmt = require('fmt')
fmt.setup({
	formatters = {
		['go'] = 'gofmt',
		['lua'] = 'stylua --search-parent-directories -',
	},
	options = {
		create_autocmd = true,
	},
})
```
