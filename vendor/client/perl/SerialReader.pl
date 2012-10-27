#!/usr/bin/perl -w

# For Linux uncomment the following 3 lines
#use Device::SerialPort;
use Win32::SerialPort;
use Fcntl qw(LOCK_EX LOCK_NB);
use File::NFSLock;
use NodeReceptor;

use Fcntl ':flock';
open my $self, '<', $0 or die print "Couldn't open self: $!";
flock $self, LOCK_EX | LOCK_NB or die print "This script is already running";

print "Serial Receptor runing";


#otras formas de control
# Try to get an exclusive lock on myself.
#my $lock = File::NFSLock->new($0, LOCK_EX|LOCK_NB);
#die "$0 is already running!\n" unless $lock;

#use File::Pid;
#my $pidfile = File::Pid->new({file => /var/run/myscript});
#exit if $pidfile->running();
#$pidfile->write();
#$pidfile->remove();

#escribir el pid en un archivo cuando largo
#controlar el pid si esta corriendo
#$rv = `ps -ef | grep onlyone.pl`;
#if ($rv == onlyone.pl) die;

#ver si esta corriendo en terminal
#http://perl.plover.com/yak/commands-perl/samples/slide016.html

#my $port_n ="/dev/ttyUSB0";
#my $port_obj = new Device::SerialPort ($port_n) || die " Can't open $port_n $!";
my $port_n ="COM7";
my $port_obj = new Win32::SerialPort ($port_n) || die " Can't open $port_n $!";

#Serial port Parameters
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

#TODO: agregar control para que corra solo una instancia
#TODO: agregar control para que otro programa pueda ver si esta corriendo este script 
while (1) {
    # Poll to see if any data is coming in
    my $msg = $port_obj->lookfor();
    # If we get data
    if ($msg) {
        print "Recieved: " . $msg . " \n";
        $receptor->receiveData($msg);
    }
    sleep(1);
}

#$check = $$;
#print "This script is '$$'\n";
#$running = `ps -A`;
#if( $running =~ /^{$check}\s/){
#  print "It's running";
#}else{
#  print "It's not running";
#}


#otro
#use POSIX;
# my $pid = shift;
# die "usage: check_process.pl pid\n" unless defined $pid; 
# print "Process ($pid) is ",(kill(SIGCHLD,$pid)!=0)?'running':'not running';