//
//  NewsData.swift
//  News
//
//  Created by Willy Sato on 2022/08/04.
//

import Foundation

struct NewsData: Codable {
    let totalResults: Int
    let articles: [Articles]
}


struct Articles: Codable {
    let source: Source
    let title: String
    let urlToImage: String?
}


struct Source: Codable {
    let name: String
}
