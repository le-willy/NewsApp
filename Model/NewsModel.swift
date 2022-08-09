//
//  NewsModel.swift
//  News
//
//  Created by Willy Sato on 2022/08/04.
//

import Foundation

struct NewsModel {
    let results: Int
    let title: String
    let source: String
    let urlToImage: String?
    
    init(results: Int, title: String, source: String, urlToImage: String?) {
        self.results = results
        self.title = title
        self.source = source
        self.urlToImage = urlToImage
    }
}
