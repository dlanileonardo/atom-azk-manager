Utils = require '../run-command/utils'

module.exports.executeCommand = (command, instance) ->
  Utils.runner.run("azk #{command} #{instance}")
