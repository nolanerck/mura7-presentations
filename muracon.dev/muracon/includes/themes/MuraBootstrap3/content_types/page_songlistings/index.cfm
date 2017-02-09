<cfoutput>
	<h1>David Bowie forever...</h1>

	<div id="song-container">
		#$.dspObject( object='infiniteScroller', objectParams=objectParams )#
	</div>
</cfoutput>

<script>

	m(function()
	{
		windowScroll_handler = function()
		{	
			var heightOfFooter = $( "#js-footer-wrapper" ).height();

			// only activate infinite scroll once per "swipe of a reasonable size"	
			if( $(document).height() - win.height() - heightOfFooter - 100 <= win.scrollTop() )
			{
				win.off( "scroll", windowScroll_handler );				
						
				// for pages 2 and beyond we need to actually do the fancy infinite scrolling logic.
				var data = m( "#song-container .mura-object:last-child" ).data();

				// if we have more pages of content to draw...
				if( data.currentpage < data.numberofpages )
				{
					currentPage = currentPage + 1;

					m.extend( data, { songCountPerPage : 10, // how many new songs appear when we scroll?
									  currentPage : currentPage,
									  bInfiniteScroll : true } );

					m( "#song-container" ).appendDisplayObject( data ).then( function(){ win.on( "scroll", windowScroll_handler ); } );
				}
			}
		}

		// reference to the actual "thing" (display object) that we're passing data to
		var pSongListing = m( "#song-container .mura-object" );

		pSongListing.data( 'async', true );

		var currentPage = 1;

		var win = $(window);
		win.on( "scroll", windowScroll_handler );		

	});
</script>
