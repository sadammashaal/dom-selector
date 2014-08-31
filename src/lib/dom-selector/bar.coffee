$ = require('./dom-utils')
BarItem = require('./bar-item')
BarRenderer = require('./renderers/bar')
Selection = require('./selection')

module.exports = class Bar
  constructor: (@selectionMode, @selection) ->
    @barItemSelection = new Selection('dom-selector__elem--selected')
    @renderer = new BarRenderer(@okHandler, @cancelHandler)
    @visible = false
    @_resetArrays()

  show: ->
    @renderer.show()
    @visible = true

  hide: ->
    @renderer.hide()
    @visible = false

  update: ->
    @selectedBarElem?.unselect()
    if @selection.selected
      @_select()
    else
      @_unselect()

  holdsElement: (el) ->
    @renderer.holdsElement(el)

  _reset: ->
    @tip = @selection.selected
    @_resetArrays()
    @_generateList(@selection.selected)
    @renderer.reset(@barElems)

  _select: ->
    @renderer.enableOkControl()
    if (@selectedBarElem = @_barElemIfShownAlready())
      @selectedBarElem.select()
    else
      @_reset()

  _unselect: ->
    @selectedBarElem = null
    @renderer.disableOkControl()

  _barElemIfShownAlready: ->
    idx = $.inArray(@selection.selected, @referencedElems)
    if idx >= 0 then @barElems[idx] else null

  cancelHandler: =>
    @selectionMode.stop()

  okHandler: =>
    @selectionMode.stop()
    @successCallback?(@selection.selected)

  _generateList: (el) ->
    if el.parentElement && el.nodeName.toLowerCase() != 'body'
      @_generateList(el.parentNode)
    barItem = new BarItem(el, this, @selection, @barItemSelection)
    barItem.select() if @selection.selected == el
    @referencedElems.push(el)
    @barElems.push(barItem)
    @selectedBarElem = barItem

  _resetArrays: ->
    @referencedElems = []
    @barElems = []

