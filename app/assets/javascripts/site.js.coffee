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

        $(document).on 'ajax:beforeSend', '#new-comment-form', () ->
            $('#comment-body-textarea').attr('disabled','disabled')
            $('#comment-submit').attr('disabled', 'disabled')
            $('#comment-submit').val('Posting...')

        $(document).on 'ajax:beforeSend', 'a#like', () ->
            $('a#like').attr('disabled', 'disabled')

        $(document).on 'click', '#comment-body-textarea', () ->
            if $('#comment-submit').is(':hidden')
                $('#comment-submit').show('blind')

        $('.bookmarklet').on 'click', () ->
            if $('#bookmarklet-help').is(':hidden')
                $('#bookmarklet-help').show('blind')
            return false

        # $('a.pjax').pjax('#main')

        $('.bookmarklet').tooltip({placement:'top', title:'Drag me'})

        $('#bookmarklet-help #dont-click').on 'click', () ->
            $('body').hide 'bounce', {}, "slow", () ->
                $('.navbar').hide()
                $('.content').html("<div style='margin:0 auto;float:left;'><iframe width=\"640\" height=\"480\" src=\"http://www.youtube.com/embed/Nc9xq-TVyHI?autoplay=1\" frameborder=\"0\" allowfullscreen></iframe></p><h1 id='message' style='display:none;'>Bet you wish you knew this dog.</h1></div>")
                $('body').show('blind')
                setTimeout(
                    () ->
                        $('#message').show('blind')
                    , 30000)
            return false

        $('#avatar_type').on 'click', () ->
            if $('#avatar').is(':hidden')
                $('#avatar').show()
                $('#avatar_url').hide()
                $('#avatar_type').html('use URL')
            else
                $('#avatar').hide()
                $('#avatar_url').show()
                $('#avatar_type').html('upload a file')
            return false


)
