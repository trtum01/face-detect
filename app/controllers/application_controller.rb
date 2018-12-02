class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def face_status_points(image_source)
    begin
      result = api_key_detect(image_source)['photos'].first['tags'].first['points']
    rescue  Exception => error
      result = "Error at face_status_points"
    end
    result
  end

  def face_detail(image_source)
    begin
      result = api_key_detect(image_source)['photos'].first
    rescue  Exception => error
      result = "Error at face_detail"
    end
    result
  end

  def get_tid(image_source)
    begin
      trainid = api_key_detect(image_source)['photos'].first['tags'].first['tid']
    rescue  Exception => error
      trainid = "error tid"
    end
    trainid
  end

  def face_train(tid)
    begin
      api_key.tags_save(uid: "pic1@testperson2" , tids: [tid])
      uids = api_key_train['status']
    rescue Exception => error
      uids = "Error"
    end
    uids
  end

  def remove_tags(tid)
    begin
      rm_tags = api_key.tags_remove(tids: [tid])
    rescue Exception => error
      rm_tags = "Error"
    end
    rm_tags
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

  def api_key
    client = Face.get_client(api_key: FACE_API_KEY, api_secret: FACE_SECRET_KEY)
  end

  def api_key_detect(image_source)
    original_output = api_key.faces_detect(urls: [image_source])
  end

  def api_key_recognize(image_source)
    original_output = api_key.faces_recognize(uids: "pic1@testperson2", urls: [image_source])
  end

  def api_key_train
    original_output = api_key.faces_train(uids: "pic1@testperson2")
  end

end
