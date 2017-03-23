class ParkingSpace < ActiveRecord::Base
  has_many :photos
  belongs_to :user


  acts_as_mappable :default_units => :kms,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
end
