# encoding: utf-8

class ProfileUploader < CarrierWave::Uploader::Base

 include CarrierWave::MiniMagick
  include CarrierWave::MimeTypes

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :grid_fs

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    #
    "default"
  end

  def file_version(version = nil)
    if version.nil?
      self.file
    elsif self.respond_to?(version)
      self.send(version).file
    else
      nil
    end
  end

  def image?(file = nil)
    file = self.file if file.nil?

    return nil if file.nil?

    file.content_type.include?('image')
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process resize_to_fit: [100, 100]
  end

  version :large do
  end

  version :medium, if: :image? do
    process resize_to_fill: [200, 200]
  end

  process :set_content_type

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  # %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  # "something.jpg" if original_filename
  # end



end
