require 'csv'

class CsvImportsController < ApplicationController
  before_action :set_csv_import, only: [:show, :edit, :update, :destroy, :run]

  # GET /csv_imports
  # GET /csv_imports.json
  def index
    @csv_imports = CsvImport.order(created_at: :desc).all
  end

  # GET /csv_imports/1
  # GET /csv_imports/1.json
  def show
    @raw_orders = RawOrder.includes(:order, :csv_import).where(:csv_import_id => @csv_import.id).all
    @raw_orders = @raw_orders.sort do |row1, row2|
      v1 = row1.valid? ? 1 : 0
      v2 = row2.valid? ? 1 : 0
      res = v1 <=> v2
      if res == 0
        res = (row1.order.nil? ? 0 : 1) <=> (row2.order.nil? ? 0 : 1)
      end
      if res == 0
        res = row1.row_num <=> row2.row_num
      end
      res
    end

    @raw_order_fields = RawOrder.column_names - %w(id row_num csv_import created_at updated_at)
  end

  # GET /csv_imports/new
  def new
    @csv_import = CsvImport.new
  end

  # GET /csv_imports/1/edit
  def edit
  end

  # POST /csv_imports
  # POST /csv_imports.json
  def create
    @csv_import = CsvImport.new(csv_import_params)
    CsvImport.transaction do
      respond_to do |format|
        if @csv_import.save
          create_raw_orders
          format.html { redirect_to @csv_import, notice: 'Csv import was successfully created.' }
          format.json { render :show, status: :created, location: @csv_import }
        else
          format.html { render :new }
          format.json { render json: @csv_import.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /csv_imports/1
  # PATCH/PUT /csv_imports/1.json
  def update
    respond_to do |format|
      if @csv_import.update(csv_import_params)
        format.html { redirect_to @csv_import, notice: 'Csv import was successfully updated.' }
        format.json { render :show, status: :ok, location: @csv_import }
      else
        format.html { render :edit }
        format.json { render json: @csv_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /csv_imports/1
  # DELETE /csv_imports/1.json
  def destroy
    @csv_import.destroy
    respond_to do |format|
      format.html { redirect_to csv_imports_url, notice: 'Csv import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Process uploaded CSV file
  def run
    @row_num = 0
    @raw_orders = RawOrder.where(csv_import_id: @csv_import.id).where('order_id IS NULL')
    @raw_orders.all.find_each do |ro|
      if ro.valid?
        import_order(ro)
      end
    end
    redirect_to @csv_import
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_csv_import
    @csv_import = CsvImport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def csv_import_params
    params.require(:csv_import).permit(:csv)
  end

  def create_raw_orders
    @row_num = 0
    @csv_contents = @csv_import.csv.read
    CSV.parse @csv_contents, :headers => true do |row|
      @row_num += 1
      params = row.to_hash
      params[:row_num] = @row_num
      params[:csv_import] = @csv_import
      raw_order = RawOrder.new(params)
      raw_order.save :validate => false
    end
  end

  def import_order(raw_order)
    order = from_raw_order(raw_order)
    raw_order.update :order_id => order.id
  end

  def from_raw_order(ro)
    order_params = ro.attributes.to_hash
    order_params.delete_if { |key, value| %w(id row_num created_at updated_at order_id csv_import_id).include? key }
    order_params[:raw_order_id] = ro.id
    order_params[:delivery_date] = Date.strptime ro.delivery_date, '%m/%d/%Y'

    order = Order.new(order_params)
    if order.valid?
      order.save
    else
      order.errors.full_messages.each do |msg|
        puts msg
      end
    end

    order
  end
end
