require 'rubygems'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.cron '10 06 * * *' do
    system "bundle exec rake track_celo:detectar_celos"
end

scheduler.cron '10 17 * * *' do
    system "bundle exec rake track_celo:detectar_celos"
end

scheduler.every '15m' do
  puts "start load collected data "
  system "bundle exec rake track_data:load_collected_data"
end

scheduler.every '24h' do
  system "bundle exec rake  track_stats:generar_recorrido_promedio"
end