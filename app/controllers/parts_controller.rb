class PartsController < ApplicationController
  before_action :authenticate_user!
  include Authorizable   

  def index
    @parts = Part.order(:part_number).page(params[:page]).per(25)
  end

  def show
    @part = Part.find(params[:id])
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(part_params)
    if @part.save
      redirect_to @part, notice: "Part created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @part = Part.find(params[:id])
  end

  def update
    @part = Part.find(params[:id])
    if @part.update(part_params)
      redirect_to @part, notice: "Part updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Part.find(params[:id]).destroy
    redirect_to parts_path, notice: "Part deleted."
  end

  private
  def part_params
    params.require(:part).permit(:part_number, :name, :category, :description, :price, :uom_id, :lead_time, :is_active)
  end
end