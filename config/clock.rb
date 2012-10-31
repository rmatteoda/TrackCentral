require 'clockwork'
require 'rake'
include Clockwork

handler do |job|
  puts "Running #{job}"
end

every(10.seconds, 'frequent.job')
every(3.minutes, 'less.frequent.job') do
 # Rake::Task['update_feed'].invoke
 system "rake update_feed"
end

