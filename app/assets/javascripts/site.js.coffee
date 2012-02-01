# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(
    () ->
        $('a.popup').click () ->
            url = $(@).attr('href')
            window.open(url, "Share", "menubar=no,toolbar=no,width=430,height=360")
            return false

        $('#new-comment-form').submit () ->
            if $.trim($('#comment-body-textarea').val()) == ''
                if $('#new-comment-form #errors').is(':hidden')
                    $('#new-comment-form #errors').html("<strong>Oops!</strong> You can't submit blank comments.")
                    $('#new-comment-form #errors').toggleClass('alert alert-error')
                    $('#new-comment-form #errors').show()
                return false

        $('#new-comment-form').bind 'ajax:beforeSend', () ->
            $('#comment-body-textarea').attr('disabled','disabled')
            $('#comment-submit').attr('disabled', 'disabled')
            $('#comment-submit').val('Posting...')

        $('#comment-body-textarea').live 'click', () ->
            if $('#comment-submit').is(':hidden')
                $('#comment-submit').show('blind')


)
