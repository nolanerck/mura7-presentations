<cfset objBandService = $.getBean( "PunkBandService" ) />
<cfset strBandName = objBandService.getRandomPunkBand() />

<cfoutput>
	<p>Punk Band Selected: #strBandName#</p>
	<p>Rendered at #Now()#</p>
</cfoutput>
