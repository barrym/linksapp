class LikesController < ApplicationController

  respond_to :js

  def create
    @link = Link.find(params[:link_id])
    if @link.liked_by?(current_user)
      @link.likers.delete(current_user)
    else
      @link.likers << current_user
      @link.update_attributes :updated_at => Time.now
    end
    respond_with(@link.reload)
  end

end
