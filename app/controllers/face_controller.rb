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

    format_shape(diff_degree,calculate_line,wide_face,long_face)
  end

  def slope_calculate(x1,x2,y1,y2)
    slope = (y1 - y2)/(x1 - x2)
    Math.atan(slope)*(180/Math::PI)
  end

  def format_shape(diff_degree,cal_line,wide,long)
    format_shape = ""
    wide_f = Math.sqrt(((wide[0]['x'].to_i*@face_size['width']/100 - wide[1]['x'].to_i*@face_size['width']/100)**2) + ((wide[0]['y'].to_i*@face_size['height']/100 - wide[1]['y'].to_i*@face_size['height']/100)**2))
    long_f = Math.sqrt(((long[0]['x'].to_i*@face_size['width']/100 - long[1]['x'].to_i*@face_size['width']/100)**2) + ((long[0]['y'].to_i*@face_size['height']/100 - long[1]['y'].to_i*@face_size['height']/100)**2))

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

  def information_shape(format_shape)
    case format_shape
    when "circle"
      info = "คนธาตุน้ำ คือบุคคลที่มีลักษณะรูปหน้าทรงกลม อุปนิสัยโดยทั่วไปจะเป็นคนที่มีอารมณ์อ่อนไหว ฉลาดทันคน รักความสบาย ชอบเข้าสังคม มีเพื่อนฝูงมากมาย เป็นคนประนีประนอม อะลุ่มอล่วย ขาดความเด็ดขาด ปรับตัวเข้าหาผู้อื่นได้ดี รักงานด้านบริการหรือติดต่อประสานงาน เหมาะเป็นนักประสานประโยชน์ หรือผู้ช่วยระดับบริหาร"
    when "oval"
      info = "คนธาตุดิน คือบุคคลที่มีรูปหน้าทรงรีหรือรูปไข่ อุปนิสัยโดยทั่วไปจะเป็นคนพูดจาตรงไปตรงมา มั่นคงหนักแน่น ชอบทำมากกว่าพูด ขยัน ซื่อสัตย์ รักษาระเบียบ ไม่ชอบเสี่ยงทำธุรกิจหรืองานใหญ่ที่ ไม่มีความแน่นอน เหมาะที่จะเป็นพนักงานฝ่ายปฏิบัติการ"
    when "square"
      info = "คนธาตุทอง คือบุคคลที่มีลักษณะรูปหน้าเหลี่ยมจัตุรัสอุปนิสัยโดยทั่วไปจะเป็นคนที่มีความเป็นผู้นำ มีวิสัยทัศน์มองการณ์ไกล ฉลาด สุขุม มีเหตุผล กล้าคิดกล้าทำ กล้าตัดสินใจ และกล้ารับผิดชอบ เหมาะที่จะเป็นนักบริหาร วางนโยบาย วางแผน"
    when "rectangle"
      info = "คนธาตุไม้ คือบุคคลที่มีรูปหน้าสี่เหลี่ยมผืนผ้า อุปนิสัยโดยทั่วไปจะเป็นคนที่โกรธง่ายหายเร็ว ใจดีมีเมตตา มีวิสัยทัศน์กว้างไกล มีวาทศิลป์ในการพูด รอบรู้หลายเรื่อง ฉลาดทันคน ถนัดด้านการเรียนการสอน หรือเป็นที่ปรึกษาวางแผน บุคคลแบบนี้เหมาะที่จะเป็นนักคิด นักวิชาการ นักวิเคราะห์"
    when "triangle"
      info = "คนธาตุไฟ คือบุคคลที่มีรูปหน้าแบบสามเหลี่ยมหรือคางเรียวแหลม อุปนิสัยโดยทั่วไปจะมีความคล่องแคล่วว่องไว ทะเยอทะยาน ชอบผจญภัย มุทะลุวู่วาม มีจินตนาการและมีอุดมคติสูง ชอบค้นคว้าหาเหตุผล เรียนเก่งเรียนรู้ไว บุคคล แบบนี้เหมาะที่จะเป็นนักตรวจสอบ หรือหัวหน้างานระดับกลางๆ"
    else
      info = "ไม่ทราบใบหน้า อาจเกิดจากปัจจัยหลายอย่างหลาย ทำให้วิเคราะห์ไม่ได้"
    end
    info
  end

end
