<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// okay, NOW we can search for any "The " bands...
	// AND that were formed after 1976
	iterator = $.getBean( "Musician" ).getFeed().where()
				.prop( "Name" )
				.isEQ( "Les Claypool" )
				.getIterator();
	/* I dunno about you but stacking multiple addParam() calls starts
	   getting pretty verbose. There's gotta be a better way! */


	while( iterator.hasNext() )
	{
		m = iterator.next();

		WriteOutput( "Name: " & m.getName() & "<br />" );
	}


</cfscript>