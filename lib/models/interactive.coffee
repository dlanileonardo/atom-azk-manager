AzkCommands = require '../commands/azk-interactive-commands'
InteractiveCommand = require '../views/azk-interactive-view'
InstancesCommand = require '../views/azk-instances-view'

Azk          = require '../azk'
notifier = require '../notifier'

dataCleaner = (data) ->
  data = data.replace(/(\[[0-9]+m)/gm, '').trim().split("\n")
  data.shift()

  clean_data = []
  i = 0
  len = data.length
  while i < len
    # TODO: Caractere Bizarro aqui!
    regex = new RegExp('([^0-9a-z\-\:\/\.]+)', 'g')
    line = data[i].replace(regex, ' ').trim()
    clean_data.push(line.split(" "))
    i++

  return clean_data

module.exports.interactive = ->
  new InteractiveCommand(AzkCommands)

module.exports.command = (command) ->
  Azk.cmd(['status', '--text', '--short', '--quiet'])
    .then (data) ->
      data = dataCleaner(data)
      getCommands = ->
        commands = []
        i = 0
        len = data.length
        while i < len
          instance = data[i][0]
          url = data[i][2]
          commands.push [
            'azk-manager:' + command + ":" + instance,
            instance,
            command,
            instance,
            url
          ]
          i++

          return commands
      new InstancesCommand(getCommands)
    .catch (data) ->
      console.log(data)
