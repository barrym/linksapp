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
    # if stale?(:last_modified => @link.updated_at.utc, :etag => [@link, current_user])
      respond_with @link
    # end
  end

  def index
    # @index_cache_key = ["links", "all", Link.most_recently_updated]
    @links = Link.order('updated_at desc').page(params[:page]).per(20)

    # logger.info @links.first.updated_at.utc
    # if stale?(:last_modified => @links.first.updated_at.utc, :etag => [@links.first, current_user])
      logger.info "stale"
      respond_with @links
    # end
  end

end
