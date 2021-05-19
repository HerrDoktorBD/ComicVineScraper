//
//  iOSUtils.swift
//  ComicVineScraper
//
//  Created by Antonio Montes on 5/6/21.
//  Copyright © 2021 Antonio Montes. All rights reserved.
//

import UIKit

import Kanna

public class iOSUtils: NSObject {

    public func makeAttribText(for text: String,
                               urlStr: String) -> NSAttributedString {

        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [.link: urlStr,
                                                         .underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         .font: UIFont.preferredFont(forTextStyle: .caption1)]
        let range = NSRange(location: 0, length: text.count)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }

    func parseHTML(html: String,
                   cvUrlStr: String) -> [Any] {

        var items_ = [Any]()

        if let doc = try? HTML(html: html,
                               encoding: .utf8) {

            /*
             https://comicvine.gamespot.com/issues/

             <ul class="editorial cover-grid compact">
                <li>
                    <a href="/the-silver-surfer-16-in-the-hands-of-mephisto/4000-10813/">
                        <div class="img imgboxart"><img src="https://comicvine.gamespot.com/a/uploads/scale_small/11/117763/2403520-ss16.png" alt="In the Hands of ... Mephisto!"></div>
                        <h3 class="title">The Silver Surfer #16 - In the Hands of ... Mephisto!</h3>
                        <p class="issue-date">May 1970</p>
                    </a>
                </li>

            https://comicvine.gamespot.com/volumes/

             <ul class="editorial cover-grid compact">  <--- default
             <ul class="editorial cover-grid grid">
              <li>
                <a href="/batman/4050-796/">
                    <div class="img imgboxart">
                        <img src="https://comicvine.gamespot.com/a/uploads/scale_small/10/103530/3421824-2.png" alt="Batman">
                    </div>
                    <h3 class="title">Batman</h3>
                    <p class="issue-date">1940</p>
                    <p class="issue-date">DC Comics</p>
                    <p class="issue-date">716 Issues</p>
                </a>
              </li>
            */

            for item in doc.css("div[class='primary-content span8']") {

                let ul = item.css("ul[class='editorial cover-grid compact']") // compact is the default view

                if let items = ul.first?.xpath("//li") {

                    for item in items {

                        // issues and volumes
                        var date: String = ""
                        var title: String = ""
                        var link: String = ""
                        var imgsrc: String = ""

                        // volumes only
                        var publisher: String = ""
                        var numIssues: String = ""

                        let lia = item.css("a")

                        if let link_ = lia.first?["href"] {
                            link = link_
                        }

                        if let img = lia.first?.xpath("//div/img") {
                            if let imgsrc_ = img.first?["src"] {
                                imgsrc = imgsrc_
                            }
                        }

                        if let h3 = lia.first?.xpath("//h3") {
                            if let title_ = h3.first?.content {
                                title = title_
                            }
                        }

                        if let p = lia.first?.xpath("//p") {

                            if let date_ = p[0].content {
                                date = date_
                            }
                            if p.count > 1, let publisher_ = p[1].content {
                                publisher = publisher_
                            }
                            if p.count > 2, let numIssues_ = p[2].content {
                                numIssues = numIssues_
                            }
                        }

                        items_.append(CvPopularItem(date: date,
                                                    title: title,
                                                    siteDetailUrl: cvUrlStr + link,
                                                    imgsrc: imgsrc,
                                                    publisher: publisher,
                                                    countOfIssues: numIssues))
                    }
                }
            }
        }
        return items_
    }
}
