return {
  enabled = false,
  dir = '/home/jasonph/opencode.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  opts = {
    completion = {
      auto_trigger = false,
      debounce = 150,
      accept_key = '<Tab>',
      dismiss_key = '<C-e>',
    },
    model = {
      provider = 'opencode',
      model_id = 'mimo-v2-pro-free',
    },
    inline = {
      enabled = true,
      preview = true,
    },
  },
}
