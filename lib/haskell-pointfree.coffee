module.exports = HaskellPointfree =
  config:
    pointfreePath:
      type: 'string'
      default: 'pointfree.js'
      description: 'Path to pointfree executable'
    pointfulPath:
      type: 'string'
      default: 'pointful.js'
      description: 'Path to pointful executable'

  activate: ->
    {CompositeDisposable} = require 'atom'

    @subscriptions = new CompositeDisposable
    HaskellPointfreeView = null
    view = null
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor[data-grammar~="haskell"]',
      'haskell-pointfree:toggle': ({currentTarget}) ->
        HaskellPointfreeView ?= require './haskell-pointfree-view'
        view ?= new HaskellPointfreeView
        view.toggle(currentTarget.getModel())
  deactivate: ->
    @subscriptions.dispose()
    @subscriptions = null
