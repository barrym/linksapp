class LinksController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html, :js

  def add
    link = Link.find_by_url(params[:url])
    if link
      flash[:notice] = "This link has already been shared, a like has been added for you to the original post."
      redirect_to link_path(link)
    else
      link = current_user.links.build(:url => params[:url], :title => params[:title], :type => 'website')
      link.save!
      redirect_to link_path(link)
      # render :text => "#{params[:title]} - #{uri.host} - #{uri.to_s}"
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def index
    @links = Link.order('updated_at desc')
  end

  def like
    @link = Link.find(params[:id])
    if @link.liked_by?(current_user)
      @link.likers.delete(current_user)
    else
      @link.likers << current_user
    end
    respond_with(@link.reload)
  end

end
