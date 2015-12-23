{BufferedProcess} = require 'atom'
notifier = require './notifier'

module.exports = Azk =
  workingDirectory: ->
    editor = atom.workspace.getActiveTextEditor()
    activePath = editor?.getPath()
    relative = atom.project.relativizePath(activePath)
    if activePath?
      relative[0] || path.dirname(activePath)
    else
      atom.project.getPaths()?[0] || @homeDirectory()

  cmd: (args, options={ env: process.env, cwd: Azk.workingDirectory() }) ->
    new Promise (resolve, reject) ->
      output = ''
      try
        new BufferedProcess
          command: atom.config.get('azk-manager.azkPath') ? 'azk'
          args: args
          options: options
          stdout: (data) -> output += data.toString()
          stderr: (data) ->
            output += data.toString()
          exit: (code) ->
            if code is 0
              resolve output
            else
              reject output
      catch e
        notifier.addError 'Azk Manager is unable to locate the git command. Please ensure process.env.PATH can access azk.'
        reject "Couldn't find Azk"
