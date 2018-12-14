class FaceController < ApplicationController
  def index
      if params[:image_url]
        @image_source = params[:image_url]
        if params[:coords_x]
          @headbuttx = params[:coords_x]
          @headbutty = params[:coords_y]
          @face_size = face_size(@image_source)

          @face_status = face_status_points(@image_source)
          @face_shape = drawing_face(@face_status)
          @result = analyzing_face(@face_shape, @headbuttx, @headbutty)
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

  def analyzing_face(face_shape, x, y)
    calculate_line = []
    wide_face = []
    diff_degree = []
    head = { "x" => x.to_i*100/@face_size['width'], "y" => y.to_i*100/@face_size['height'], "confidence" => 100, "id" => 1041}
    long_face = []
    long_face << head

    face_shape.each_cons(2) do |position|
      calculate_line << slope_calculate(position[0]['x'], position[1]['x'], position[0]['y'], position[1]['y']).round(2) if position[1]['id'].to_i <= 1032
    end

    face_shape.each do |position|
      wide_face << position if position['id'].to_i == 1024 || position['id'].to_i == 1040
      long_face << position if position['id'].to_i == 1032
    end

    calculate_line.each_cons(2) do |degree|
      diff_degree << (degree[0].abs - degree[1].abs).round.abs
    end

    # diff_degree
    format_shape(diff_degree,calculate_line,wide_face,long_face)
  end

  def slope_calculate(x1,x2,y1,y2)
    slope = (y1 - y2)/(x1 - x2)
    Math.atan(slope)*(180/Math::PI)
  end

  def format_shape(diff_degree,cal_line,wide,long)
    format_shape = ""
    wide = Math.sqrt(((wide[0]['x'].to_i - wide[1]['x'].to_i)**2) + ((wide[0]['y'].to_i - wide[1]['y'].to_i)**2))
    long = Math.sqrt(((long[0]['x'].to_i - long[1]['x'].to_i)**2) + ((long[0]['y'].to_i - long[1]['y'].to_i)**2))

    if diff_degree[3] <= diff_degree[6]
      if diff_degree[1] + diff_degree[2] >= diff_degree[4] + diff_degree[5]
        format_face = "Triangle"
        if diff_degree[6] - diff_degree[3] >= 8
          format_face = "Triangle"
        elsif (diff_degree[2] - diff_degree[4]).abs <= 4
          if (diff_degree[1] - diff_degree[5]).abs <= 4
            if wide/long < 1/2
              format_face = "oval"
            else
              format_face = "circle"
            end
          end
        end
      elsif diff_degree[6] - diff_degree[3] >= 8
        format_face = "Triangle"
      elsif (diff_degree[2] - diff_degree[4]).abs <= 4 || (diff_degree[1] - diff_degree[5]).abs <= 4
        if wide/long < 1/2
          format_face = "oval"
        else
          format_face = "circle"
        end
      end
    elsif diff_degree[3] >= 20
        if wide/long < 1/2
          format_face = "rectangle"
        else
          format_face = "square"
        end
      if cal_line[0] > 80.5
        if (diff_degree[3] - diff_degree[6] > 4)
          if (diff_degree[2] - diff_degree[4]).abs <= 4
            if(diff_degree[1] - diff_degree[5]).abs <= 4
              if wide/long < 1/2
                format_face = "oval"
              else
                format_face = "circle"
              end
            end
          end
        end
      end
      if diff_degree[3] - diff_degree[6] >= 8
        if (diff_degree[2] - diff_degree[4]).abs <= 4 || (diff_degree[1] - diff_degree[5]).abs <= 4
          if wide/long < 1/2
            format_face = "oval"
          else
            format_face = "circle"
          end
        end
      end
    elsif (diff_degree[2] - diff_degree[4]).abs <= 4 || (diff_degree[1] - diff_degree[5]).abs <= 4
      if wide/long < 1/2
        format_face = "oval"
      else
        format_face = "circle"
      end
    else
      format_face = "unknown"
    end

    format_face
  end
end
