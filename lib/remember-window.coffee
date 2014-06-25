{$} = require 'atom'
fs = require 'fs-plus'
path = require 'path'
season = require 'season'

module.exports =
  configDefaults:
    x: 0
    y: 0
    width: 0
    height: 0
    treeWidth: 0
    storeOutsideMainConfig: false

  activate: (state) ->
    setWindowDimensions()
    $(window).on 'resize beforeunload', -> saveWindowDimensions()

buildConfig = (x=0, y=0, width=0, height=0, treeWidth=0) ->
  {
    x: x
    y: y
    width: width
    height: height
    treeWidth: treeWidth
  }

storeOutsideMainConfig = ->
  atom.config.get('remember-window.storeOutsideMainConfig')

getConfig = ->
  if storeOutsideMainConfig()
    configPath = path.join(atom.getConfigDirPath(), 'remember-window.cson')
    if fs.existsSync(configPath)
      season.readFileSync(configPath)
    else
      buildConfig()
  else
    atom.config.get('remember-window')

setConfig = (config) ->
  if storeOutsideMainConfig()
    season.writeFileSync(path.join(atom.getConfigDirPath(), 'remember-window.cson'), config)
  else
    atom.config.set('remember-window', config)

setWindowDimensions = ->
  {x, y, width, height, treeWidth} = getConfig()

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
  config = buildConfig(x, y, width, height, treeWidth)
  setConfig(config)
