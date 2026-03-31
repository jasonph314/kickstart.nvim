return {
  'supermaven-inc/supermaven-nvim',
  enabled = false,
  config = function()
    require('supermaven-nvim').setup {
      disable_inline_completion = true,
    }

    vim.keymap.set('n', '<leader>ts', function()
      local api = require 'supermaven-nvim.api'
      if api.is_running() then
        api.stop()
        print 'Supermaven stopped'
      else
        api.start()
        print 'Supermaven started'
      end
    end, { desc = '[T]oggle [S]upermaven' })
  end,
}
