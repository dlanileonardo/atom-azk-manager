{CompositeDisposable, Emitter} = require 'atom'
CommandRunner = require './run-command/command-runner'
CommandOutputView = require './run-command/command-output-view'
AzkMenuView = require './views/azk-menu-view'
Interactive = require './models/interactive'
Utils = require './run-command/utils'
AzkAgentStatus = require './views/azk-agent-status'

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
    @emitter = new Emitter()

    # Register command that toggles this view
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:menu': => new AzkMenuView()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:agent-start': => @agentStart()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:agent-stop': => @agentStop()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:agent-status': => @agentStop()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:init': => @init()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:status': => @status()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:start': => @start()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:stop': => @stop()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:interactive': => Interactive.interactive()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:logs': => @followLogs()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:logs-follow': => @followLogs(true)
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:open': => @open()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:toggle-panel': => @togglePanel()
    @subscriptions = atom.commands.add 'atom-workspace', 'azk-manager:kill-last-command': => @killLastCommand()

  consumeStatusBar: (statusBar) ->
    @AzkAgentStatus = new AzkAgentStatus()
    @AzkAgentStatus.initialize()
    @statusBarTile = statusBar.addRightTile(item: @AzkAgentStatus, priority: 50)


  provideStatusBar: ->
    addLeftTile: @statusBar.addLeftTile.bind(@statusBar)
    addRightTile: @statusBar.addRightTile.bind(@statusBar)
    getLeftTiles: @statusBar.getLeftTiles.bind(@statusBar)
    getRightTiles: @statusBar.getRightTiles.bind(@statusBar)

  deactivate: ->
    @runCommandView.destroy()
    Utils.commandOutputView.destroy()

    @statusBarPanel?.destroy()
    @statusBarPanel = null

    @statusBar?.destroy()
    @statusBar = null

  dispose: ->
    @subscriptions.dispose()

  agentStatus: ->
    @run("azk agent status")
      .then (data) =>
        @AzkAgentStatus.update()


  agentStart: ->
    @run("azk agent start")
      .then (data) =>
        @AzkAgentStatus.update()

  agentStop: ->
    @run("azk agent stop")
      .then (data) =>
        @AzkAgentStatus.update()

  status: ->
    @run("azk status")

  start: ->
    @run("azk start")

  stop: ->
    @run("azk stop")

  init: ->
    @run("azk init")

  followLogs: (follow) ->
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
