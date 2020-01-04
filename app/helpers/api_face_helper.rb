module ApiFaceHelper
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
