<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "muracon" );

	iterPagesByAuthor = $.getBean( 'contentBean' )
								.getFeed( "content" )
								.maxItems( 0 ) // for SQL queries
								.setNextN( 100 )	// for iterators
								.sort( "Credits", "asc" ).getIterator();
</cfscript>

<cfoutput>
	<h2>Pages By Author:</h2>

	<ul>
		<cfloop condition="iterPagesByAuthor.hasNext()">
			<cfset page = iterPagesByAuthor.next() />

			<li>#page.getTitle()# (#page.getCredits()#)</li>
		</cfloop>
	</ul>

</cfoutput>