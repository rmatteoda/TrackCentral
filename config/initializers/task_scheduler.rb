require 'rubygems'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.start_new

#scheduler.every '60s' do
#  puts "test schduler"
#end
scheduler.cron '10 06 * * *' do
    system "bundle exec rake track_celo:detectar_celos"
end

scheduler.cron '10 17 * * *' do
    system "bundle exec rake track_celo:detectar_celos"
end

scheduler.every '50m' do
  #puts "start load collected data "
  system "bundle exec rake track_data:load_collected_data"
  #puts "end load collected data"
end

scheduler.every '24h' do
  #puts "start load collected data "
  system "bundle exec rake  track_stats:generar_recorrido_promedio"
  #puts "end load collected data"
end