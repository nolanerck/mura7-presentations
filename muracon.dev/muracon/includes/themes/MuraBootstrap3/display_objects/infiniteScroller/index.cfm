<!--- set some defaults for the first time this page loads, and these might be changed by whatever
	  the page is that's using this Display Object --->
<cfparam name="objectParams.articleCountPerPage" default="10" type="numeric" /> <!--- How many Songs are we drawing on this page? --->
<cfparam name="objectParams.bInfiniteScroll" default="false" type="boolean" />
<cfparam name="objectParams.articleSortByColumn" default="releaseDate" />
<cfparam name="objectParams.articleSortByDirection" default="DESC" />
<cfparam name="objectParams.currentPage" default="1" type="numeric" />

<cfset songSvc = $.getBean( "SongService" ) />


<cfset args = {
				$ = $,
				siteid = $.content( 'siteid' ),
				contentparentid = "#$.getBean('content').loadBy(filename='songs').getContentID()#" <!--- the "Songs" Folder ID, where all the songs live. --->
			  } />

<cfset songIterator = songSvc.getSongs( argumentCollection=args ) />

<cfoutput>
	<cfloop condition="songIterator.hasNext()">
		<cfset song = songIterator.next() />

		NREDEBUG SONG TITLE: #song.getTitle()#<br />

	</cfloop>
</cfoutput>


<!---
<cfset articleSvc = $.getBean( "ArticleService" ) />


<cfset articleSummaryArgs = {
								$ = $,
								siteid = $.content('siteid'),
								contentparentid = "#$.getBean('content').loadBy(filename='content').getContentID()#", <!--- the "Content" Folder ID, where all the articles live. --->
								primarycategoryid = mainCategoryForThisLandingPage,
								secondarycategoryid = objectParams.secondarycategoryid, <!--- Category ID of the "_Tags" items that have also been selected for the given article(s) --->
								orderBy = objectParams.articleSortByColumn,
								orderByDirection = objectParams.articleSortByDirection,
								countryCategoryID = selectedCountryCategoryID
} />

<cfset articles   = articleSvc.getArticles( argumentCollection = articleSummaryArgs ) />


<cfset articles.setNextN( objectParams.articleCountPerPage ) />
<cfset articles.setPage( objectParams.currentPage ) />
<cfset objectParams.numberOfPages = Ceiling( articles.getrecordCount() / objectParams.articleCountPerPage )>


<cfoutput>

	<cfif articles.hasNext()>

		<cfloop condition="articles.hasNext()">
			<cfset article = articles.next() />

			<!--- the "search results" output is much less complicated to render than the "card" output. No need for the extra "math and DIV-logic" here. --->
			<cfif objectParams.renderMode eq "results">
				<cfswitch expression="#article.getSubtype()#">
					<cfcase value="Article">
						#$.renderSearchResult( articleToRender = article )#
					</cfcase>

					<cfcase value="Video,Webinar,CaseStudy,ProductTutorial">
						#$.renderSearchResult( articleToRender = article, resultType="video",resultTimeText="watch")#
					</cfcase>

					<cfdefaultcase>
						#$.renderSearchResult( articleToRender = article )#
					</cfdefaultcase>
				</cfswitch>

			</cfif>
		</cfloop>

		<cfif objectParams.renderMode eq "card">
			</div>
		</cfif>

		<!--- Pagination --->
		<cfif !objectParams.bInfiniteScroll>
			<cfif objectParams.numberOfPages gt 1>
				<nav class="text-xs-center" id="js-pagination-outter-wrapper">
					<ul class="pagination" id="card-pagination">
						<!--- // if we're on the first page, the "previous" icon should be disabled. --->
						<li class="page-item<cfif objectParams.currentPage eq 1> disabled</cfif>" id="btn-previous-page">
							<cfset previousPageNumber = objectParams.currentPage - 1 />
							<a class="page-link page-prev <cfif objectParams.currentPage gt 1>js-pagelink</cfif>" data-pagenumber="#previousPageNumber#" href="##" aria-label="Previous"><span class="sr-only">Previous</span></a>
						</li>

						<!--- if we've got 6 or more pages. we'll need to set a "start" and "end" point and also add the elipsis to either
							  the beginning or end or both. --->
						<cfif objectParams.numberOfPages gte 6>
							<!--- if there are more than 3 "previous" pages, we need a "previous elipsis" --->
							<cfif objectParams.currentPage gt 3>
								<li class="page-item">
									<a class="page-link js-pagelink" data-pagenumber="1" href="##">1</a>
								</li>
								<li class="page-item">
									<span class="page-link">&hellip;</span>
								</li>
							</cfif>

						</cfif>

						<!--- If we have 5 or fewer pages of articles, just draw the links in a straight loop. No need for anything fancy. --->
						<cfif objectParams.numberOfPages lte 5>
							<cfset beginingPaginationPage = 1 />
							<cfset endingPaginationPage = objectParams.numberOfPages />
						<cfelse>
							<!--- if the "current page" is 1 thru 3, just draw pages 1 thru 5 for our pagination. --->
							<cfif objectParams.currentPage lte 3>
								<cfset beginingPaginationPage = 1 />
								<cfset endingPaginationPage = 5 />
							<cfelse>
								<!--- if we're on pages 4 and up... put the "current page" in the middle of the pagination,
									  then draw 2 lower and 2 higher on either side --->
								<cfset beginingPaginationPage = objectParams.currentPage - 2 />

								<cfif objectParams.numberOfPages - objectParams.currentPage gte 2>
									<cfset endingPaginationPage   = objectParams.currentPage + 1 />
								<cfelseif objectParams.numberOfPages - objectParams.currentPage eq 1>
									<!--- if we're on the page BEFORE the last page, then skip the last page as that will be rendered separately after the ellipsis on the right-hand side --->
									<cfset beginingPaginationPage = objectParams.currentPage - 3 />
									<cfset endingPaginationPage   = objectParams.currentPage />
								<cfelse>
									<!--- On the last page of content --->
									<cfset beginingPaginationPage = objectParams.currentPage - 3 />
									<cfset endingPaginationPage   = objectParams.currentPage />
								</cfif>
							</cfif>

						</cfif>

						<!--- We *always* draw "page number 1" and whatever the last page is.  The fancy logic is to draw the ellipsis in the correce places.
						      Like so:
						      	1234...11
						      	1....78910...20
						      	1....78910
						 --->
						<cfloop index="curPage" from="#beginingPaginationPage#" to="#endingPaginationPage#">
							<li class="page-item<cfif curPage eq objectParams.currentPage> active</cfif>">
								<a class="page-link js-pagelink" data-pagenumber="#curPage#" href="##">#curPage# <cfif curPage eq objectParams.currentPage><span class="sr-only">(current)</span></cfif></a>
							</li>
						</cfloop>

						<!--- Do we need to draw the "next page" ellipsis too? --->
						<cfif objectParams.numberOfPages gte 6>
							<cfif objectParams.currentPage lt objectParams.numberOfPages>
								<li class="page-item">
									<span class="page-link">&hellip;</span>
								</li>
								<li class="page-item">
									<a class="page-link js-pagelink" data-pagenumber="#objectParams.numberOfPages#" href="##">#objectParams.numberOfPages#</a>
								</li>
							</cfif>
						</cfif>

						<!---// are we on the last page?--->
						<cfif Ceiling( articles.getrecordCount() / objectParams.articleCountPerPage ) eq objectParams.currentPage>
							<cfset var bOnLastPage = true />
						<cfelse>
							<cfset var bOnLastPage = false />
						</cfif>
						<li class="page-item<cfif bOnLastPage> disabled</cfif>" id="btn-next-page">
							<cfset nextPageNumber = objectParams.currentPage + 1 />
							<a class="page-link page-next <cfif !bOnLastPage>js-pagelink</cfif>" data-pagenumber="#nextPageNumber#" href="##" aria-label="Next"><span class="sr-only">Next</span></a>
						</li>
					</ul>
				</nav>
			</cfif>

			<!--- update some client-side data after this display object is done rendering.  MUCH to my surprise, this seems to work. --->
			<script>
				m(function(){
					m( "##articleRecordCount" ).html( "#articles.getrecordCount()# Results" );


					<!--- Pagination links --->
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

				});
			</script>
		</cfif>

	</cfif>
</cfoutput>
--->