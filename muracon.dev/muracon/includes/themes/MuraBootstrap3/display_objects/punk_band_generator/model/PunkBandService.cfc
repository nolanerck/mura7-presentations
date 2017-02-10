<cfcomponent>

	<cffunction name="init" returntype="PunkBandService">
		<cfreturn this />
	</cffunction>

	<cffunction name="getRandomPunkBand" returntype="string" access="public">
		<cfset var aryPunkBands = [ "Green Day", "The Clash", "7 Seconds", 
									"Operation Ivy", "SquirtGun", 
									"MXPX", "H2O",
									"Tilt", "The Riverdales" ] />

		<cfset var bandIdx = randRange( 1,  ArrayLen( aryPunkBands ) ) />

		<cfreturn aryPunkBands[ bandIdx ] />
	</cffunction>

</cfcomponent>