{CompositeDisposable} = require 'atom'
HaskellPointfreeView = require './haskell-pointfree-view'

module.exports = HaskellPointfree =
  config:
    pointfreePath:
      type: 'string'
      default: 'pointfree'
      description: 'Path to pointfree executable'
    pointfulPath:
      type: 'string'
      default: 'pointful'
      description: 'Path to pointful executable'

  activate: ->
    @subscriptions = new CompositeDisposable
    view = new HaskellPointfreeView
    # Register command that toggles this view
    @subscriptions.add atom.commands.add(
      'atom-text-editor[data-grammar~="haskell"]',
      'haskell-pointfree:toggle': ->
        view.toggle(event.target.getModel())
      )
  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
