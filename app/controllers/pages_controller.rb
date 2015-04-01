# Copied from interventions_controller.rb
class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:index_admin, :show_admin, :new, :edit, :update, :destroy]
  before_action :set_page, only: [:show, :show_admin, :edit, :update, :destroy]

  # GET /interventions
  # GET /interventions.json
  def index
    @pages = Page.all
  end

  def index_admin
    @pages = Page.all
  end

  # GET /interventions/1
  # GET /interventions/1.json
  def show
  end

  def show_admin
  end

  # GET /interventions/new
  def new
    @page = Page.new
  end

  # GET /interventions/1/edit
  def edit
  end

  # POST /interventions
  # POST /interventions.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { render action: 'show_admin', notice: 'Page created.' }
        format.json { render action: 'show_admin', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interventions/1
  # PATCH/PUT /interventions/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { render action: 'show_admin', notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: 'Did not update -- see errors on page.' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /interventions/1
  # DELETE /interventions/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to index_admin_pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      if (params[:id])
        @page = Page.find(params[:id])
      else
        @page = Page.find_by name: params[:name]
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:name, :title, :body)
    end

    def authenticate_admin!
      redirect_to root_path unless (current_user && current_user.admin?)
    end

end

