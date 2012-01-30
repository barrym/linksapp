$('#comments').html '<%= escape_javascript(render(@link.comments)) %>'
$('#new-comment-form').html '<%= escape_javascript(render(:partial => "comments/new", :locals => {:link => @link})) %>'
