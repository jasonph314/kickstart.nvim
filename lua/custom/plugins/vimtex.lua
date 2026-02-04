return {
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      -- PDF viewer configuration (macOS uses Skim, Linux uses Zathura)
      if vim.fn.has 'mac' == 1 or vim.fn.has 'macunix' == 1 then
        vim.g.vimtex_view_method = 'skim'
      else
        vim.g.vimtex_view_method = 'zathura'
        vim.g.vimtex_view_general_options = '--unique file:@pdf#src:@line@tex'
      end

      -- Compiler configuration
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        build_dir = '',
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        hooks = {},
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      -- Enable shell escape for packages that need it
      vim.g.vimtex_compiler_latexmk.options = {
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      }

      -- Enable syntax highlighting
      vim.g.vimtex_syntax_enabled = 1

      -- Enable quickfix auto open
      vim.g.vimtex_quickfix_mode = 0

      -- Enable folding
      vim.g.vimtex_fold_enabled = 0

      -- Enable toc (table of contents)
      vim.g.vimtex_toc_config = {
        split_pos = 'leftabove',
        split_width = 30,
        mode = 1,
        fold_enable = 0,
        show_help = 0,
      }

      -- Enable imaps (insert mode mappings)
      vim.g.vimtex_imaps_enabled = 1

      -- Enable completion
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_complete_close_braces = 1

      -- Enable syntax conceal
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        cites = 1,
        fancy = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }
    end,
    config = function()
      -- Keymaps for LaTeX files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'tex', 'latex' },
        callback = function()
          local opts = { buffer = true, silent = true }
          local map = vim.keymap.set

          -- Compile
          map('n', '<leader>lc', '<cmd>VimtexCompile<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex [C]ompile' }))
          -- View PDF
          map('n', '<leader>lv', '<cmd>VimtexView<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex [V]iew' }))
          -- Stop compilation
          map('n', '<leader>lk', '<cmd>VimtexStop<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex Stop ([K]ill)' }))
          -- Clean auxiliary files
          map('n', '<leader>ll', '<cmd>VimtexClean<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex c[L]ean' }))
          -- Full clean (including PDF)
          map('n', '<leader>lL', '<cmd>VimtexClean!<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex full c[L]ean' }))
          -- TOC/Outline
          map('n', '<leader>lt', '<cmd>VimtexTocOpen<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex [T]OC' }))
          -- Errors
          map('n', '<leader>le', '<cmd>VimtexErrors<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex [E]rrors' }))
          -- Status
          map('n', '<leader>ls', '<cmd>VimtexStatus<cr>', vim.tbl_extend('force', opts, { desc = '[L]atex [S]tatus' }))
        end,
      })
    end,
  },
}
