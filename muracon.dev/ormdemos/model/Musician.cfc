component extends="mura.bean.beanORM" entityName="Musician" table="nre_musician"  
{
	property name="MusicianID" fieldtype="id"; // primary key

	property name="Name" type="string" required="true";
	property name="Age" type="numeric" required="false";
	property name="Instrument" type="string" required="false";
	
	//property name="YearsExperience" type="numeric" required="false";
}
