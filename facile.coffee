facile = (template, data, domModule) ->
  @$ = domModule || @$
  $template = $('<div />').append($(template))
  startProcessing($template, data)

facile.update = startProcessing = ($template, data) ->
  for key, value of data
    bindOrRemove($template, key, value)
  $template.html()

if module?.exports
  fs = require 'fs'
  facile.$ = require 'cheerio'
  _templateCache = {}

  _render = (template, locals, cb) ->
    try
      html = facile template, locals, facile.$
      cb null, html
    catch e
      cb e

  facile.__express = (path, options, callback) ->
    if 'production' == options.settings.env
      if _templateCache[path]
        _render _templateCache[path], options, callback
      else
        fs.readFile path, (err, data) ->
          if err then return callback err
          _templateCache[path] = data.toString()
          _render _templateCache[path], options, callback
    else
      fs.readFile path, (err, data) ->
        if err then return callback err
        _render data.toString(), options, callback

  facile.clearCache = ->
    _templateCache = {}

find = ($el, key) ->
  $result = $el.find('#' + key)
  $result = $el.find('.' + key) if $result.length == 0
  $result

bindOrRemove = ($template, key, value) ->
  if value?
    bindData($template, key, value)
  else
    $el = find($template, key)
    $el.remove()

bindData = ($template, key, value) ->
  if value.constructor == Array
    bindArray($template, key, value)
  else if value.constructor == Object
    $target = find($template, key)
    bindObject($target, key, value)
  else
    bindValue($template, key, value)

bindArray = ($template, key, value) ->
  $root = find($template, key)
  return if $root.length == 0

  $nested = find($root, key)
  if $nested.length > 0
    $root = $nested

  if tagName($root) == "TABLE"
    $root = $root.find('tbody')

  $child = $root.children().remove()
  for arrayValue in value
    $clone = $child.clone()
    if arrayValue.constructor == Object
      newHtml = facile($clone, arrayValue)
      $root.append(newHtml)
    else
      $clone.html(arrayValue)
      $root.before($clone)

bindObject = ($template, key, value) ->
  if value.content?
    bindAttributeObject($template, key, value)
  else
    bindNestedObject($template, key, value)

tagName = ($el) ->
  if $el.prop
    $el.prop "tagName"
  else
    $el[0].name.toUpperCase()

bindValue = ($template, key, value) ->
  if key.indexOf('@') != -1
    [key, attr] = key.split('@')
    $el = find($template, key)
    if tagName($el) == 'SELECT'
      $el.find("option[value='#{value}']").attr('selected', 'selected')
    else
      setAttributeValue($el, attr, value)
  else
    $el = find($template, key)
    if $el.length > 0
      if tagName($el) == 'INPUT' && $el.attr('type') == 'checkbox' && value
        $el.attr('checked', "checked")
      else if tagName($el) == 'INPUT' || tagName($el) == 'OPTION'
        $el.attr('value', '' + value)
      else if tagName($el) == 'SELECT' && value.constructor != Object
        $el.find("option[value='#{value}']").attr('selected', 'selected')
      else
        $el.html('' + value)

bindNestedObject = ($template, key, value) ->
  for attr, attrValue of value
    bindOrRemove($template, attr, attrValue)

bindAttributeObject = ($template, key, value) ->
  $template.html(value.content)
  for attr, attrValue of value when attr != 'content'
    setAttributeValue($template, attr, attrValue)

setAttributeValue = ($el, attr, value) ->
  return $el.addClass(value) if attr == 'class'

  $el.attr(attr, value)

window?.facile = facile
module?.exports = facile

