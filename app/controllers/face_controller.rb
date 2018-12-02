class FaceController < ApplicationController
  require 'uri'
  def index

    if params[:train_image_url_1]

      @train_image_source = params[:train_image_url_1]
      @get_tid = get_tid(@train_image_source)
      @save_tags = face_train(@get_tid)

      if params[:image_url]
        @image_source = params[:image_url]

        @face_status = face_status_points(@image_source)
        @face_shape = drawing_face(@face_status)

        @face_size = face_detail(@image_source)
        @result = recognize_face(@image_source)
      end
    end
  end

  def admin
    if params[:image_url]
      @image = params[:image_url]
      @image_url = URI.parse(@image)
      @result_admin = face_detail(@image_url)
    end
  end

  private

  def drawing_face(face_detect_collection)
    output_shape = []
    face_detect_collection.each do |position|
      output_shape << position if position['id'].to_i <= 1040
    end
    output_shape
  end
end
