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
   sleep 20
   Rake::Task['track_system:start_server'].invoke
   sleep 15
   Rake::Task['track_system:open_gui'].invoke
   sleep 15
   Rake::Task['track_system:open_serial_reader'].invoke
   sleep 2   
end

#task :start_terminal do
#  system "xterm -hold -e /home/tracktambo/TrackCentral/script/reboot_system.sh &"
#end

task :stop_system do
  Rake::Task['track_system:stop_server'].invoke
  sleep 5
  Rake::Task['track_system:close_gui'].invoke
  sleep 5 
  #Rake::Task['track_system:stop_serial_reader'].invoke
  #sleep 5  
end

task :stop_server do
  pid_file = 'tmp/pids/server.pid'
  if File.file?(pid_file)
    print "Shutting down server\n"
    pid = File.read(pid_file).to_i
    Process.kill "INT", pid
  end
  
  File.file?(pid_file) && File.delete(pid_file)
end

task :start_server do
  Dir.chdir(APP_DIR) do
    ruby "./script/rails s -p 3020 -P /home/tracktambo/TrackCentral/tmp/pids/server.pid &" 
  end
end

task :open_gui do
  Dir.chdir(APP_DIR) do
   #system "java -jar -d32 -XstartOnFirstThread ./vendor/client/TrackClientUI.jar http:\\localhost:3020 &"
   system "java -jar -d32 ./vendor/client/TrackClientUI_Linux.jar http:\\localhost:3020 -Dorg.eclipse.swt.browser.UseWebKitGTK=true &"
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

end
