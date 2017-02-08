component extends="mura.bean.beanORM" entityName="Athlete" table="nre_athlete"  
{
	property name="AthleteID" fieldtype="id"; // primary key

	property name="AthleteName" type="string" required="true";
	property name="salary" type="integer" required="false";

	property name="SportsTeam" required="true" length="35" fieldtype="many-to-one" cfc="SportsTeam" fkcolumn="SportsTeamID";
}
