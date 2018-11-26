class FaceController < ApplicationController
  def index

    if params[:image_url]
      @image_source = params[:image_url]
      @face_detected = face_detect(@image_source)

      @face_status = face_status(@image_source)
      @face_shape = drawing_face(@face_status)

      @face_size = face_size(@image_source)
      @result = recognize_face(@image_source)
    end

    if params[:train_image_url_1]
      @train_image_source = params[:train_image_url_1]
      @traimid = face_recog(@train_image_source)
      @save_tags = face_train(@traimid, "pic1@testperson2")
    end

    if params[:train_image_url_2]
      @train_image_source = params[:train_image_url_2]
      @traimid = face_recog(@train_image_source)
      @save_tags = face_train(@traimid, "pic2@testperson2")
    end

    if params[:train_image_url_3]
      @train_image_source = params[:train_image_url_3]
      @traimid = face_recog(@train_image_source)
      @save_tags = face_train(@traimid, "pic3@testperson2")
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
