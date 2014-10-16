require 'rubygems'
require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '10 06 * * *' do
    system "bundle exec rake track_celo:detectar_celos"
end

scheduler.cron '10 17 * * *' do
    system "bundle exec rake track_celo:detectar_celos"
end

scheduler.every '15m' do
  system "bundle exec rake track_data:load_collected_data"
end

scheduler.every '20h' do
  system "bundle exec rake  track_stats:generar_recorrido_promedio"
end
