use Win32::Daemon;

    # Tell the OS to start processing the service...
    Win32::Daemon::StartService();

    # Wait until the service manager is ready for us to continue...
    while( SERVICE_START_PENDING != Win32::Daemon::State() )
    {
        sleep( 1 );
    }

    # Now let the service manager know that we are running...
    Win32::Daemon::State( SERVICE_RUNNING );

    print "servicio corriend \n";
    # Okay, go ahead and process stuff...
    #unlink( glob( "c:\\temp\\*.tmp" ) );
    while(1){

    }
    
    # Tell the OS that the service is terminating...
    Win32::Daemon::StopService();