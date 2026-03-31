return {
  enabled = false,
  dir = '/home/jasonph/claude-inline.nvim',
  config = function()
    require('claude-inline').setup {}
  end,
  keys = {
    { '<C-k>', mode = 'v', desc = 'Claude Inline Edit' },
  },
}
