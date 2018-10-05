class FaceController < ApplicationController
  def index

    if params[:image_url]
      @image_source = params[:image_url]
      @face_detected = face_detect(@image_source)
      @face_status = face_status(@image_source)
      @face_size = face_size(@image_source)
    end
  end

  private

  def drawing_points

  end
end
