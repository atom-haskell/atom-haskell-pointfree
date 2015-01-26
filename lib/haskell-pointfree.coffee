{CompositeDisposable} = require 'atom'
CP = require 'child_process'
# _ = require 'underscore-plus'
{SelectListView, $, $$} = require 'atom-space-pen-views'

module.exports =
class HaskellPointfreeView extends SelectListView
  @config:
    pointfreePath:
      type: 'string'
      default: 'pointfree'
      description: 'Path to pointfree executable'
    pointfulPath:
      type: 'string'
      default: 'pointful'
      description: 'Path to pointful executable'

  @activate: ->
    @subscriptions = new CompositeDisposable
    view = new HaskellPointfreeView
    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-text-editor',
      'haskell-pointfree:toggle': ->
        view.toggle(event.target.getModel())
  @deactivate: ->
    @subscriptions.dispose()

  runCmd: (path,text,title) ->
    new Promise (resolve) ->
      CP.execFile path, [text], {}, (error,data) ->
        unless error
          resolve
            text: data.trim()
            title: title

  initialize: ->
    super

    @addClass('haskell-pointfree')

  cancelled: -> @hide()

  toggle: (editor) ->
    if @panel?.isVisible()
      @cancel()
    else
      @show(editor)

  getFilterKey: ->
    "text"

  show: (editor) ->
    pfree=atom.config.get('haskell-pointfree.pointfreePath')
    pful=atom.config.get('haskell-pointfree.pointfulPath')
    range = editor.getSelectedBufferRange()
    text=editor.getTextInBufferRange(range)
    p=Promise.all [
      @runCmd(pfree,text,"Pointfree"),
      @runCmd(pful,text,"Pointful")]
    p.then (list) =>
      list.forEach (item) ->
        item.range=range
        item.editor=editor
      @setItems(list)
      @panel ?= atom.workspace.addModalPanel(item: this)
      @panel.show()
      @storeFocusedElement()
      @focusFilterEditor()

  hide: ->
    @panel?.hide()

  viewForItem: ({title,text}) ->
    "<li>#{title}: #{text}</li>"

  confirmed: ({text,range,editor}) ->
    @cancel()
    editor.setTextInBufferRange range, text
