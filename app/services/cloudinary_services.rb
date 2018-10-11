# app/services/cloudinary_services.rb

require 'cloudinary'

class CloudinaryServices
  def initialize(args)
    @url = args[:url]
    @options = args[:resource_options]
    @upload_type = args[:upload_type]
  end

  def upload_resource
    external_upload_service.upload(url, upload_type_options)
  end

  def delete_resource
    external_delete_service.delete_resources(public_id, delete_type_options)
  end

  private

  attr_reader :url, :options, :upload_type

  def external_upload_service
    Cloudinary::Uploader
  end

  def external_delete_service
    Cloudinary::Api
  end

  def audio_upload_options
    {
      resource_type: 'video',
      folder: "#{options.class.to_s.downcase}/audio/",
      format: 'mp3',
      public_id: "000#{options.id}"
    }
  end

  def image_upload_options
    {
      width: 150,
      height: 150,
      folder: "#{options.class.to_s.downcase}/image/",
      format: 'png',
      public_id: "000#{options.id}"
    }
  end

  def upload_type_options
    return image_upload_options if upload_type == 'image'

    audio_upload_options
  end

  def delete_type_options
    return { resource_type: 'image' } if upload_type == 'image'

    { resource_type: 'video' }
  end

  def public_id
    options["#{upload_type}_public_id"]
  end
end
