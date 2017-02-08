component extends="mura.bean.beanORM" entityName="RockBand" table="nre_rockbands"  
{
	property name="RockBandID" fieldtype="id"; // primary key

	property name="BandName" type="string" required="true";
	property name="YearFormed" type="integer" required="false";
	property name="Genre" type="string" required="false";
}
