#!/usr/bin/perl -w

use Win32::SerialPort;
use Fcntl qw(LOCK_EX LOCK_NB);
use File::NFSLock;
use Fcntl ':flock';

open my $self, '<', $0 or die print "Couldn't open self: $!";
flock $self, LOCK_EX | LOCK_NB or die print "This script is already running";

#print "Cartel Writer runing";
my $port_n ="COM2";
my $port_obj = new Win32::SerialPort ($port_n) || die " Can't open $port_n $!";

#Serial port Parameters
$baud_rate=9600;
$port_obj->databits(8);
$port_obj->handshake("none");
$port_obj->baudrate($baud_rate);
$port_obj->parity("none");
$port_obj->stopbits(2);
$port_obj->write_settings || die "Cannot write settings";

#cartel character parameters
@numbers=(0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39);
$guion =  0x2D;
$esp =  0x20;
$vel = 0xAF;

#leo las vacas en celo del archivo
$app_dir = "C:/TrackTambo/TrackCentral/";
$celosFileName = $app_dir . "log/celos.log";
#@celos = [];
#if (-e $celosFileName){
#	open FILE, "<",$celosFileName or die $!;
#	@celos = <FILE>;
#	close FILE;
#}
@celos = @ARGV;

#inicio del mensaje defino letra, velocidad y animacion
$output = pack('C*', 0x99, 0xF5, 0x10, 0x14, 0x97, 0xA5, 0xCA, $vel);
$port_obj->write($output);

#imprimo las caravanas de las vacas en celo
if(@celos >= 1){
	foreach (@celos)
	{
		chomp;
		@carv = $_ =~ /\d{1}/g;
		$output = pack('C*', $esp);
		$port_obj->write($output);
		if(@carv >=3){
			if(@carv==4){
		    	$output = pack('C*', $numbers[$carv[0]],$numbers[$carv[1]],$numbers[$carv[2]],$numbers[$carv[3]]);
			}else{
				$output = pack('C*', $numbers[$carv[0]],$numbers[$carv[1]],$numbers[$carv[2]]);
			}
			$port_obj->write($output);
			$output = pack('C*', $esp,$guion);
			$port_obj->write($output);
		}
	}
}else{
	$output = pack('C*', $esp);
	$port_obj->write($output);
}

#fin del mensaje
$output = pack('C*', 0xF1, 0xF1, 0xF1);
$port_obj->write($output);

$port_obj->close || die "failed to close";
undef $port_obj;                               # frees memory back to perl
