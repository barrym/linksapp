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
    if stale?(:last_modified => @link.updated_at.utc, :etag => [@link, current_user])
      respond_with @link
    end
  end

  def index
    @links = Link.order('updated_at desc').includes(:source, :user)
    @total_links = Link.count
    #TODO: move this shit to somewhere else, how does this affect etags?
    @random_video_link = Link.where(:is_video => true).first(:offset => rand(Link.where(:is_video => true).count))
    @random_image_link = Link.where(:is_image => true).first(:offset => rand(Link.where(:is_image => true).count))
    logger.info @links.first.updated_at.utc
    if stale?(:last_modified => @links.first.updated_at.utc, :etag => [@links.first, current_user])
      logger.info "stale"
      respond_with @links
    end
  end

end
