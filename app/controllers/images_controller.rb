class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  def location
    images = Image.all 
    @lat = params[:latitude]
    @lng = params[:longitude]
    @coords = [ @lat, @lng ]
    ## TODO: Refactor below into module that accepts @lat & @lng as args && get rid of Geokit on lookup.
    bearing_to_letters = 'N.png'
    user_location = Geokit::Geocoders::GoogleGeocoder.geocode("#{@lat}, #{@lng}") 
    @warmest = []
    @warmer = []
    @warm = []
    @cold = []
    images.each do |image|
      ll = ["#{image.latitude}", "#{image.longitude}"]
      distance = user_location.distance_to(ll)
      bearing = user_location.heading_to(ll)
      if bearing.round > 337 || bearing.round < 23
        bearing_to_letters = 'N.png'
      elsif bearing.round < 67
        bearing_to_letters = 'NE.png'
      elsif bearing.round < 112
        bearing_to_letters = 'E.png'
      elsif bearing.round < 157
        bearing_to_letters = 'SE.png'
      elsif bearing.round < 202
        bearing_to_letters = 'S.png'
      elsif bearing.round < 247
        bearing_to_letters = 'SW.png'
      elsif bearing.round < 292
        bearing_to_letters = 'W.png'
      elsif bearing.round < 337
        bearing_to_letters = 'NW.png'
      end
      holder = [DateTime.parse(image.created_at.to_s).to_i, image, bearing_to_letters, distance]
      if distance < 0.11
        @warmest.append(holder)
      elsif distance < 1       
        @warmer.append(holder) 
      elsif distance < 5.0
        @warm.append(holder)
      elsif distance < 25.0
        @cold.append(holder)
      end
    end
    @warmest.reverse!
    @warmest = @warmest[0..14]
    @warmer.reverse!
    @warmer = @warmer[0..29]
    @warm.reverse!
    @warm = @warm[0..54]
    feed_length = @warm.length + @warmer.length + @warmest.length
    cold_range_end = 100 - feed_length
    @cold.reverse!
    @cold = @cold[0..cold_range_end]

  end

  # GET /images
  # GET /images.json
  def index
    @image = Image.new
    @images = Image.all
    @faces = ['face_0.png', 'face_1.png', 'face_2.png', 'face_3.png', 'face_4.png']
    @faces.shuffle!
    respond_to do |format|
      format.html
      format.js 
    end
  end

  # GET /images/1
  # GET /images/1.json
  #def show
  #end

  # GET /images/new
  #def new
  #end

  # GET /images/1/edit
  #def edit
  #end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    respond_to do |format|
      if @image.save
        format.js
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
  #def destroy
  #  @image.destroy
  #  respond_to do |format|
  #    format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

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
