ARGV.each do |i|
  f = open(i)
  p i + ".csv"
  wf = open(i + ".csv", 'w')
  begin
    f.each do |str|
      str = str.gsub(/\t/, ",")
      wf << str
    end
  ensure
    f.close
    wf.close
  end
end
