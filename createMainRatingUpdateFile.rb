#This script will create the input file for Service Request - MasterDB Content Data Update
#Use the following SQL query to get the CSV input file for this script

# SELECT rv.ReviewId, rv.Rating, P.Name
# FROM Client c
#     JOIN ReviewVersion rv
#         ON c.ID = rv.ClientId
#     JOIN Product P
#         ON rv.ProductId = P.ID
# WHERE c.Name = 'GameStop'


require 'csv'
# get CSV file from command line argumnet
filename = ARGV.first
csv_input = open(filename)

#build 2d array of csv data
csv_array = CSV.read(csv_input)

#convert 10star ratings to 5star scale
def convertRatings(rating)
  if rating == 10
    return 5
  elsif rating >= 7
    return 4
  elsif rating >= 5
    return 3
  elsif rating >= 2
    return 2
  elsif rating == 1
    return 1
  end
end

puts csv_array.inspect

outputFile = File.open("GameStop-RatingConversion.txt", "w")

outputFile.puts("Review.ID,Rating")
presentRatingsArray = []

csv_array.each do |row|
  outputFile.puts("#{row[0]}  #{convertRatings(row[1].to_i)}") unless row[1] == "NULL"
  presentRatingsArray.push(row[3]) unless row[1] == "NULL"
end

outputFile.close

puts '<<=========================================================>>'
puts "      Created files to modify #{presentRatingsArray.length} ratings"
puts '<<=========================================================>>'
