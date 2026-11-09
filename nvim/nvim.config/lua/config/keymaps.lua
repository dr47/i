-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", {
  desc = "CodeCompanion: zobrazit/skrýt chat",
})

vim.keymap.set("n", "<leader>aa", ":CodeCompanion ", {
  desc = "CodeCompanion: upravit aktuální soubor",
})

if vim.g.neovide then
  local function paste()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end

  for _, key in ipairs({ "<C-v>", "<C-S-v>" }) do
    vim.keymap.set({ "n", "i", "v", "c", "t" }, key, paste, {
      silent = true,
      desc = "Vložit ze systémové schránky",
    })
  end

  for _, key in ipairs({ "<C-c>", "<C-S-c>" }) do
    vim.keymap.set("v", key, '"+y', {
      silent = true,
      desc = "Kopírovat do systémové schránky",
    })
  end
end
