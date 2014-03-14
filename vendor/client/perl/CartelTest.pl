#!/usr/bin/perl -w

print "celos " . $ARGV[0] . "\n";
print "celos " . $ARGV[1] . "\n";

#leo las vacas en celo del archivo
#$app_dir = "/Users/ramiro/Workspace/workspace_ror/TrackCentral/";
$celosFileName = '/Users/ramiro/Workspace/workspace_ror/TrackCentral/log/celos.log';

@celos = [];
if (-e $celosFileName){
	open (FILE, '<' ,$celosFileName) or die $!;
	@celos = <FILE>;
	close FILE;
}

#inicio del mensaje defino letra, velocidad y animacion
print "mando al inicio\n";

@celos = @ARGV;
#imprimo las caravanas de las vacas en celo
if(@celos >= 1){
	foreach (@celos)
	{
		chomp;
		@carv = $_ =~ /\d{1}/g;
		if(@carv >=3){
			if(@carv==4){
		    	$output = $carv[3];
			}else{
				$output = $carv[2];
			}
			print "mando car : " . $output . "\n";
		}
	}
}else{
	print "mando espacio\n";
}

