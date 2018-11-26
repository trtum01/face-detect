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

  def face_train(tid)

    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    begin

      save_tags = client.tags_save(uid: "pic1@testperson2" , tids: [tid])
      uids = client.faces_train(uids: "pic1@testperson2")

      # face_training = client.faces_train(uid: )
      train_result = uids['status']
    rescue Exception => error

      # save_tags = "error tids"
      train_result = "Error"
    end
    train_result
  end

  def remove_tags(tid)
    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    begin
      rm_tags = client.tags_remove(tids: [tid])
    rescue Exception => error
      rm_tags = "Error"
    end
    rm_tags
  end

  def face_recog(image_source)

    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    original_output = client.faces_detect(urls: [image_source]  , attributes: 'all')

    begin

      trainid = original_output['photos'].first['tags'].first['tid']

    rescue  Exception => error

      trainid = "error tid"
      save_tag = "error tags"

    end
    trainid
  end

  def recognize_face(image_source)

    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    original_out = client.faces_recognize(uids: "pic1@testperson2", urls: [image_source])

    begin

      result = original_out['photos'].first['tags'].first['uids'].first['confidence']

    rescue  Exception => error

      result = "error"

    end
    result
  end

end
