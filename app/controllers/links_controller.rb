class LinksController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html, :json, :js

  def add
    if !params[:url]
    else
      link = Link.find_by_url(params[:url])
      if link
        flash[:notice] = "This link has already been shared, a like has been added for you to the original post. THIS DOES NOT WORK."
        redirect_to link_path(link)
      else
        link = current_user.links.build(:url => params[:url], :title => params[:title], :type => 'website')
        link.save!
        redirect_to link_path(link)
      end
    end
  end

  def show
    @link = Link.find(params[:id])
    respond_with @link
  end

  def index
    # @links = Link.by_day
    @links = Link.order('updated_at desc').includes(:source, :user)
    respond_with @links
  end

end
