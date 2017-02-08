<cfscript>
	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// These would normally go in some sort of onApplicationLoad or onSiteStart event handler...
	$.getServiceFactory().declareBean( beanName='Musician', 
									   dottedPath='ormdemos.model.Musician', 
									   isSingleton=false );
	$.getBean( 'Musician' ).checkSchema(); // if the Musician object's DB table hasn't been created, do so now...


	/* Here's the Real World Stuff...kind of... */

	objMusician = $.getBean( "Musician" );

	objMusician.setName( "David Bowie" );
	objMusician.setAge( 70 );

	objMusician.save();

</cfscript>