<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "muracon" );

	contentIterator = $.getBean( 'contentBean' )
								.getFeed( "content" )
								.where().prop( 'credits' )
								.isEQ( "null" )
								.setMaxItems( 0 ).getIterator();
</cfscript>

<cfoutput>
	<h2>Pages With No Author (#contentIterator.getRecordCount()# pages):</h2>

	<ul>
		<cfloop condition="contentIterator.hasNext()">
			<cfset page = contentIterator.next() />
			<li>#page.getTitle()#</li>
		</cfloop>
	</ul>
</cfoutput>

<!--- Now let's fix that... --->

<cfscript>
	contentIterator.reset(); // restart the iterator at the beginning.

	while( contentIterator.hasNext() )
	{
		page = contentIterator.next();
		page.setCredits( "Associated Staff" );
		page.save();
	}
</cfscript>

<cfoutput>
	<h2>Pages With No Author After Processing:</h2>

	<ul>
		<cfloop condition="contentIterator.hasNext()">
			<cfset page = contentIterator.next() />
			<li>#page.getTitle()#</li>
		</cfloop>
	</ul>
</cfoutput>