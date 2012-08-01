# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :reboot do
  #start server, start GUI, check all, create report
end

every 2.hours do
  #controlar y almacenar info de actividad en la DB. ActivityCoreSave
end

every 6.hours do
  #controlar y detectar vacas en celo ActivityCeloDetect
end

every 2.days, :at => '2:30 am' do
  #ActivityCollarController? puede hacerlo el colector
end

every 35.days, :at => '2:00 am' do
  #borrar registro de actividades con mas de 1 mes de antiguedad ActivityClearDB
end

every :friday, :at => "4am" do
  #detectar problemas, vacas con muchos servicios, >130dias no preñada. ActivityVacasObserver
  #genera las alarmas del sistema
end