class CommentsController < ApplicationController

  respond_to :js

  def create
    @link = Link.find(params[:link_id])
    comment = @link.comments.build(params[:comment])
    comment.user = current_user
    comment.save!
    respond_with(@link.reload)
  end

end
