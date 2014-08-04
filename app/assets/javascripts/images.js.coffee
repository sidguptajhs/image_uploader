# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
root = exports ? this
root.sendImage = (name) ->
  i = 0
  loop
    curImg = document.getElementById("button"+i)
    curUpload = document.getElementById("upload"+i)
    if curImg isnt null
      curImg.setAttribute "class", ""
      curUpload.setAttribute "class", "btn btn-default"
      curUpload.setAttribute "value", "Select for Upload"
    else
      break
    i++
  currentImage = document.getElementById("button"+name)
  currentImage.setAttribute "class", "btn btn-default"
  upload = document.getElementById("upload"+name)
  upload.setAttribute "class", "btn btn-success"
  upload.setAttribute "value", "Set for Upload"
  document.getElementById("image_source").value = currentImage.getAttribute("src")
  return
startCamera = ->
  window.URL or (window.URL = window.webkitURL or window.msURL or window.oURL)
  navigator.getUserMedia or (navigator.getUserMedia = navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia)
  optionStyle = ((win) ->
    return  unless navigator.getUserMedia
    el = document.createElement("iframe")
    root = document.body or document.documentElement
    string = true
    object = true
    nop = ->

    root.appendChild el
    f = win.frames[win.frames.length - 1]
    f.navigator.getUserMedia or (f.navigator.getUserMedia = f.navigator.webkitGetUserMedia or f.navigator.mozGetuserMedia or f.navigator.msGetUserMedia)
    try
      f.navigator.getUserMedia
        video: true
      , nop
    catch e
      object = false
      try #try it with old spec string syntax
        f.navigator.getUserMedia "video", nop
      catch e #neither is supported
        string = false
    finally
      #clean up
      root.removeChild el
      el = null
    string: string
    object: object
  )(window)
  norm = (opts) -> # has to be {video: false, audio: true}. caveat emptor.
    stringOptions = []
    if optionStyle.string and not optionStyle.object
      for o of opts
        stringOptions.push o  if opts[o] is true
      stringOptions.join " "
    else
      opts

  errback = ->
    alert "Not found get user media!!"
    return

  video = document.getElementById("video")
  localMediaStream = null
  vgaConstraints = video:
    mandatory:
      maxWidth: 640
      maxHeight: 480

  if navigator.getUserMedia
    navigator.getUserMedia norm(vgaConstraints), ((stream) ->
      video.src = (if (window.URL and window.URL.createObjectURL) then window.URL.createObjectURL(stream) else stream)
      localMediaStream = stream
      return
    ), errback
  return
(->
  "use strict"
  video = undefined
  $output = undefined
  scale = 1
  count = 0
  initialize = ->
    $output = $("#output")
    video = $("#video").get(0)
    $("#capture").click captureImage
    return

  captureImage = ->
    canvas = document.createElement("canvas")
    div=document.createElement("div")
    div.setAttribute "style", "margin-top: 5px;"
    div.setAttribute "id", "div_button" + count
    canvas.width = video.videoWidth * scale
    canvas.height = video.videoHeight * scale
    canvas.getContext("2d").drawImage video, 0, 0, canvas.width, canvas.height
    upload = document.createElement("input")
    img = document.createElement("img")
    img.src = canvas.toDataURL()
    img.setAttribute "id", "button" + count
    img.setAttribute "style", "margin-left: 20px;"
    img.setAttribute "width", "320px"
    img.setAttribute "width", "240px"
    upload.setAttribute "type", "button"
    upload.setAttribute "value", "Select for Upload"
    upload.setAttribute "id", "upload" + count
    upload.setAttribute "class", "btn btn-default"
    upload.setAttribute "style", "margin-left: 20px;"
    upload.setAttribute "onclick", "sendImage(\""  + count + "\");"
    $output.prepend div
    document.getElementById("div_button"+count).appendChild(img)
    document.getElementById("div_button"+count).appendChild(upload)
    count++
    return

  $ initialize
  return
)()

root.submitForm = ->
  name = document.getElementById("image_username")
  img = document.getElementById("image_source")
  if img.length is 0 or not name.value? or name.value.length is 0
    alert "Please put in a name and an image"
  else
    document.forms["new_image"].submit()
  return

$(document).ready(startCamera)
$(document).on('page:load', ready)