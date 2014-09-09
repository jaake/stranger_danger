class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  def location
    location_data = []
    self.params.each do |p|
      location_data.append(p[1])
    end
    @coords = "#{location_data[0]}, #{location_data[1]}"
    user_location = Geokit::Geocoders::GoogleGeocoder.geocode "#{@coords}"
    images = Image.all 
    @images_near = []
    images.each do |image|
      ll = [image.latitude, image.longitude]
      distance = user_location.distance_to(ll)
      bearing = user_location.heading_to(ll)
      holder = [image, distance.round(2), bearing.round]
      @images_near.append(holder) if (distance < 10) 
    end
  end

  def publish
    location_data = []
    self.params.each do |p|
      location_data.append(p[1])
    end
    @coords = "#{location_data[0]}, #{location_data[1]}"
    user_location = Geokit::Geocoders::GoogleGeocoder.geocode "#{@coords}"
    self[:latitude] = "#{location_data[0]}"
    self[:longitude] = "#{location_data[1]}"
    self[:tag_1] = "#{location_data[2]}"
    self[:tag_2] = "#{location_data[3]}"
    self[:tag_3] = "#{location_data[4]}"
    self[:address] = user_location.full_address
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /images
  # GET /images.json
  def index
    @image = Image.new
    @images = Image.all
    respond_to do |format|
      format.html
      format.js 
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:address, :latitude, :longitude, :photo, :tag_1, :tag_2, :tag_3)
    end
end
