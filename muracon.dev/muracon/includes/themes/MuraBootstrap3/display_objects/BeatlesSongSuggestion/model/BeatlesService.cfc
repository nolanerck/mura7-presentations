<cfcomponent>

	<cffunction name="init" returntype="BeatlesService" access="public">
		<cfreturn this />
	</cffunction>

	<cffunction name="getBeatlesSong" returntype="string" access="public">
		<cfset var aryBeatlesSongs = [ "Help", "Sgt Pepper", "Lucy In The Sky With Diamonds", "Day Tripper", "Blackbird",
								   "8 Days A Week", "For The Benefit of Mr Kite"
								 ] />

		<cfset var songIdx = randRange( 1, ArrayLen( aryBeatlesSongs ) ) />

		<cfreturn aryBeatlesSongs[ songIdx ] />
	</cffunction>

</cfcomponent>