#!/usr/bin/perl -w

use NodeReceptor;

# For Linux or windows uncomment 
use Device::SerialPort;
#use Win32::SerialPort;

#**********************************
#Control proccess running
#**********************************
#For windows uncomment 
#use Fcntl qw(LOCK_EX LOCK_NB);
#use File::NFSLock;
#use Fcntl ':flock';
#open my $self, '<', $0 or die "Couldn't open self: $!";
#flock $self, LOCK_EX | LOCK_NB or die "This script is already running";

# For linux uncomment
#si el archivo con opid existe, obtengo el valor y controlo si esta corriendo
my $line_pid;
$filename_pid = '/home/tracktambo/TrackCentral/tmp/pids/serialreader.pid';

 if (-e $filename_pid) {
   open(FH, "<","$filename_pid");
   @lines = <FH>;
   $line_pid = $lines[0];
   chomp($line_pid);
   close(FH);
   #print "pid from file " . $line_pid ."\n";
   $exists = kill 0, $line_pid;
   die print "Process is running\n" if ( $exists );
 } 
 
#guardo archivo con el pid del proceso corriendo
$check = $$;
open(FH, ">","$filename_pid");
print FH $check . "\n";
close(FH);

#**********************************
#Serial port Parameters
#**********************************

#uncomment depend of linux or windows
my $port_n ="/dev/ttyACM0";
my $port_obj = new Device::SerialPort ($port_n) || die " Can't open $port_n $!";
#my $port_n ="COM7";
#my $port_obj = new Win32::SerialPort ($port_n) || die " Can't open $port_n $!";
$baud_rate=9600;
$port_obj->databits(8);
$port_obj->handshake("none");
$port_obj->baudrate($baud_rate);
$port_obj->parity("none");
$port_obj->stopbits(1);
$port_obj->buffers(4096,4096);

# This is the essential step
$port_obj->write_settings || die "Cannot write settings";

$receptor = NodeReceptor->new();

print "Serial Receptor runing ...\n";

while (1) {
    # Poll to see if any data is coming in
    my $msg = $port_obj->lookfor();
    # If we get data
    if ($msg) {
        #print "Recieved: " . $msg . " \n";
        $receptor->receiveData($msg);
    }
    #sleep(1);
}

#elimino archivo con pid porque el programa termino
unlink($filename_pid); 

#ver si esta corriendo en terminal
#http://perl.plover.com/yak/commands-perl/samples/slide016.html
