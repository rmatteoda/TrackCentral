require 'fileutils'

puts "copy files "
#t = Time.now
#d = t.strftime("%m/%d/%Y")   #=> "Printed on 04/09/2003"

FileUtils.cp("test.pl", Time.now.strftime("%Y%m%d-%H:%M") + "copy.pl")


