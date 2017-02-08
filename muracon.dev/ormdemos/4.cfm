<cfscript>
	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// update an existing record...

	m1 = $.getBean( "Musician" ).loadBy( Name="David Bowie" );

	m1.setName( "David Jones" );
	m1.save();

</cfscript>