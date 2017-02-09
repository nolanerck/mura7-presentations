<cfscript>
	// Joins...

	// because I'm not in a Mura page, we need access to the $ scope
	$ = application.serviceFactory.getBean( "muraScope" ).init( "default" );

	// These would normally go in some sort of onApplicationLoad or onSiteStart event handler...
	$.getServiceFactory().declareBean( beanName='SportsTeam', dottedPath='ormdemos.model.SportsTeam', isSingleton=false );
	$.getServiceFactory().declareBean( beanName='Athlete', dottedPath='ormdemos.model.Athlete', isSingleton=false );

	$.getBean( 'SportsTeam' ).checkSchema(); // if this object's DB table hasn't been created, do so now...	
	$.getBean( 'Athlete' ).checkSchema();

	// make some sportsball teams...
	team1 = $.getBean( "SportsTeam" );
	team1.setTeamName( "Bad News Bears" );
	team1.setLeague( "MLB" );
	team1.save();

	team2 = $.getBean( "SportsTeam" );
	team2.setTeamName( "Mighty Ducks" );
	team2.setLeague( "NHL" );
	team2.save();

	team3 = $.getBean( "SportsTeam" );
	team3.setTeamName( "Plan B" );
	team3.setLeague( "SLS" );
	team3.save();	

	ath1 = $.getBean( "Athlete" );
	ath1.setAthleteName( "Babe Ruth" );
	ath1.setSalary( 500 );
	ath1.setSportsTeam( team1 );
	ath1.save();

</cfscript>

<cfoutput>
	<p>Player Name: #ath1.getAthleteName()#</p>
	<p>His/Her Team: #ath1.getSportsTeam().getTeamName()#</p>
</cfoutput>