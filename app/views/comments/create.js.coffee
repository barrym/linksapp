$('#comment-body-textarea').val("")
$('#comments').html '<%= escape_javascript(render(@link.comments)) %>'
