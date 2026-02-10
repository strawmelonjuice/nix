-- Options are automatically loaded before lazy.nvim startup
-- Add any additional options here

-- // Set mapleader to ','
vim.cmd.let('mapleader = "<SPACE>"')

vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

vim.filetype.add({
    extension = {
        jsonc = "json",
    },
})
