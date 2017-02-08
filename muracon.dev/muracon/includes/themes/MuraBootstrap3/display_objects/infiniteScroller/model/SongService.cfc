<cfcomponent extends="mura.cfobject">
	
	<cffunction name="init" returntype="SongService">
		<cfreturn this />
	</cffunction>
		
	<cffunction name="getSongs" output="false" returntype="any" access="public">
        <cfargument name="$" />
        <cfargument name="siteid" />
        <cfargument name="contentparentid" default="" />
        <cfargument name="orderBy" default="tcontent.title" />
        <cfargument name="orderByDirection" required="false" default="ASC" />

        <cfset var tableModifier = ($.globalConfig('dbtype') eq 'MSSQL') ? "with (nolock)" : "" />

        <cfset var rs = "" />

        <cfquery name="rs" cachedWithin="#createTimeSpan(0,0,5,0)#">
            SELECT tcontent.siteid, tcontent.title, tcontent.menutitle, tcontent.restricted, tcontent.restrictgroups,
                    tcontent.type, tcontent.subType, tcontent.filename, tcontent.displaystart, tcontent.displaystop,
                    tcontent.remotesource, tcontent.remoteURL,tcontent.remotesourceURL, tcontent.keypoints,
                    tcontent.contentID, tcontent.parentID, tcontent.approved, tcontent.isLocked, tcontent.contentHistID,tcontent.target, tcontent.targetParams,
                    tcontent.releaseDate, tcontent.lastupdate,tcontent.summary,
                    tcontent.fileid,
                    tcontent.tags,tcontent.credits,tcontent.audience, tcontent.orderNo,
                    tparent.type parentType, null as kids,
                    tcontent.path, tcontent.created, tcontent.nextn, tcontent.majorVersion, tcontent.minorVersion,
                    tcontent.expires,
                    tcontent.displayInterval,tcontent.display,
                    tcontent.changesetid ,tcontent.body
            FROM tcontent
            LEFT JOIN tcontent tparent #tableModifier# ON (tcontent.parentid=tparent.contentid
                AND tcontent.siteid=tparent.siteid
                AND tparent.active=1)
            WHERE
            tcontent.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteid#">
            #$.getBean('contentGateway').renderActiveClause('tcontent',arguments.siteid,1,1)#
            AND tcontent.isNav = 1
            AND tcontent.moduleid = '00000000000000000000000000000000000'
            <cfif len(arguments.contentparentid)>
               AND tcontent.parentid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.contentparentid#"/>)
           </cfif>

            <cfif Len( Trim( arguments.orderBy ) )>
				ORDER BY #arguments.orderBy# #arguments.orderByDirection#
            </cfif>
        </cfquery>
        
        <cfreturn 	getBean('contentIterator').setQuery(rs)>
    </cffunction>

</cfcomponent>