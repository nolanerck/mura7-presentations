<cfscript>
	// Mura 7 Feed API

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "muracon" );

	qryContentWithAssocImsgs = $.getBean( 'contentBean' )
								.getFeed( "content" )
								.where().prop( 'fileid' )
								.isEQ( "null" )
								//.sort( "Title", "ASC" )
								.maxItems( 0 ).getQuery();
</cfscript>

<cfoutput>
	<h2>Pages Missing Associated Images:</h2>

	<ul>
		<cfloop query="qryContentWithAssocImsgs">
			<li>#qryContentWithAssocImsgs.Title#</li>
		</cfloop>
	</ul>

</cfoutput>