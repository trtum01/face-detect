class FaceController < ApplicationController
  def index

    if params[:image_url]
      @image_source = params[:image_url]
      @face_detected = face_detect(@image_source)

      @face_status = face_status(@image_source)
      @face_shape = drawing_face(@face_status)

      @face_size = face_size(@image_source)
      @face_recog = face_recog(@image_source)
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
