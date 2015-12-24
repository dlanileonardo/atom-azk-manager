getCommands = ->
  AzkManager                 = require '../azk-manager'
  InteractiveCommand         = require '../models/interactive'

  commands = []
  commands.push ['azk-manager:agent-start', 'Agent Start', -> AzkManager.agentStart()]
  commands.push ['azk-manager:agent-stop', 'Agent Stop', -> AzkManager.agentStop()]
  commands.push ['azk-manager:agent-status', 'Agent Status', -> AzkManager.agentStatus()]

  commands.push ['azk-manager:init' , 'Init', -> AzkManager.init()]

  commands.push ['azk-manager:status' , 'Status', -> AzkManager.status()]
  commands.push ['azk-manager:start' , 'Start', -> AzkManager.start()]
  commands.push ['azk-manager:stop', 'Stop', -> AzkManager.stop()]

  commands.push ['azk-manager:interactive', 'Interactive Command', -> InteractiveCommand.interactive()]

  commands.push ['azk-manager:logs' , 'Logs', -> AzkManager.logs()]
  commands.push ['azk-manager:logs-follow' , 'Follow Logs', -> AzkManager.logs(true)]
  commands.push ['azk-manager:open' , 'Open in Browser', -> AzkManager.open()]

  commands.push ['azk-manager:toggle-panel', 'Toggle Panel', -> AzkManager.togglePanel()]
  commands.push ['azk-manager:kill-last-command', 'Kill Last Command', -> AzkManager.killLastCommand()]

  return commands

module.exports = getCommands
