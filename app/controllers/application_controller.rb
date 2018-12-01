class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def face_status_points(image_source)
    begin
      face_status_s = api_key_detect(image_source)['photos'].first['tags'].first['points']
    rescue  Exception => error
      face_status_s = "error"
    end
    face_status_s
  end

  def face_size(image_source)
    begin
      face_status_s = api_key_detect(image_source)['photos'].first
    rescue  Exception => error
      face_status_s = "error"
    end
    face_status_s
  end

  def face_train(tid)
    begin
      save_tags = api_key_train.tags_save(uid: "pic1@testperson2" , tids: [tid])
      uids = api_client.faces_train(uids: "pic1@testperson2")
      train_result = uids['status']
    rescue Exception => error
      train_result = "Error"
    end
    train_result
  end

  def remove_tags(tid)
    begin
      rm_tags = api_key_train.tags_remove(tids: [tid])
    rescue Exception => error
      rm_tags = "Error"
    end
    rm_tags
  end

  def face_recog(image_source)
    begin
      trainid = api_key_detect(image_source)['photos'].first['tags'].first['tid']
    rescue  Exception => error
      trainid = "error tid"
      save_tag = "error tags"
    end
    trainid
  end

  def recognize_face(image_source)
    begin
      result = api_key_recognize(image_source)['photos'].first['tags'].first['uids'].first['confidence']
    rescue  Exception => error
      result = "error"
    end
    result
  end

  private

  def api_key_detect(image_source)
    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    original_output = client.faces_detect(urls: [image_source])
  end

  def api_key_train
    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
  end

  def api_key_recognize(image_source)
    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
    original_out = client.faces_recognize(uids: "pic1@testperson2", urls: [image_source])
  end

end
