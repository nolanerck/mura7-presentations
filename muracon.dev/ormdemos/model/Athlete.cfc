component extends="mura.bean.beanORM" entityName="Athlete" table="nre_athlete"  
{
	property name="AthleteID" fieldtype="id"; // primary key

	property name="AthleteName" type="string" required="true";
	property name="Salary" type="integer" required="false";

}
