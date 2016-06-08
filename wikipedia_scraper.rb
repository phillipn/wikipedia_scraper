require 'open-uri'
require 'nokogiri'
require 'csv'
 
url = "https://en.wikipedia.org/wiki/List_of_current_NBA_team_rosters"
page = Nokogiri::HTML(open(url))

heights = []
weights = []
heights2 = []
weights2 = []
names = []

page.css('td[style="text-align:right; white-space:nowrap;"]').each do |instance|
  if instance.text.include?('m')
    heights << instance.text
  else
    weights << instance.text
  end
end

page.css('td[style="text-align:left;"]').each do |instance|
    names << instance.text if instance.text.include?(',') || instance.text.include?('ê')
end

heights.each do |height|
   heights2 << height[-7..-4].to_f
end

weights.each do |weight|
  if weight[-7] == '(' 
   weights2 << weight[-6..-4].to_f
  else
   weights2 << weight[-7..-4].to_f
  end
end

CSV.open("player_weight_height.csv", "w") do |file|
  file << ["Name", "Height (m)", "Weight (kg)"]
  names.length.times do |i|
    file << [names[i], heights2[i], weights2[i]]
  end
end