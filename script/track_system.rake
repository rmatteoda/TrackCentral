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
   Rake::Task['track_system:start_server'].invoke
   sleep 15
   Rake::Task['track_system:open_gui'].invoke
   sleep 5
   Rake::Task['track_system:start_clockwork'].invoke
  #sleep 15
   #Rake::Task['track_system:open_serial_reader'].invoke
   #sleep 2   
end

task :stop_system do
  Rake::Task['track_system:stop_server'].invoke
  sleep 5
  Rake::Task['track_system:close_gui'].invoke
  sleep 5 
  Rake::Task['track_system:stop_clockwork'].invoke
 #Rake::Task['track_system:stop_serial_reader'].invoke
  #sleep 5  
end

task :stop_server do
  pid_file = 'tmp/pids/server.pid'
  #pid_file = 'tmp/pids/passenger.3000.pid'
  if File.file?(pid_file)
    print "Shutting down server\n"
    pid = File.read(pid_file).to_i
    Process.kill "INT", pid
  end  
  #File.file?(pid_file) && File.delete(pid_file)
end

task :start_server do
  Dir.chdir(APP_DIR) do
    #ruby "./script/rails s -p 3000 -P /home/tracktambo/TrackCentral/tmp/pids/server.pid &" 
    system "passenger start -d -p 3010 --pid-file /home/tracktambo/TrackCentral/tmp/pids/server.pid --log-file /home/tracktambo/TrackCentral/log/server.log &" 
    #system "passenger start &" 
  end
end

task :open_gui do
  Dir.chdir(APP_DIR) do
   #system "java -jar -d32 -XstartOnFirstThread ./vendor/client/TrackClientUI.jar http:\\localhost:3020 &"
   system "java -jar -d32 ./vendor/client/TrackClientUI_Linux.jar http:\\localhost:3010 -vmargs -Dorg.eclipse.swt.browser.UseWebKitGTK=true &"
  end
end

task :close_gui do
  pid_file = 'tmp/pids/clientgui.pid'  
  if File.file?(pid_file)
    print "Shutting down Client GUI\n"
    pid = File.read(pid_file).to_i
    system "kill -9 " + pid.to_s
    #Process.kill "INT", pid
  end
  
  File.file?(pid_file) && File.delete(pid_file)
end

task :start_clockwork do
  Dir.chdir(APP_DIR) do
   #system "java -jar -d32 -XstartOnFirstThread ./vendor/client/TrackClientUI.jar http:\\localhost:3020 &"
   system "clockwork config/clock.rb &"
  end
end

task :stop_clockwork do
  pid_file = 'tmp/pids/clockwork.pid'
  
  if File.file?(pid_file)
    print "Shutting down ClockWork\n"
    pid = File.read(pid_file).to_i
    system "kill -9 " + pid.to_s
  end
  
  File.file?(pid_file) && File.delete(pid_file)
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
  File.file?(file_to_delete) && File.delete(file_to_delete)
  file_to_delete = 'tmp/pids/server.pid'
  File.file?(file_to_delete) && File.delete(file_to_delete)
  file_to_delete = 'tmp/pids/clockwork.pid'
  File.file?(file_to_delete) && File.delete(file_to_delete)
end


end
