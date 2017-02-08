<!--- set some defaults for the first time this page loads, and these might be changed by whatever
	  the page is that's using this Display Object --->
<cfparam name="objectParams.songCountPerPage" default="10" type="numeric" /> <!--- How many Songs are we drawing on this page? --->
<cfparam name="objectParams.bInfiniteScroll" default="false" type="boolean" />
<cfparam name="objectParams.articleSortByColumn" default="releaseDate" />
<cfparam name="objectParams.articleSortByDirection" default="DESC" />
<cfparam name="objectParams.currentPage" default="1" type="numeric" />

<cfset songSvc = $.getBean( "SongService" ) />


<cfset args = {
				$ = $,
				siteid = $.content( 'siteid' ),
				contentparentid = "#$.getBean('content').loadBy(filename='songs').getContentID()#" <!--- the "Songs" Folder ID, where all the songs live. --->
			  } />

<cfset songIterator = songSvc.getSongs( argumentCollection=args ) />

<!--- which page are we drawing this time? --->
<cfset songIterator.setNextN( objectParams.songCountPerPage ) />
<cfset songIterator.setPage( objectParams.currentPage ) />

<cfoutput>
	<cfloop condition="songIterator.hasNext()">
		<cfset song = songIterator.next() />

		#song.getTitle()#<br />

	</cfloop>
</cfoutput>


