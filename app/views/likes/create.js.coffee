$('a#like').toggleClass('btn-success')
$('a#like').removeAttr('disabled')
$('#likers').html '<%= escape_javascript(render(:partial => 'links/likers', :locals => {:link => @link})) %>'
