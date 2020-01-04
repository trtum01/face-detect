class FaceController < ApplicationController

  def index
      if params[:image_url] || params[:upload_path]
        @image_source = params[:image_url] unless params[:image_url].blank?
        @image_source_base = params[:upload_path] unless params[:upload_path].blank?
        if params[:coords_x]
          @headbuttx = params[:coords_x]
          @headbutty = params[:coords_y]
          @face_size = face_size(@image_source || @image_source_base)

          @face_status = face_status_points(@image_source || @image_source_base)
          @face_shape = drawing_face(@face_status)
          @result = analyzing_face(@face_shape, @headbuttx, @headbutty)
        end
      end
    #Merge
  end
end
