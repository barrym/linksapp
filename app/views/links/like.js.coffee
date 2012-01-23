<%- if @liked %>
$('a#like').html("Liked")
<% else %>
$('a#like').html("Like it")
<% end %>

$('a#like').toggleClass('success')
