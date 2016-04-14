{CompositeDisposable, Emitter} = require "atom"
utils = require('util')
AzkManager = require "../azk-manager"
EventEmitter = require('events').EventEmitter

Azk = require '../azk'
# utils.inherits(AzkManager, EventEmitter)

class AzkStatus extends HTMLElement
  initialize: ->
    @classList.add('azk-agent-status')

    @createAgentArea()
    @createInstanceArea()
    @update()
    @emitter = new Emitter()
    @emitter.on 'azk-agent-status:changed', ->
      alert("azk-agent-status:changed")
      @update

  createAgentArea: ->
    @AgentArea = document.createElement('div')
    @AgentArea.classList.add('azk-agent', 'inline-block')
    @appendChild(@AgentArea)

    @AgentLabel = document.createElement('span')
    @AgentLabel.classList.add('azk-agent-label')
    @AgentArea.appendChild(@AgentLabel)

  createInstanceArea: ->
    @instanceArea = document.createElement('div')
    @instanceArea.classList.add('azk-instance', 'inline-block')
    @appendChild(@instanceArea)

    @instanceLabel = document.createElement('span')
    @instanceLabel.classList.add('azk-instance-label')
    @instanceArea.appendChild(@instanceLabel)

  destroy: ->

  # handleClick: ->
  #   clickHandler = => atom.commands.dispatch(
  # atom.views.getView(@getActiveTextEditor()), 'go-to-line:toggle')
  #   @addEventListener('click', clickHandler)
  #   @clickSubscription = new Disposable => @removeEventListener(
  # 'click', clickHandler)

  update: ->
    @updateAgentText()
    # @updateInstanceText()

  updateAgentText: () ->
    Azk.cmd(['agent', 'status'])
      .then (data) =>
        @AgentLabel.classList.remove('red')
        @AgentLabel.classList.add('green')
      .catch (data) =>
        @AgentLabel.classList.remove('green')
        @AgentLabel.classList.add('red')
    @AgentLabel.textContent = 'Azk Agent'

  updateInstanceText: () ->
    # @instanceArea.style.display = 'none'
    @instanceLabel.textContent = 'Instance'
    # @instanceArea.style.display = '' if 'huashuahs'

module.exports = document.registerElement(
  'status-bar-azk', prototype: AzkStatus.prototype, extends: 'div'
)
