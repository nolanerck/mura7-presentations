component extends="mura.bean.beanORM" entityName="SportsTeam" table="nre_sportsteam"  
{
	property name="SportsTeamID" fieldtype="id"; // primary key

	property name="TeamName" type="string" required="true";
	property name="League" type="string" required="false";

}
