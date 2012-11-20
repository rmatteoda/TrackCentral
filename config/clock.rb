require 'clockwork'
require 'stalker'
include Clockwork

File.open('/home/tracktambo/TrackCentral/tmp/pids/clockwork.pid', 'w') do |fcl|  
  fcl.puts Process.pid.to_s
end  

Clockwork.configure do |config|
  config[:sleep_timeout] = 5 #en real ejecucion deberia ser mas tiempo
  config[:logger] = Logger.new('/home/tracktambo/TrackCentral/log/clockwork.log')
end

handler { |job| Stalker.enqueue(job) }

every(10.minute, 'test.job')

every 30.minute, 'collect_data' do
  system "cd /home/tracktambo/TrackCentral &"
  system "rake track_data:load_collected_data &"
end

#every 6.hours, 'detect_celo' do
#  system "rake track_celo:detectar_celos"
#end

#every 2.days, 'detect_perdida',:at => '2:30 am' do
#  system "rake track_vacas:detectar_perdida"
#end

#every 10.days, 'detect_alarms' do
#  system "rake track_vacas:detectar_alarmas"
#end

#every 90.days, :at => '2:00 am' do
  #borrar registro de actividades con mas de 1 mes de antiguedad ActivityClearDB
#  system "rake track_db:clear_old_data"
#end