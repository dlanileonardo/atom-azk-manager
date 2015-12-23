getCommands = ->
  InteractiveCommand         = require '../models/interactive'

  commands = []
  commands.push ['azk-manager:start' , 'Start', -> InteractiveCommand.command("start")]
  commands.push ['azk-manager:stop', 'Stop', -> InteractiveCommand.command("stop")]
  commands.push ['azk-manager:logs' , 'Logs', -> InteractiveCommand.command("logs")]
  commands.push ['azk-manager:open' , 'Open in Browser', -> InteractiveCommand.command("open")]
  return commands

module.exports = getCommands
