<cfscript>

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// delete an existing musician...
	m1 = $.getBean( "Musician" ).loadBy( Name="Tim Alexander" );
	m1.delete();

</cfscript>