{BufferedProcess, BufferedNodeProcess} = require 'atom'
{SelectListView} = require 'atom-space-pen-views'

module.exports=
class HaskellPointfreeView extends SelectListView
  runCmd: (cmd,text,title) ->
    lines = []
    if cmd in ['pointfree.js', 'pointful.js']
      {sep} = require 'path'
      cmd = "#{__dirname}#{sep}..#{sep}bin#{sep}#{cmd}"
      BP = BufferedNodeProcess
    else
      BP = BufferedProcess
    new Promise (resolve) ->
      new BP
        command: cmd
        args: [text]
        stdout: (line) ->
          lines.push line.slice(0,-1)
        exit: -> resolve
          text: lines.join '\n'
          title: title

  initialize: ->
    super
    @panel = atom.workspace.addModalPanel
      item: this
      visible: false
    @addClass 'haskell-pointfree'

  cancelled: -> @hide()

  toggle: (editor) ->
    if @panel?.isVisible()
      @cancel()
    else
      @show editor

  getFilterKey: ->
    "text"

  show: (editor) ->
    pfree=atom.config.get 'haskell-pointfree.pointfreePath'
    pful=atom.config.get 'haskell-pointfree.pointfulPath'
    range = editor.getSelectedBufferRange()
    if range.isEmpty()
      range = editor.bufferRangeForBufferRow range.start.row
    text=editor.getTextInBufferRange range
    leadingSpaces = text.match(/^[ \t]*/)?[0] ? ""
    Promise.all [
      @runCmd(pfree,text,"Pointfree"),
      @runCmd(pful,text,"Pointful")]
    .then (list) =>
      @setItems list.map ({text,title}) ->
        {range, editor, title, text: leadingSpaces+text}
      @panel.show()
      @storeFocusedElement()
      @focusFilterEditor()

  hide: ->
    @panel?.hide()

  viewForItem: ({title,text}) ->
    "<li>#{title}: <span>#{text}</span></li>"

  confirmed: ({text,range,editor}) ->
    @cancel()
    editor.setTextInBufferRange range, text
