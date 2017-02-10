<cfoutput>
	<div class="punk-band-width-wrapper" id="js-punk-band-wrapper">
		#$.dspObject( object='punk_band_generator' )#
	</div>

	<div>
		<button class="btn btn-info" id="btnRefresh">Refresh</button>
		<button class="btn btn-primary" id="btnNewBand">Get Another Band</button>
	</div>

</cfoutput>

<script>
	m( "#btnRefresh" ).click( function(evt)
	{
		alert( "refresh button" );
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