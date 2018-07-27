require 'typhoeus'
require 'json'
require 'csv'


class ImportsController < ApplicationController
  #before_action :set_import, only: [:show, :edit, :update, :destroy]

  # GET /imports
  # GET /imports.json
  def index
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
  end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # GET /imports/1/edit
  def edit
  end

  # POST /imports
  # POST /imports.json
  def create
    
    canvas_url = ''
    canvas_token = ''
    
    @import = Import.new(import_params)

    if @import.valid?
      find_user = Typhoeus::Request.new(
        "#{canvas_url}/api/v1/accounts/self/users",
        method: :get,
        headers: { authorization: "Bearer #{canvas_token}"},
        params: {
          "search_term" => @import.name
        }
        )  
  
        find_user.on_complete do |response|
          if response.code == 200
            redirect_to @import, notice: JSON.parse(response.body)
          else
            render html: response.code #@import.errors, status: :unprocessable_entity
          end
            #We use '.first' simply because the array only has a length of 1 (ie. The search should only return one user, hopefully.)
          end        
        end
      find_user.run #Find me that user and get that SIS ID.    
    
  end
  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
        format.json { render :show, status: :ok, location: @import }
      else
        format.html { render :edit }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url, notice: 'Import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  #  def set_import
  #    @import = Import.find(params[:id])
  #  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.require(:import).permit(:name)
    end
end
