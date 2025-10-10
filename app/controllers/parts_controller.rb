class PartsController < ApplicationController
  before_action :set_part, only: %i[show edit update]
  before_action :require_admin!, only: %i[create update]

  def index
    @parts = Part.order(:part_number)
    render :index, status: :ok
  end

  def show
    render :show, status: :ok
  end

  def create
    @part = Part.new(part_params)
    if @part.save
      redirect_to parts_path, notice: "Part created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @part.update(part_params)
      redirect_to part_path(@part), notice: "Part updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_part
    @part = Part.find(params[:id])
  end

  def part_params
    params.require(:part).permit(:part_number, :name, :is_active, :price, :uom_id, :category, :description, :lead_time)
  end

  def require_admin!
    unless current_user&.admin?
      render plain: "forbidden", status: :forbidden
    end
  end
end

