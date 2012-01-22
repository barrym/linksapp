class SourcesController < ApplicationController

  before_filter :authenticate_user!

  def index
    @sources = Source.all
  end

  def show
    @source = Source.find(params[:id])
  end

end
