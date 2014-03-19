{$} = require 'atom'

module.exports =
  configDefaults:
    x: 0
    y: 0
    width: 0
    height: 0
    treeWidth: 0

  activate: (state) ->
    setWindowDimensions()
    $(window).on 'resize beforeunload', -> saveWindowDimensions()

setWindowDimensions = ->
  {x, y, width, height, treeWidth} = atom.config.get('remember-window')

  if x is 0 and y is 0 and width is 0 and height is 0 and treeWidth is 0
    saveWindowDimensions()
  else
    $('.tree-view-resizer').width(treeWidth)
    atom.setWindowDimensions
      'x': x
      'y': y
      'width': width
      'height': height

saveWindowDimensions = ->
  {x, y, width, height} = atom.getWindowDimensions()
  treeWidth = $('.tree-view-resizer').width()

  atom.config.set('remember-window.x', x)
  atom.config.set('remember-window.y', y)
  atom.config.set('remember-window.width', width)
  atom.config.set('remember-window.height', height)
  atom.config.set('remember-window.treeWidth', treeWidth)
