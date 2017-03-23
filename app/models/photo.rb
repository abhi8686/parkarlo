class Photo < ActiveRecord::Base
    acts_as_paranoid
    require 'rmagick'
    include Magick

    belongs_to :parking_space

    @@versions = {
        :square_large => [180, 180]
        
      }
    @@temp_file_path = Rails.application.config.aws_temp_path

      # Upload Image from File
      def self.upload_from_file file, mode=1
        if mode ==1
          self.upload_image file.tempfile
        else
          binding.pry
          self.upload_image file.path
        end
      end

      # Upload Image from URL
      def self.upload_from_url url
        self.upload_image url
      end
    # Method to upload All Images
      def self.push_to_aws file_path, file_name

        aws_credentials = Rails.application.config.aws_credentials
        s3 = Aws::S3::Resource.new(
          credentials: Aws::Credentials.new(aws_credentials[:access_key], aws_credentials[:secret_access_key]),
          region: aws_credentials[:region]
        )    

        # Reference the target object by bucket name and key.
        obj = s3.bucket(aws_credentials[:bucket]).object(file_name)

        # Call#upload_file on the object.
        obj.upload_file(file_path, acl:'public-read')
        return obj.public_url
      end


    def self.upload_image path
      new_img = Photo.new({
        :original => self.push_to_aws(path, SecureRandom.uuid+'.jpg') # Not sure if its ok to force an extension.
      })

      @@versions.each do |k, v|
        temp_file_name = SecureRandom.uuid
        temp_file_path = @@temp_file_path

        resized_img = self.resize_img(v, path)
        resized_img.write "#{temp_file_path}/#{temp_file_name}"

        url = self.push_to_aws "#{temp_file_path}/#{temp_file_name}", temp_file_name

        new_img[k] = url
        File.delete("#{temp_file_path}/#{temp_file_name}") if File.exist?("#{temp_file_path}/#{temp_file_name}")
      end
      new_img.save
      new_img
    end

      def self.resize_img version, path
        binary = File.open(path, 'r'){|f| f.read}
        image = ImageList.new().from_blob(binary)
        return image.resize_to_fill(version[0], version[1])
      end
end
