package NodeReceptor;
      
use strict; #obliga a declarar las variables antes de usarlas
 
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
 
    
    #***********************************************************
    # constructor de la clase
    #***********************************************************
    sub new{       
        my $class = shift; #Averigua a que clase o package pertenece                         
        my $self={}; #Inicializamos la hash que contendrá las var. de instancia?     
        $self ->{NODES} = {}; #inicializo como hash vacio
        $self ->{NODES_HOUR} = {}; #inicializo como hash vacio
               
        $fileName = "Data_From_Collector.txt";
        
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
        
        if(@data_aux > 3){
             
            $accelSlow =  $data_aux[1];
            $accelMedium =  $data_aux[2];
            $accelFast =  $data_aux[3];
            $accelContn =  $data_aux[4];
            
            my $accel_data = $accelSlow.",".$accelMedium.",".$accelFast.",".$accelContn;
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
        
        print "End Dump from: " . $from_id . " \n";          
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
            print FH "Start,".$from_id . ",".$hash_nodes_hr{$from_id}.",\n";
            
            my $i;
            for $i ( 0 .. $#{$hash_nodes{$from_id}} ) {
                print FH $hash_nodes{$from_id}[$i] . ",\n";
            }

            print FH "End,".$from_id . ",\n";
            close(FH);
        }
    }
    
    #***********************************************************
    #controla que el mensaje tenga formato valido de datos
    #***********************************************************
    sub validMsg {
        my $self = shift; #el primer parametro es la clase en si
       # return (($msgRecv =~ m/Params{/) && ($msgRecv =~ m/}EndParams/) && ($msgRecv =~ m/From/) && ($msgRecv =~ m/Cause/));
        return (($msgRecv =~ m/Params{/) &&  ($msgRecv =~ m/From/) && ($msgRecv =~ m/Cause/));
    }
    
    #***********************************************************
    # log de mensaje recibido con formato invalido
    #***********************************************************
    sub logBadMsg {
        my $self = shift; #el primer parametro es la clase en si
        my($day, $month, $year) = (localtime)[3,4,5];
        $month = sprintf '%02d', $month+1;
        $day   = sprintf '%02d', $day;
        my $logFileName = $year+1900 . $month . $day . "_NodeReceptor_Log.txt";
        
        open(FH, ">>","$logFileName");
        print FH $msgRecv . "\n";
        close(FH);
    }

1;