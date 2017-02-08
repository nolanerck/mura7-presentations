<!--- set some defaults for the first time this page loads, and these might be changed by whatever
	  the page is that's using this Display Object --->
<cfparam name="objectParams.articleCountPerPage" default="18" type="numeric" /> <!--- How many Article Summary Cards are we drawing on this page? --->
<cfparam name="objectParams.bInfiniteScroll" default="false" type="boolean" />
<cfparam name="objectParams.articleSortByColumn" default="releaseDate" />
<cfparam name="objectParams.articleSortByDirection" default="DESC" />
<cfparam name="objectParams.currentPage" default="1" type="numeric" />
<cfparam name="objectParams.secondarycategoryid" default="" />
<cfparam name="objectParams.txtNoContentFoundVerbiage" default="" />

<cfparam name="objectParams.renderMode" default="card" /> <!--- Options are "card" or "results", which determines the type of HTML markup we use in the output. --->
<cfparam name="objectParams.queryMode" default="query" /> <!--- Options are "query","relatedContent","preDefinedList" which determines where we get our dataset from for this object. --->

<cfset articleSvc = $.getBean( "ArticleService" ) />

<cfif objectParams.queryMode eq "query">
	<cfset mainCategoryForThisLandingPage = ValueList( $.content().getCategoriesQuery().categoryID ) />

	<!--- if the "Canada" flag is set we need to include that for filtering the content. --->
	<cfset selectedCountryCategoryID = $.getBean('category').loadBy( name = session.intuitData.countrySelect ).getCategoryID() />

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
	
<cfelseif objectParams.queryMode eq "relatedContent">

	<cfset request.cacheitem = false />

	<cfset articles = $.content().getRelatedContentIterator( reverse = "true",
															 name = "Authors",
															 sortby = objectParams.articleSortByColumn,
															 sortDirection = objectParams.articleSortByDirection ) /> <!--- we may need to refactor this later so "name" and/or "reverse" can be passed in as args. --->

	<!--- for MXP, we need to send these ContentIDs to getArticles for proper sorting --->
	<cfif objectParams.articleSortByColumn eq "mxpRelevance">
		<cfset var lstContentIDs = ValueList( articles.getQuery().contentID ) />

		<cfset articles = articleSvc.getArticles(
													$ = $,
													siteid = $.content( 'siteid' ),
													contentparentid = $.getBean('content').loadBy(filename='content').getContentID(), <!--- the "Content" Folder ID, where all the articles live. --->
													orderBy = "mxpRelevance",
													orderByDirection = objectParams.articleSortByDirection,
													lstContentIDs = lstContentIDs
												)/>
	</cfif>


<cfelseif objectParams.queryMode eq "preDefinedList"> <!--- we're passing in a specific list of contentIDs to use (ala the My Bookmarks from localStorage) --->
	<cfparam name="objectParams.lstContentIDs" default="" />
	<cfparam name="objectParams.categoryID" default="" />

	<cfset articleBookmarkArgs = {
									$ = $,
									siteid = $.content('siteid'),
									contentparentid = $.getBean('content').loadBy(filename='content').getContentID(), <!--- the "Content" Folder ID, where all the articles live. --->
									orderBy = "Title",
									lstContentIDs = objectParams.lstContentIDs <!--- specific list of the content nodes (articles) we're interested in for this. --->
	} />

	<!--- if we also got a CategoryID then we're filtering down to just lstContentIDs that also belong to the given category --->
	<cfif Len( objectParams.categoryID ) gt 0>
		<cfset articleBookmarkArgs.primarycategoryid = objectParams.categoryID />
	</cfif>

	<cfset articles = articleSvc.getArticles( argumentCollection = articleBookmarkArgs ) />

	<!--- flag for showing the "remove bookmark" link in the Card output. we only use that on the "my bookmarks" page. --->
	<cfset bShowBookMarkLink = true />
<cfelseif objectParams.queryMode eq "cfsearch"> <!--- custom CFSearch/Solr functionality --->
	<cfparam name="objectParams.keywordsToSearch" default="" />

	<cfset preparedKeywordsToSearch = Trim( LCase( objectParams.keywordsToSearch ) ) />
	
	<cfif Len( preparedKeywordsToSearch ) gt 0>
		<!--- remove any funny characters from the search terms --->
		<cfset preparedKeywordsToSearch = Trim( REReplaceNoCase( preparedKeywordsToSearch, "[^A-Za-z0-9\s]", "", "ALL" ) ) />
		<!--- Remove strings of 2 or more white-space characters so they don't screw up our parsing keywords later on. --->
		<cfset preparedKeywordsToSearch = REReplaceNoCase( preparedKeywordsToSearch, "\s\s*", " ", "ALL" ) />
		<!--- Now replace any white-space with a comma so we have a legit CF list moving forward --->
		<cfset preparedKeywordsToSearch = REReplaceNoCase( preparedKeywordsToSearch, "\s", ",", "ALL" ) />
		
		<cfif ListLen( preparedKeywordsToSearch ) gt 0>
			<!--- We're going to exploit the CF List functionality here a bit. Since we're doing an "<AND>" search, we can just use
			     "<AND>" as the list delimiter instead of, say, commas.  Then we can put an asterix to the right of each term to get the
			     "fuzzy search" working (alas, Solr Lucene doesn't support an asterix at the beginning of a search term).
			     Also, we don't have to write any sort of weird string parsing loop or whatever to do it. --->
			<cfset preparedKeywordsToSearch = ListChangeDelims( preparedKeywordsToSearch, "* AND " ) />
						
			<cfset preparedKeywordsToSearch = preparedKeywordsToSearch & "*" /> <!--- tack an astrix on the end of the last word so that one gets fuzzy-searched too. --->
		<cfelse>
			<cfset preparedKeywordsToSearch = "\:" />
		</cfif>		
	<cfelse>
		<cfset preparedKeywordsToSearch = "\:" /> <!--- Solr-speak for "empty search, don't return anything". --->
	</cfif>

	<cfset solrSearchArgs = {
							name = "rsSearchResults",
							collection = "intuit_solrSearchCollection",
							criteria = preparedKeywordsToSearch
						} />

	<cfsearch attributeCollection=#solrSearchArgs# />

	<!--- search content from not just the /Content folder but these other 2 locations as well. --->
	<cfset ProductTrainingAndCertificationContentID = $.getBean('content').loadBy(siteid='intuit', title='Product Training & Certification').getContentID() />
	<cfset EventsContentID 						    = $.getBean('content').loadBy(siteid='intuit', title='Events').getContentID() />

	<cfset 	serviceArgs = {
								$ = $,
								siteid = $.content('siteid'),
								contentparentid = "#$.getBean('content').loadBy(filename='content').getContentID()#,#ProductTrainingAndCertificationContentID#,#EventsContentID#", <!--- the "Content" Folder ID, where all the articles live. --->
								lstContentIDs = ValueList( rsSearchResults.key ), <!--- specific list of the content nodes (articles) we're interested in for this. --->
								orderBy = objectParams.articleSortByColumn,
								orderByDirection = objectParams.articleSortByDirection
						  } />

	<cfset articles = articleSvc.getArticles( argumentCollection = serviceArgs ) />

</cfif>

<cfparam name="bShowBookMarkLink" default="false" type="boolean" />

<cfset articles.setNextN( objectParams.articleCountPerPage ) />
<cfset articles.setPage( objectParams.currentPage ) />
<cfset objectParams.numberOfPages = Ceiling( articles.getrecordCount() / objectParams.articleCountPerPage )>

<!---
	Row variant 1 - Column order: 4/5/3
	Row variant 2 - Column order: 5/3/4
	Row variant 3 - Column order: 3/4/5
--->

<!--- set class variant number --->
<cfset lstLargeClassVariants = "4,5,3,5,3,4,3,4,5" />
<cfset curCard = 1 />

<cfoutput>

	<cfif articles.hasNext()>

		<cfif objectParams.renderMode eq "card">
			<div class="row is-flex">
		</cfif>

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

			<cfelseif objectParams.renderMode eq "card">

				<!--- set card back to 1 --->
				<cfif curCard eq ( ListLen( lstLargeClassVariants ) + 1)>
					<cfset curCard = 1 />
				</cfif>

				<!--- set the large card class --->
				<cfset largeClassName = "col-xl-#ListGetAt( lstLargeClassVariants, curCard )#" />

				<!--- card output --->

				<div class="col-xs-12 col-md-6 #largeClassName#">

					<cfswitch expression="#article.getSubtype()#">

						<!--- Article --->
						<cfcase value="Article,WhitePaper">
							<cfset cardListClass="">
							<cfif len(article.getValue('cardDisplayTitle'))>
								<cfset cardListClass="list">
							</cfif>
							<!---#$.renderCard( articleToRender = article, cardType="#cardListClass#", cardShowBookMarkLink=bShowBookMarkLink)#--->
							#$.renderCardEx( articleToRender = article, cardType="#cardListClass#", bShowBookMarkLink=bShowBookMarkLink )#
						</cfcase>

						<!--- Video --->
						<cfcase value="Video,CaseStudy,ProductTutorial">
							<!--- card image needs to output video variant --->
							#$.renderCard(articleToRender = article, cardType="video",cardShowImage="1",cardShowSummary="1",cardMoreText="Watch Now",cardShowAuthor="0",cardTimeText="watch", cardShowBookMarkLink=bShowBookMarkLink)#
						</cfcase>

						<!--- Video --->
						<cfcase value="Webinar">
							<!--- card image needs to output video variant --->
							#$.renderCard(articleToRender = article, cardType="webinar",cardShowImage="0",cardShowSummary="1",cardMoreText="Watch Webinar",cardShowAuthor="0",cardTimeText="watch", cardShowBookMarkLink=bShowBookMarkLink)#
						</cfcase>

						<!--- Infographic --->
						<cfcase value="Infographic">
							#$.renderCard(articleToRender = article, cardType="infographic",cardShowImage="1",cardMoreText="See More", cardShowBookMarkLink=bShowBookMarkLink)#
						</cfcase>

						<!--- News --->
						<cfcase value="News">
							#$.renderCard(articleToRender = article, cardShowPublishDate="1",cardShowAuthor="2",cardShowTimeText="0",cardTimeText="0", cardShowBookMarkLink=bShowBookMarkLink)#
						</cfcase>

						<cfdefaultcase>
							#$.renderCard(articleToRender = article, cardShowBookMarkLink=bShowBookMarkLink)#
						</cfdefaultcase>

					</cfswitch>
				</div>

				<cfset curCard++ />
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

					eqjs.all();

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

					<cfif bShowBookMarkLink eq true>
						// ability to remove (and re-add) bookmarks...
						m( ".js-removeBookmark" ).click(function(evt)
						{
							evt.preventDefault();

							var mybookmarks = new LocalStorageLinkedHashSet( "intuit-mybookmarks" );
							var _contentID = $(this).data( "contentid" );

							// if this contentID is still in our list of bookmarks, delete it
							if( mybookmarks.contains( _contentID ) )
							{
								mybookmarks.removeByValue( _contentID );

								// add the "inactive" class to parent div
								$(this).parent().closest('div').addClass( "card--inactive" );

								$(this).html( "Undo Remove" );
							}
							else // the "undo and re-add" functionality
							{
								mybookmarks.add( _contentID );

								$(this).parent().closest('div').removeClass( "card--inactive" );

								$(this).html( "Remove" );
							}
						});
					</cfif>
				});
			</script>
		<cfelse>
			<script>
				m(function()
				{
					eqjs.all();
				});
			</script>
		</cfif>

	<cfelse>

		<div class="alert alert-success">
			<cfif Len( objectParams.txtNoContentFoundVerbiage ) gt 0>
				#objectParams.txtNoContentFoundVerbiage#
			<cfelse>
				Content Not Found
			</cfif>
		</div>

	</cfif>
</cfoutput>
