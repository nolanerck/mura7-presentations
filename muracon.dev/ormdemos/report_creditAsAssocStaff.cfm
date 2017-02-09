<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "muracon" );

	qryContentWithNoAuthor = $.getBean( 'contentBean' )
								.getFeed( "content" )
								.where().prop( 'credits' )
								.isEQ( "null" )
								.maxItems( 0 ).getQuery();
</cfscript>

<cfoutput>
	<h2>Pages With No Author (#qryContentWithNoAuthor.recordCount# pages):</h2>

	<ul>
		<cfloop query="qryContentWithNoAuthor">
			<li>#qryContentWithNoAuthor.Title#</li>
		</cfloop>
	</ul>

</cfoutput>