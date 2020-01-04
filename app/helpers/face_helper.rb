module FaceHelper
  def drawing_face(face_detect_collection)
    output_shape = []
    if face_detect_collection
      face_detect_collection.each do |position|
        output_shape << position if position['id'].to_i <= 1040
      end
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

    format_shape(diff_degree,calculate_line,wide_face,long_face)
  end

  def format_shape(diff_degree,cal_line,wide,long)
    wide_f = wide_face_calculate(wide, @face_size)
    long_f = long_face_calculate(long, @face_size)

    if diff_degree[3] <= diff_degree[6]
      format_face = "triangle"
      if diff_degree[6] - diff_degree[3] >= 8
        format_face = "triangle"
      elsif (diff_degree[2] - diff_degree[4]).abs <= 4
        if (diff_degree[1] - diff_degree[5]).abs <= 4
          if wide_f/long_f < 0.725
            format_face = "oval"
          else
            format_face = "circle"
          end
        end
      end
    elsif diff_degree[6] - diff_degree[3] >= 8
      format_face = "triangle"
    elsif (diff_degree[2] - diff_degree[4]).abs <= 4 || (diff_degree[1] - diff_degree[5]).abs <= 4
      if wide_f/long_f < 0.725
        format_face = "oval"
      else
        format_face = "circle"
      end
    elsif diff_degree[3] >= 20
      if wide_f/long_f < 0.725
        format_face = "rectangle"
      else
        format_face = "square"
      end
      if cal_line[0] > 80.5
        if (diff_degree[3] - diff_degree[6] > 4)
          if (diff_degree[2] - diff_degree[4]).abs <= 4 && ​if(diff_degree[1] - diff_degree[5]).abs <= 4
            if wide_f/long_f < 0.725
              format_face = "oval"
            else
              format_face = "circle"
            end
          end
        end
      end
      if diff_degree[3] - diff_degree[6] >= 8
        if (diff_degree[2] - diff_degree[4]).abs <= 4 || (diff_degree[1] - diff_degree[5]).abs <= 4
          if wide_f/long_f < 0.725
            format_face = "oval"
          else
            format_face = "circle"
          end
        end
      end
    elsif (diff_degree[2] - diff_degree[4]).abs <= 4 || (diff_degree[1] - diff_degree[5]).abs <= 4
      if wide_f/long_f < 0.725
        format_face = "oval"
      else
        format_face = "circle"
      end
    else
      format_face = ""
    end

    information_shape(format_face)
  end
end
