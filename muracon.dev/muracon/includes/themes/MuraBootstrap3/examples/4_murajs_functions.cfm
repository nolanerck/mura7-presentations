<cfoutput>
	<div class="punk-band-width-wrapper" id="js-punk-band-wrapper">
		#$.dspObject( object='punk_band_generator' )#
	</div>

	<div>
		<button class="btn btn-default" id="btnEmpty">Empty the Display Object</button>
		<button class="btn btn-info" id="btnRefresh">Refresh</button>
		<button class="btn btn-primary" id="btnAppendBand">Append Another Band</button>
	</div>

</cfoutput>

<script>
	m(function()
	{	
		// reference to the actual "thing" (display object) that we're passing data to
		var pContainer = m( "#js-punk-band-wrapper .mura-object" );

		// turn on the client-side Mura.js hooks
		pContainer.data( 'async', true );

		// empty button
		m( "#btnEmpty" ).click( function(evt)
		{
			evt.preventDefault();

			m( "#js-punk-band-wrapper" ).empty();
		});

		// refresh button
		m( "#btnRefresh" ).click( function(evt)
		{
			evt.preventDefault();

			// get a reference to the "metadata" for this display object
			var myData = pContainer.data();

			// remove the "old" display object
			m( "#js-punk-band-wrapper" ).empty();

			// refresh with a new copy
			m( "#js-punk-band-wrapper" ).appendDisplayObject( myData );

		});
	});

<!---	m( ".js-pagelink" ).click(function(evt)
	{
		evt.preventDefault();

		var pContainer = m('##article-container .mura-object:last-child');

		// which page number was clicked?
		var _pageNum = $(this).data( "pagenumber" );
		pContainer.data( "currentPage", _pageNum );

		m( "##article-container" ).empty();
		m( "##article-container" ).appendDisplayObject( pContainer.data() ).then( function()
																				  {
																					eqjs.all();
																					window.scrollTo(0, 0);
																				  });

	});
--->
</script>