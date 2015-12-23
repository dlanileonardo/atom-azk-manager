_ = require 'underscore-plus'
{$, $$, SelectListView} = require 'atom-space-pen-views'

fuzzy = require('../models/fuzzy').filter
AzkMenuView  = require '../views/azk-menu-view'

module.exports =
class InteractiveCommand extends AzkMenuView

  initialize: (commands) ->
    @commands = commands
    super
    @addClass('azk-interactive-commands')

  run = () ->
    @runner.run(command)

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)

    @storeFocusedElement()

    if @previouslyFocusedElement[0] and @previouslyFocusedElement[0] isnt document.body
      @commandElement = @previouslyFocusedElement
    else
      @commandElement = atom.views.getView(atom.workspace)
    @keyBindings = atom.keymaps.findKeyBindings(target: @commandElement[0])

    commands = @commands().map (c) -> { name: c[0], description: c[1], func: c[2] }
    commands = _.sortBy(commands, 'name')
    @setItems(commands)
    @panel.show()
    @focusFilterEditor()

  confirmed: ({func}) ->
    @cancel()
    func()
