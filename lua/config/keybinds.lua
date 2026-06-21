vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", "<cmd>Oil<cr>")

local term_buf = nil

local function toggle_terminal()
  -- Look for an existing open terminal window across all viewports
  local term_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if buf == term_buf then
      term_win = win
      break
    end
  end

  -- If the window is open, close it
  if term_win then
    vim.api.nvim_win_close(term_win, true)
  else
    -- Open a horizontal split in the CURRENT working directory
    vim.cmd("botright split")
    vim.api.nvim_win_set_height(0, 15)
    local new_win = vim.api.nvim_get_current_win()
    
    -- Reuse existing buffer or spawn a new terminal shell
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.api.nvim_win_set_buf(new_win, term_buf)
    else
      vim.cmd("terminal")
      term_buf = vim.api.nvim_get_current_buf()
    end
    vim.cmd("startinsert")
  end
end

-- Bind the toggle function to Ctrl + `
vim.keymap.set('n', '<C-₹>', toggle_terminal, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<C-₹>', toggle_terminal, { desc = 'Toggle terminal from inside' })
-- Use Ctrl+w navigation directly from inside the terminal
vim.keymap.set('t', '<C-w>h', [[<C-\><C-n><C-w>h]], { desc = 'Move to left window' })
vim.keymap.set('t', '<C-w>j', [[<C-\><C-n><C-w>j]], { desc = 'Move to bottom window' })
vim.keymap.set('t', '<C-w>k', [[<C-\><C-n><C-w>k]], { desc = 'Move to top window' })
vim.keymap.set('t', '<C-w>l', [[<C-\><C-n><C-w>l]], { desc = 'Move to right window' })

-- Cycle through windows using Ctrl+w w from inside the terminal
vim.keymap.set('t', '<C-w>w', [[<C-\><C-n><C-w>w]], { desc = 'Cycle window' })

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.opt.clipboard = "unnamedplus"
