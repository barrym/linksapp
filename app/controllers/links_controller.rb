class LinksController < ApplicationController

  def add
    uri = URI.parse(params[:url])
    link = Link.find_by_url(uri.to_s)
    if link
      flash[:notice] = "This link has already been shared"
      redirect_to link_path(link)
    else
      link = current_user.links.build(
        :url   => uri.to_s,
        :title => params[:title],
        :type  => "website"
      )
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

end
