<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "muracon" );

	numOfPages = $.getBean( 'contentBean' ).getFeed( "content" ).maxItems( 0 ).getQuery().recordCount;

	WriteOutput( "Number of live pages: " & numOfPages );

</cfscript>