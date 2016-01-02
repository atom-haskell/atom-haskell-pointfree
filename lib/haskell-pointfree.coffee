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
    {CompositeDisposable} = require 'atom'

    @subscriptions = new CompositeDisposable
    HaskellPointfreeView = null
    view = null
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor[data-grammar~="haskell"]',
      'haskell-pointfree:toggle': ({target}) ->
        HaskellPointfreeView ?= require './haskell-pointfree-view'
        view ?= new HaskellPointfreeView
        view.toggle(target.getModel())
  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
