class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def face_detect(image_source)

    # Return ONLY true/false
    # Potential upgrade: return also the "confidence"

    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)

    original_output = client.faces_detect(urls: [image_source] , attributes: 'all')

    begin

      face_detection  = original_output['photos'].first['tags'].first['attributes']['face']
      detected        = face_detection['value']
        #confidence     = face_detection['confidence']

    rescue Exception => error

      detected    = false
      #confidence  = 999

    end

    # return ONLY true/false
    detected

  end

  def face_status(image_source)

    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    original_output = client.faces_detect(urls: [image_source] , attributes: 'all')

    begin
      face_status_s = original_output['photos'].first['tags'].first['points']
    rescue  Exception => error
      face_status_s = "error"
    end

    face_status_s

  end

  def face_size(image_source)

    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)

    original_output = client.faces_detect(urls: [image_source] , attributes: 'all')

    begin

      face_status_s = original_output['photos'].first

    rescue  Exception => error
      face_status_s = "error"
    end
    face_status_s

  end

  def face_recog

  end

end
