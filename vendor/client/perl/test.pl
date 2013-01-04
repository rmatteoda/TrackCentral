my $logFileName = "Dump_Nodes_Log.txt";

    my($seg, $minute, $hour, $day, $month) = (localtime)[0,1,2,3,4];
        
        open(FH, ">>","$logFileName");
        print FH "dump from 5 in day ". $day . " hour  ".$hour.":".$minute.":".$seg ."\n";
        close(FH);
