<cfset myArgs = {} />
<cfset myArgs.artistName = "Green Day" />

<cfoutput>
	<h1>Display Objects with parameters</h1>

	<div class="listen-to-widget-wrapper">
		#$.dspObject( object='ListenToWidget', objectParams=myArgs )#
	</div>
</cfoutput>