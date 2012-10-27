namespace :track_system do
desc 'stop server'
#VER: https://github.com/outoftime/rake_server
APP_DIR = "/Users/ramiro/Workspace/workspace_ror/TrackCentral"

task :restart_system do
  Rake::Task['track_system:stop_system'].invoke
  sleep 5
  Rake::Task['track_system:start_system'].invoke
  sleep 5
end

task :start_system do
   Rake::Task['track_system:start_server'].invoke
   sleep 5
   Rake::Task['track_system:open_gui'].invoke
   sleep 5   
end

task :start_system_terminal do
   system "open -a Terminal.app /Users/ramiro/Workspace/workspace_ror/TrackCentral/script/reboot_system.sh"
   #system "open -a Terminal.app"
   #system "ls"
   #Rake::Task['track_system:start_server'].invoke
   #sleep 5
   #Rake::Task['track_system:open_gui'].invoke
   #sleep 5   
end

task :stop_system do
  Rake::Task['track_system:stop_server'].invoke
  sleep 5
  Rake::Task['track_system:close_gui'].invoke
  sleep 5  
end

task :stop_server do
  pid_file = 'tmp/pids/server.pid'
  if File.file?(pid_file)
    print "Shutting down WEBrick\n"
    pid = File.read(pid_file).to_i
    Process.kill "INT", pid
  end
  
  File.file?(pid_file) && File.delete(pid_file)
end

task :start_server do
  Dir.chdir(APP_DIR) do
    ruby "./script/rails s -p 3020 &" 
  end
end

task :open_gui do
  Dir.chdir(APP_DIR) do
    system "java -jar -d32 -XstartOnFirstThread ./vendor/client/TrackClientUI.jar http:\\localhost:3020 &"
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
  Dir.chdir(APP_DIR) do
    system "perl ./vendor/client/perl/SerialReader.pl &"
  end
end

task :close_serial_reader do
  pid_file = 'tmp/pids/serialreader.pid'
  
  if File.file?(pid_file)
    print "Shutting down Serial Reader\n"
    pid = File.read(pid_file).to_i
    system "kill -9 " + pid.to_s
    #Process.kill "INT", pid
  end
  
  File.file?(pid_file) && File.delete(pid_file)
end

end