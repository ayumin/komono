ARGF.each do |str| 
  print str.gsub(/\t/, ",") 
end 
