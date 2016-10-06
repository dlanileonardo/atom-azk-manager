_ = require 'underscore-plus'
{$, $$, SelectListView} = require 'atom-space-pen-views'

fuzzy = require('../models/fuzzy').filter
AzkMenuView  = require '../views/azk-menu-view'
ExecuteCommand = require '../models/execute-command'

module.exports =
class InstancesCommand extends AzkMenuView

  initialize: (commands) ->
    @commands = commands
    @addClass('azk-interactive-commands')
    super

  run = () ->
    @runner.run(@command)

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)

    @storeFocusedElement()

    check = @previouslyFocusedElement[0] and @previouslyFocusedElement[0]
    if check isnt document.body
      @commandElement = @previouslyFocusedElement
    else
      @commandElement = atom.views.getView(atom.workspace)
    @keyBindings = atom.keymaps.findKeyBindings(target: @commandElement[0])

    commands = @commands().map (c) -> {
      name: c[0],
      description: c[1],
      command: c[2],
      instance: c[3],
      url: c[4]
    }
    commands = _.sortBy(commands, 'name')
    @setItems(commands)
    @panel.show()
    @focusFilterEditor()

  viewForItem: ({name, url}) ->
    $$ ->
      @li name, =>
        @div class: 'pull-right', =>
          @span(url)

  confirmed: ({name, command, instance}) ->
    @cancel()
    ExecuteCommand.executeCommand(command, instance)
