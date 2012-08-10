namespace :track_system do
desc 'stop server'
#VER: https://github.com/outoftime/rake_server
APP_DIR = "/Users/ramiro/Workspace/workspace_ror/TrackCentral"

task :stop_server do
  #ver: The only proper way to kill the Ruby on Rails default server (which is WEBrick) is:
  #kill -INT $(cat tmp/pids/server.pid)
  sleep 30
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
    ruby "./script/rails s &" 
  end
end

task :open_gui do
  sleep 40
  Dir.chdir(APP_DIR) do
    system "java -jar -d32 -XstartOnFirstThread ./vendor/client/TrackClientUI.jar http:\\localhost:3020 &"
  end
end

task :close_gui do
 
end

end