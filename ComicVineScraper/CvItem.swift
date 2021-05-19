//
//  CvPopularItem.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import Foundation

struct CvPopularItem {

    var date: String!
    var title: String!
    var siteDetailUrl: String!
    var imgsrc: String!
    var publisher: String!
    var countOfIssues: String!

    init(date: String = "",
         title: String = "",
         siteDetailUrl: String = "",
         imgsrc: String = "",
         publisher: String = "",
         countOfIssues: String = "") {

        self.date = date
        self.title = title
        self.siteDetailUrl = siteDetailUrl
        self.imgsrc = imgsrc
        self.publisher = publisher
        self.countOfIssues = countOfIssues
    }
}

/*
 volumes:
 
 <ul class="editorial cover-grid compact">
     
       <li>
         <a href="/batman/4050-796/">
                                   <div class="img imgboxart"><img src="https://comicvine.gamespot.com/a/uploads/scale_small/10/103530/3421824-2.png" alt="Batman"></div>
                     <h3 class="title">Batman</h3>
                       <p class="issue-date">1940</p>
                                 <p class="issue-date">DC Comics</p>
                                 <p class="issue-date">716 Issues</p>
                   </a>
       </li>

  issues:

 <ul class="editorial cover-grid compact">
           <li>
         <a href="/the-silver-surfer-16-in-the-hands-of-mephisto/4000-10813/">
                                   <div class="img imgboxart"><img src="https://comicvine.gamespot.com/a/uploads/scale_small/11/117763/2403520-ss16.png" alt="In the Hands of ... Mephisto!"></div>
                     <h3 class="title">The Silver Surfer #16 - In the Hands of ... Mephisto!</h3>
           <p class="issue-date">May 1970</p>
         </a>
       </li>
 */
