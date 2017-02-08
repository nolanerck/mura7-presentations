<cfscript>
	// Creating records via ORM

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// create 3 new musicians and add them to the database
	m1 = $.getBean( "Musician" );
	m1.setName( "Les Claypool" );
	m1.setInstrument( "Bass" );
	m1.setAge( 51 );
	m1.save();

	m2 = $.getBean( "Musician" );
	m2.setName( "Larry Lalonde" );
	m2.setInstrument( "Guitar" );
	m2.setAge( 48 );
	m2.save();

	m3 = $.getBean( "Musician" );
	m3.setName( "Tim Alexander" );
	m3.setInstrument( "Drums" );
	m3.setAge( 49 );
	m3.save();	


</cfscript>