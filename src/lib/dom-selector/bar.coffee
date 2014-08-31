$ = require('./dom-utils')
BarItem = require('./bar-item')
BarRenderer = require('./renderers/bar')
Selection = require('./selection')

module.exports = class Bar
  constructor: (@selectionMode, @bodySelection) ->
    @barSelection = new Selection('dom-selector__elem--selected')
    @renderer = new BarRenderer(@ok, @cancel)
    @visible = false
    @_resetArrays()

  show: ->
    @renderer.show()
    @visible = true

  hide: ->
    @renderer.hide()
    @visible = false

  reset: (newTipEl) ->
    @tip = @selected = newTipEl
    @_resetArrays()
    @_generateList(newTipEl)
    @renderer.reset(@barElems)

  newSelectionFromBar: (bodyEl) ->
    @bodySelection.toggle(bodyEl)
    @newSelection(bodyEl)

  newSelection: (newEl) ->
    @selectedBarElem.unselect() if @selectedBarElem
    @renderer.enableOkControl() unless @selected
    if @selected == newEl
      @selected = @selectedBarElem = null
      @renderer.disableOkControl()
    else if (idx = $.inArray(newEl, @referencedElems)) >= 0
      @selectedBarElem = @barElems[idx]
      @selectedBarElem.select()
      @selected = newEl
    else
      @reset(newEl)

  cancel: =>
    @selectionMode.stop()

  ok: =>
    @selectionMode.stop()
    @successCallback?(@selected)

  holdsElement: (el) ->
    @renderer.holdsElement(el)

  _generateList: (el) ->
    if el.parentElement && el.nodeName.toLowerCase() != 'body'
      @_generateList(el.parentNode)
    barItem = new BarItem(el, this, @barSelection)
    barItem.select() if @selected == el
    @referencedElems.push(el)
    @barElems.push(barItem)
    @selectedBarElem = barItem

  _resetArrays: ->
    @referencedElems = []
    @barElems = []

