<cfoutput>
	<h2>Beatles Suggestion</h2>
	<div id="js-beatles-wrapper">
		#$.dspObject( object='BeatlesSongSuggestion' )#
	</div>

	<div>
		<input type="text" id="otherSuggestion" placeholder="Recommend another song" value="" />
		<button class="btn btn-primary" id="btnAppend">Append More Suggestions</button>
	</div>

</cfoutput>

<script>
	m(function()
	{	
		// reference to the actual "thing" (display object) that we're passing data to
		var pContainer = m( "#js-beatles-wrapper .mura-object:last-child" );

		// turn on the client-side Mura.js hooks
		pContainer.data( 'async', true );

		// refresh button
		m( "#btnAppend" ).click( function(evt)
		{
			evt.preventDefault();

			// get a reference to the "metadata" for this display object
			var myData = pContainer.data();

			var userProvidedSuggestion = m( "#otherSuggestion" ).val();

			// We're NOT removing a display object this time. We're just appending a NEW one below it...
			//m( "#js-beatles-wrapper" ).empty();

			if( userProvidedSuggestion.length > 0 )
			{
				// combine the last display object's data with whatever the user just typed in as a suggestion
				m.extend( myData, { "additionalSuggestion" : userProvidedSuggestion } );
			}

			// refresh with a new copy
			m( "#js-beatles-wrapper" ).appendDisplayObject( myData );
		});
	});
</script>
