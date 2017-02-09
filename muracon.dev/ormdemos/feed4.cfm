<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// okay, NOW we can search for any "The " bands...
	// AND that were formed after 1976
	rbIterator = $.getBean( "RockBand" ).getFeed()
										.where()
										.prop( "BandName" )
										.containsValue( "The " )
										.andProp( "YearFormed" )
										.isGTE( 1976 )
										.getIterator();

	while( rbIterator.hasNext() )
	{
		rb = rbIterator.next();

		WriteOutput( "Band Name: " & rb.getBandName() & "<br />" );
	}


</cfscript>