local function has_collapsed_directory(tree, node)
  if node.type == "directory" and (node.loaded == false or (node:has_children() and not node:is_expanded())) then
    return true
  end

  for _, child in ipairs(tree:get_nodes(node:get_id())) do
    if has_collapsed_directory(tree, child) then
      return true
    end
  end

  return false
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  opts = {
    sources = {
      "filesystem",
    },
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem" },
      },
    },
    close_if_last_window = true,
    window = {
      position = "right",
      mappings = {
        ["c"] = {
          "copy",
          config = {
            show_path = "relative",
          },
        },
        ["m"] = {
          "move",
          config = {
            show_path = "relative",
          },
        },
        ["o"] = "system_open",
        ["<leader>z"] = { "toggle_directory_recursively", desc = "Toggle directory recursively" },
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
        },
        never_show = { ".git", "node_modules" },
      },
      use_libuv_file_watcher = true, -- refresh automagically?
      commands = {
        toggle_directory_recursively = function(state)
          local node = state.tree:get_node()
          if not node or node.type ~= "directory" then
            return
          end

          if has_collapsed_directory(state.tree, node) then
            state.commands.expand_all_subnodes(state)
            return
          end

          if node:has_children() then
            local root = state.tree:get_nodes()[1]
            local command = node:get_id() == root:get_id() and state.commands.close_all_nodes
              or state.commands.close_all_subnodes
            command(state)
          end
        end,
        -- Override delete to use trash instead of rm
        delete = function(state)
          local path = state.tree:get_node().path
          vim.fn.system({ "trash", vim.fn.fnameescape(path) })
          require("neo-tree.sources.manager").refresh(state.name)
        end,
        -- open with finder!
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          -- escape spaces and parens to make them actually open-able
          local escaped_path = string.gsub(path, ".", {
            [" "] = "\\ ",
            ["("] = "\\(",
            [")"] = "\\)",
          })
          -- macOS: open file in default application
          vim.api.nvim_exec2("!open " .. escaped_path .. "", {})
        end,
      },
      hijack_netrw_behavior = "open_default",
    },
  },
}
