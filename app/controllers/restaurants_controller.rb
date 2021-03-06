class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]
  after_action :verify_policy_scoped, only: [:index, :dashboard]
  skip_after_action :verify_authorized, only: :tagged

  # GET /restaurants
  # GET /restaurants.json
  def index
    @restaurants = policy_scope(Restaurant)
  end

  def dashboard
    @restaurants = policy_scope(Restaurant)
  end

  def tagged
    # raise
    # tag => "Pricy"
    @tag = params[:tag]
    @restaurants = Restaurant.tagged_with(@tag)
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
    authorize @restaurant
    # @restaurant = Restaurant.find(params[:id])
    @related = @restaurant.find_related_tags
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
    authorize @restaurant
    @tags = ["Cocktail", "Evening", "Designer", "Vintages"]
  end

  # GET /restaurants/1/edit
  def edit
    authorize @restaurant
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)
    authorize @restaurant
    @restaurant.user = current_user
    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    authorize @restaurant
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to @restaurant, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def restaurant_params
    params.require(:restaurant).permit(:name, :user_id, :tag_list)
  end
end
