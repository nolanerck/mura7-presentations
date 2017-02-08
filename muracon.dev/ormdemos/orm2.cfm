<cfscript>
	// Loading a record/object

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	objMusician = $.getBean( "Musician" ).loadBy( Name="David Bowie" );;

	WriteDump( objMusician );


</cfscript>