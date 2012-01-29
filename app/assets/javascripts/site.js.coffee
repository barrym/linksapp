# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(
    () ->
        $('a.popup').click (e) ->
            url = $(@).attr('href')
            window.open(url, "Share", "menubar=no,toolbar=no,width=430,height=360")
            return false

)
