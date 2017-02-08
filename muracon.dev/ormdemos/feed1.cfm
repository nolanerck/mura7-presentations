<cfscript>
	// Using the older Mura 6 Feed syntax...

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );


	musician = $.getBean( "Musician" ).getFeed().addParam( field = "Name",
														   criteria = "David",
														   condition = "contains",
														   relationship = "and"
														 ).getQuery();

	WriteDump( musician );

</cfscript>