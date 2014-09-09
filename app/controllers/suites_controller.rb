class SuitesController < ApplicationController
  respond_to :json
  skip_before_filter  :verify_authenticity_token

  def index
    @suites = Suite.all
  end

  def show
    @suite = Suite.find params[:id]
  end
  
  def update
    @suite = Suite.find params[:id]
    @suite.name = params[:name]
    @suite.tests = params[:tests]
    if @suite.save()
      render "suites/show"
    else
      respond_with @suite
    end
  end
  
  def create
    @suite = Suite.new
    @suite.name = params[:name]
    @suite.tests = params[:tests]
    if @suite.save()
      render "suites/show"
    else
      respond_with @suite
    end
  end
  
  def destroy
    suite = Suite.find params[:id]
    suite.destroy()
    render json: {}
  end
  
end