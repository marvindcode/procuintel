class InventoriesController < ApplicationController
  include Pundit::Authorization  
  before_action :authenticate_user!  
  before_action :set_inventory, only: [:show, :edit, :update, :destroy]

  # def index
  #   @inventories = policy_scope(Inventory)
  #   if params[:search]
  #     @inventories = @inventories.where("quantity >= ?", params[:search].to_i)  
  #   end
  #   authorize Inventory
  # end

  def index
  scope = params[:low_stock].present? ? Inventory.low_stock : Inventory.all
  @inventories = scope.includes(:part, :warehouse).order(:warehouse_id, :part_id)
  end

  def show
    authorize @inventory
  end

  def new
    @inventory = Inventory.new
    authorize @inventory
  end

  def create
    @inventory = Inventory.new(inventory_params)
    authorize @inventory
    respond_to do |format|
      if @inventory.save
        format.html { redirect_to @inventory, notice: 'Inventory created.' }
        format.json { render :show, status: :created, location: @inventory }
      else
        puts "Create errors: #{@inventory.errors.full_messages.join(', ')}"  
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @inventory
  end

  def update
    authorize @inventory
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to @inventory, notice: 'Inventory updated.' }  # 3xx for spec
        format.json { render :show, status: :ok }
      else
        puts "Update errors: #{@inventory.errors.full_messages.join(', ')}"  # Temp debug
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @inventory
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to inventories_url, notice: 'Inventory destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(:warehouse_id, :part_id, :quantity, :safe_inventory, :uom_id, :unit_of_measure)

  end
end