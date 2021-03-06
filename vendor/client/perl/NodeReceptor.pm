package NodeReceptor;
      
use strict; #obliga a declarar las variables antes de usarlas
#use Fcntl qw(:flock SEEK_END);
 
#***********************************************************
# declaracion de variables globales
#***********************************************************    
 my @data_collected;
 my %hash_nodes;
 my %hash_nodes_hr;
 my $msgRecv;
 my @data_tmp;
 my @data_aux;
 my $msg_tmp;
 my $from_id;
 my $last_hour;
 my $accelSlow;
 my $accelMedium;
 my $accelFast;
 my $accelContn;
 my $fileName;
 my $app_dir;
    
    #***********************************************************
    # constructor de la clase
    #***********************************************************
    sub new{       
        my $class = shift; #Averigua a que clase o package pertenece                         
        my $self={}; #Inicializamos la hash que contendrá las var. de instancia?     
        $self ->{NODES} = {}; #inicializo como hash vacio
        $self ->{NODES_HOUR} = {}; #inicializo como hash vacio
               
        #$app_dir = "/home/tracktambo/TrackCentral/";
        #$fileName = $app_dir . "public/data_from_collector.txt";
        $app_dir = "C:/TrackTambo/TrackCentral/";
        $fileName = $app_dir . "public/data_from_collector.txt";
        
        bless $self , $class; #Perl asocia la referencia $self con la clase que corresponde
        return $self; #retornamos la instancia de la clase                                 
    }      
    
    #***********************************************************
    # destructor de la clase
    #***********************************************************
    sub DESTROY { #puede no estar definido
        my $self=shift; 
        delete ($self ->{NODES});   
        delete ($self ->{NODES_HOUR});   
    }
    
    #***********************************************************
    #recibir datos, valida mensaje,
    #parsea datos y guardar hasta poder hacer dump
    #***********************************************************
    sub receiveData {
        my $self = shift;
        
        if (@_) {#controlo si se paso el mensaje como parametro
          $msgRecv = $_[0];
          if(&validMsg){
            if(($msgRecv =~ m/Start_Dump/)){
                &causeStart;
            }elsif(($msgRecv =~ m/End_Dump/)){
                &causeEnd;
            }elsif(($msgRecv =~ m/Dump_Memory/)){
                &causeDump;
            }elsif(($msgRecv =~ m/Init_Connect/)){
                &logInitMsg;
            }elsif(($msgRecv =~ m/Test_Connect/)){
                &logTestMsg;
            }else{
                &logBadMsg;
            }
          }else{
            &logBadMsg;
          }
        }
    }
    
    #***********************************************************
    #recibe datos de start desde nodo,
    #inicializo variables de almacenamiento
    #guardo las horas pasadas desde ultimo envio
    #***********************************************************
    sub causeStart {
        my $self = shift;
        
        @data_tmp = split(/,/,$msgRecv);
        @data_aux = split(/=/,$data_tmp[0]);
        $from_id = $data_aux[1];
        
        #inicializo referencia de array donde guarda los valores recibidos
        $hash_nodes{$from_id} = ();
        
        #save hour past from last dump data
        @data_aux = split(/:/,$data_tmp[3]);
        $hash_nodes_hr{$from_id} = $data_aux[1];       
    }
    
    #***********************************************************
    #recibe datos de aceleracion desde nodo,
    #obtengo valores desde el mensaje y almaceno 
    #***********************************************************
    sub causeDump {
        my $self = shift;
        
        @data_tmp = split(/,/,$msgRecv);
        @data_aux = split(/=/,$data_tmp[0]);
        $from_id = $data_aux[1];
        
        #obtengo los valores de aceleracion desde el mensaje recibido
        @data_aux = split(/:/,$data_tmp[3]);
        
        if(@data_aux > 1){
              
            #*** NUEVO MODELO ****
            my $accel_data = "";
            my $ind = 1;
            for($ind = 1 ; $ind < $#data_aux; $ind = $ind +1){
                $accel_data = $accel_data. $data_aux[$ind].",";
            }
            # print "accel data save : " . $accel_data  . " \n";
            #chop($accel_data);
            push @{$hash_nodes{$from_id}}, $accel_data;
         }#TODO: log error sino pasa esto
    }
    
    #***********************************************************
    #recibe mensaje de end desde el nodo,
    #controla datos y los guarda en archivo
    #***********************************************************
    sub causeEnd {
        my $self = shift; 
        @data_tmp = split(/,/,$msgRecv);
        @data_aux = split(/=/,$data_tmp[0]);
        $from_id = $data_aux[1];
        &dumpData;   
        $hash_nodes{$from_id} = ();
    }
    
    #***********************************************************
    #cuando recibo mensaje de end desde un nodo,
    #guarda datos en archivo segun formato acordado
    #***********************************************************
    sub dumpData {
        my $self = shift;
            
        #controlo si existe el nodo en la hash
        if($hash_nodes{$from_id}){
            open(FH, ">>",$fileName);
            #flock(FH,2);

            print FH "Start,". $from_id . "," . $hash_nodes_hr{$from_id} . ",\n";
            #print FH "Start,".$from_id . ",0,\n";
            
            my $i;
            my $last = $#{$hash_nodes{$from_id}};
            for $i ( 0 .. $#{$hash_nodes{$from_id}} ) {
                print FH $hash_nodes{$from_id}[$i];#RM 11-01-2013
            }

            print FH "\n";
            print FH "End,".$from_id . ",\n";

            #flock(FH, LOCK_UN);

            close(FH);
            &logDumpMsg;
        }
    }
    
    #***********************************************************
    #controla que el mensaje tenga formato valido de datos
    #***********************************************************
    sub validMsg {
        my $self = shift; #el primer parametro es la clase en si
        return (($msgRecv =~ m/Params{/) && ($msgRecv =~ m/}EndParams/) && ($msgRecv =~ m/From/) && ($msgRecv =~ m/Cause/));
    }
    
    #***********************************************************
    # log de mensaje de inicio de coneccion 
    #***********************************************************
    sub logInitMsg {
        my $self = shift; #el primer parametro es la clase en si
        my $logFileName = $app_dir . "log/Init_Nodes_Log.txt";
        
        open(FH, ">>","$logFileName");
        print FH $msgRecv . "\n";
        close(FH);
    }

    #***********************************************************
    # log de mensaje de test de coneccion 
    #***********************************************************
    sub logTestMsg {
        my $self = shift; #el primer parametro es la clase en si
        my $logFileName = $app_dir . "log/Test_Connect_Log.txt";
        my($seg, $minute, $hour, $day, $month) = (localtime)[0,1,2,3,4];
        
        open(FH, ">>","$logFileName");
        print FH " hour  " . $hour. ":" .$minute. ":" .$seg . " -- " . $msgRecv;
        close(FH);
    }

    #***********************************************************
    # log de registro de dump 
    #***********************************************************
    sub logDumpMsg {
        my $self = shift; #el primer parametro es la clase en si
        my $logFileName = $app_dir . "log/Dump_Nodes_Log.txt";
        my($seg, $minute, $hour, $day, $month) = (localtime)[0,1,2,3,4];
        
        open(FH, ">>","$logFileName");
        print FH "dump from " . $from_id . " day ". $day . " hour  ".$hour.":".$minute.":".$seg ."\n";
        close(FH);
    }

    #***********************************************************
    # log de mensaje recibido con formato invalido
    #***********************************************************
    sub logBadMsg {
        my $self = shift; #el primer parametro es la clase en si
        my($day, $month, $year) = (localtime)[3,4,5];
        $month = sprintf '%02d', $month+1;
        $day   = sprintf '%02d', $day;
        my $logFileName = $app_dir . "log/" . ($year+1900) . $month . $day . "_NodeReceptor_Log.txt";
        
        open(FH, ">>","$logFileName");
        print FH $msgRecv . "\n";
        close(FH);
    }

1;
