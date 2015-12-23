{CompositeDisposable} = require 'atom'
CommandRunner = require './run-command/command-runner'
CommandOutputView = require './run-command/command-output-view'
AzkMenuView = require './views/azk-menu-view'
Interactive = require './models/interactive'
Utils = require './run-command/utils'

module.exports = AzkManager =
  config:
    shellCommand:
      type: 'string'
      default: '/bin/bash'
    useLoginShell:
      type: 'boolean'
      default: true

  activate: (state) ->
    Utils.runner = new CommandRunner()
    Utils.commandOutputView = new CommandOutputView(Utils.runner)

    # Register command that toggles this view
    @subscriptions = atom.commands.add 'atom-workspace',
      'azk-manager:menu', -> new AzkMenuView()

      'azk-manager:agent-start': => @agentStart()
      'azk-manager:agent-stop': => @agentStop()

      'azk-manager:init', -> @init()

      'azk-manager:status' : => @status()
      'azk-manager:start' : => @start()
      'azk-manager:stop': => @stop()

      'azk-manager:interactive': => Interactive.interactive()

      'azk-manager:logs', -> @logs()
      'azk-manager:logs-follow', -> @logs(true)
      'azk-manager:open', -> @open()

      'azk-manager:toggle-panel': => @togglePanel()
      'azk-manager:kill-last-command': => @killLastCommand()

  deactivate: ->
    @runCommandView.destroy()
    Utils.commandOutputView.destroy()

  dispose: ->
    @subscriptions.dispose()

  agentStart: ->
    @run("azk agent start")

  agentStop: ->
    @run("azk agent stop")

  status: ->
    @run("azk status")

  start: ->
    @run("azk start")

  stop: ->
    @run("azk stop")

  init: ->
    @run("azk init")

  logs: (follow) ->
    if (follow)
      @run("azk logs --follow")
    else
      @run("azk logs")

  open: ->
    @run("azk open")

  run: (command) ->
    Utils.runner.run(command)

  togglePanel: ->
    if Utils.commandOutputView.isVisible()
      Utils.commandOutputView.hide()
    else
      Utils.commandOutputView.show()

  killLastCommand: ->
    Utils.runner.kill()
