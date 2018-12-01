class FaceController < ApplicationController
  def index

    if params[:train_image_url_1]
      @train_image_source = params[:train_image_url_1]
      @traimid = face_recog(@train_image_source)
      @save_tags = face_train(@traimid)
      if params[:image_url]
        @image_source = params[:image_url]

        @face_status = face_status_points(@image_source)
        @face_shape = drawing_face(@face_status)

        @face_size = face_size(@image_source)
        @result = recognize_face(@image_source)
        @remove_tags = remove_tags(@traimid)
      end
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
