class InterventionsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index, :show]
  before_action :set_intervention, only: [:show, :show_admin, :edit, :update, :destroy]

  # GET /interventions
  # GET /interventions.json
  def index
    @interventions = Intervention.all
  end

  def index_admin
    @interventions = Intervention.all
  end

  # GET /interventions/1
  # GET /interventions/1.json
  def show
  end

  def show_admin
  end

  # GET /interventions/new
  def new
    @intervention = Intervention.new
  end

  # GET /interventions/1/edit
  def edit
  end

  # POST /interventions
  # POST /interventions.json
  def create
    @intervention = Intervention.new(intervention_params)
    set_name
    @intervention.safety_precautions.gsub!(/\> /,"+ ")

    respond_to do |format|
      if @intervention.save
        format.html { render action: 'show_admin', notice: 'Intervention/supplement created.' }
        format.json { render action: 'show_admin', status: :created, location: @intervention }
      else
        format.html { render action: 'new' }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interventions/1
  # PATCH/PUT /interventions/1.json
  def update
    set_name
    respond_to do |format|
      if @intervention.update(intervention_params)
        format.html { render action: 'show_admin', notice: 'Intervention/supplement updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: 'Did not update -- see errors on page.' }
        format.json { render json: @intervention.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interventions/1
  # DELETE /interventions/1.json
  def destroy
    @intervention.destroy
    respond_to do |format|
      format.html { redirect_to index_admin_interventions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intervention
      @intervention = Intervention.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def intervention_params
      params.require(:intervention).permit(:title, :abbrev, :benefit, :principle_id, :regimen, :alternate_options, :maintenance_dose, :safety_precautions, :image)
    end

    def set_name
      @intervention.name = @intervention.title.downcase.tr(" ", "_")
    end

end
