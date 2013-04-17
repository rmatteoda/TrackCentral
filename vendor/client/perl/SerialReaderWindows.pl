#!/usr/bin/perl -w

use NodeReceptor;
use Win32::SerialPort;

#**********************************
#Control proccess running
#**********************************
use Fcntl qw(LOCK_EX LOCK_NB);
use File::NFSLock;
use Fcntl ':flock';
open my $self, '<', $0 or die "Couldn't open self: $!";
flock $self, LOCK_EX | LOCK_NB or die "This script is already running";

#sleep(30);
my $port_n ="COM3";
my $port_obj = new Win32::SerialPort ($port_n) || die " Can't open $port_n $!";

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
}
