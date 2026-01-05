return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Language specific
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
    },
    keys = {
      { '<leader>dc', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Conditional Breakpoint' },
      { '<leader>dr', function() require('dap').restart() end, desc = 'Debug: Restart' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'Debug: Terminate' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
      { '<leader>de', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Debug: Eval Under Cursor' },
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'

      require('mason-nvim-dap').setup {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          'delve',
          'debugpy',
          'codelldb',
        },
      }

      require('dapui').setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      require('nvim-dap-virtual-text').setup {
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match 'secret' or name:match 'api' or value:match 'secret' or value:match 'api' then
            return '*****'
          end

          if #variable.value > 15 then
            return ' ' .. string.sub(variable.value, 1, 15) .. '... '
          end

          return ' ' .. variable.value
        end,
      }

      -- UI opens automatically when debugging starts
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end

      -- Go
      require('dap-go').setup {
        delve = {
          detached = vim.fn.has 'win32' == 0,
        },
      }

      -- Python
      require('dap-python').setup 'python'

      -- C/C++ with codelldb
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
        {
          name = 'Attach to process',
          type = 'codelldb',
          request = 'attach',
          pid = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
