class CommentsController < ApplicationController

  respond_to :js

  def create
    logger.info params.inspect
    @link = Link.find(params[:link_id])
    comment = @link.comments.build(params[:comment])
    comment.user = current_user
    # comment.save!
    @link.updated_at = Time.now
    @link.save!
    respond_with(@link.reload)
  end

end
