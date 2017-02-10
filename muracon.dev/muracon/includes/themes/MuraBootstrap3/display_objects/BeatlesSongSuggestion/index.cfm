<cfparam name="objectParams.additionalSuggestion" default="" />

<cfset beatlesSvc = getBean( "BeatlesService" ) />
<cfset strSongName = beatlesSvc.getBeatlesSong() />

<cfoutput>
	<p>We recommend listening to: #strSongName#</p>

	<cfif Len( objectParams.additionalSuggestion )>
		<p>...and we also think you'll like #objectParams.additionalSuggestion#</p>
	</cfif>
</cfoutput>
