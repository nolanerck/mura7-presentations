<cfscript>
	// Using the older Mura 6 Feed syntax to return multiple records...

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// These would normally go in some sort of onApplicationLoad or onSiteStart event handler...
	$.getServiceFactory().declareBean( beanName='RockBand', 
									   dottedPath='ormdemos.model.RockBand', 
									   isSingleton=false );
	$.getBean( 'RockBand' ).checkSchema(); // if the RockBand object's DB table hasn't been created, do so now...

/*
	// first, let's put several records in the table...
	rb1 = $.getBean( "RockBand" );
	rb1.setBandName( "The Cure" );
	rb1.setYearFormed( 1977 );
	rb1.save();

	rb2 = $.getBean( "RockBand" );
	rb2.setBandName( "The Alkaline Trio" );
	rb2.setYearFormed( 1999 );
	rb2.save();

	rb3 = $.getBean( "RockBand" );
	rb3.setBandName( "The Spiders From Mars" );
	rb3.setYearFormed( 1975 );
	rb3.save();

	rb4 = $.getBean( "RockBand" );
	rb4.setBandName( "The Clash" );
	rb4.setYearFormed( 1978 );
	rb4.save();

	rb5 = $.getBean( "RockBand" );
	rb5.setBandName( "Depeche Mode" );
	rb5.setYearFormed( 1980 );
	rb5.save();

	rb6 = $.getBean( "RockBand" );
	rb6.setBandName( "Erasure" );
	rb6.setYearFormed( 1985 );
	rb6.save();
*/	

	// okay, NOW we can search for any "The " bands...
	rbIterator = $.getBean( "RockBand" ).getFeed().addParam( field = "BandName",
																	criteria = "The ",
																	condition = "contains",
																	relationship = "and"
																 ).getIterator();

	while( rbIterator.hasNext() )
	{
		rb = rbIterator.next();

		WriteOutput( "Band Name: " & rb.getBandName() & "<br />" );
	}


</cfscript>