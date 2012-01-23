$('#likers').html '<%= escape_javascript(render(:partial => 'links/likers', :locals => {:link => @link})) %>'
