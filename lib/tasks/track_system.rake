namespace :track_system do
desc 'system management task'
APP_DIR = "/home/tracktambo/TrackCentral"

task :restart_system do
  Rake::Task['track_system:stop_system'].invoke
  sleep 5
  Rake::Task['track_system:start_system'].invoke
  sleep 5
end

task :start_system do
   sleep 10
   Rake::Task['track_system:delete_app_files'].invoke
   sleep 20
end

#controla que el coordinador este funcioando y recibiendo datos, de lo contrario reinicia la pc
task :check_coordinator do
  if File.exist?('log/ultimo_registro.txt')
    #open file
    reg_input = File.open('log/ultimo_registro.txt', 'r').first 
    last_reg_input = DateTime::strptime(reg_input,"%Y%m%d-%H:%M")
    hr_from_last = ((Time.now - last_reg_input.to_time)/1.hour).round  
    puts "ultimo registro dif " +   hr_from_last.to_s
  end
end

#permite cerrar todas las aplicaciones y reiniciar la pc
task :restart_pc do
system "shutdown /r /f"
end

task :open_serial_reader do
  Dir.chdir(APP_DIR+"/vendor/client/perl") do
    system "./SerialReader.pl"
  end
  Dir.chdir(APP_DIR)
end

task :close_serial_reader do
  pid_file = 'tmp/pids/serialreader.pid'
  
  if File.file?(pid_file)
    print "Shutting down Serial Reader\n"
    pid = File.read(pid_file).to_i
    system "kill -9 " + pid.to_s
  end
  
  File.file?(pid_file) && File.delete(pid_file)
end

task :delete_app_files do
  Dir.chdir(APP_DIR)
  file_to_delete = 'tmp/pids/serialreader.pid'
  File.file?(file_to_delete) && File.delete(file_to_delete)
  file_to_delete = 'tmp/pids/clientgui.pid'
end


end
