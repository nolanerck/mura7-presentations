<cfscript>
	// Using the older Mura 6 Feed syntax to return multiple records...

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// okay, NOW we can search for any "The " bands...
	// AND that were formed after 1976
	rbIterator = $.getBean( "RockBand" ).getFeed().addParam( field = "BandName",
																	criteria = "The ",
																	condition = "contains",
																	relationship = "and"
																 )
													.addParam( field = "YearFormed",
															   criteria = "1976",
															   condition = "gte",
															   relationship = "and"
													 ).getIterator();
	/* I dunno about you but stacking multiple addParam() calls starts
	   getting pretty verbose. There's gotta be a better way! */


	while( rbIterator.hasNext() )
	{
		rb = rbIterator.next();

		WriteOutput( "Band Name: " & rb.getBandName() & "<br />" );
	}


</cfscript>