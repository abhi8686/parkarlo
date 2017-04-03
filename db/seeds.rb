# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


def scrape_data json_data
  json_data.each do |x|
    lat =x["geometry"]["location"]["lat"]
    lng = x["geometry"]["location"]["lng"]
    $data = $data + [[lat, lng]]
    ParkingSpace.create(latitude: lat, longitude: lng, address: x["name"], user_id: 1, cost: 500)
    puts "created"
  end
end
require 'open-uri'
$data = [[17.482899,78.399076]]
i =0
while i < 100 do 
  begin 
    puts i 
    new_data = $data[i]
    lat = new_data[0]
    lng = new_data[1]
    # sleep 5
    response = open("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=" + lat.to_s + "," + lng.to_s + "&radius=10000&type=restaurant&keyword=&key=AIzaSyAJdvRiaxuKEuL8RhE4TE-Hzh5aqEPiz4o").read
    response = JSON.parse(response)
    scrape_data(response["results"])
    i = i+1
  rescue SocketError => error
    print "error"
  end
end



