
					m( ".js-pagelink" ).click(function(evt)
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