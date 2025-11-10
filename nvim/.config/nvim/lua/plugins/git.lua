return {
  -- Inline git blame (like GitLens)
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.g.gitblame_enabled = 1
      vim.g.gitblame_message_template = " <summary> • <date> • <author>"
      vim.g.gitblame_date_format = "%r"
      vim.g.gitblame_virtual_text_column = 80

      -- Custom function to open PR for current line's commit
      local function open_commit_pr()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        local file = vim.fn.expand("%:p")

        -- Get commit hash for current line
        local cmd = string.format("git blame -L %d,%d --porcelain %s | head -1 | awk '{print $1}'", line, line, file)
        local commit_hash = vim.fn.system(cmd):gsub("%s+", "")

        if commit_hash == "" or commit_hash:match("^0+$") then
          vim.notify("No commit found for this line", vim.log.levels.WARN)
          return
        end

        -- Find PR using gh CLI
        local pr_cmd = string.format("gh pr list --search '%s' --state merged --json number,url --limit 1", commit_hash)
        local pr_result = vim.fn.system(pr_cmd)

        if vim.v.shell_error == 0 and pr_result ~= "[]" then
          local pr_data = vim.fn.json_decode(pr_result)
          if pr_data and #pr_data > 0 then
            vim.fn.system(string.format("xdg-open '%s'", pr_data[1].url))
            vim.notify("Opening PR #" .. pr_data[1].number, vim.log.levels.INFO)
          else
            vim.notify("No PR found for commit " .. commit_hash:sub(1, 7), vim.log.levels.WARN)
          end
        else
          vim.notify("GitHub CLI (gh) not available or no PR found", vim.log.levels.WARN)
        end
      end

      vim.keymap.set("n", "<leader>go", open_commit_pr, { desc = "Open PR for this line" })
    end,
    keys = {
      { "<leader>gt", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    },
  },
}
