//
//  NewsManager.swift
//  News
//
//  Created by Willy Sato on 2022/08/04.
//

import Foundation

protocol NewsManagerDelegate: AnyObject {
    func didUpdateNews(news: NewsModel)
}

struct NewsManager {
    let newsApi = "https://newsapi.org/v2/top-headlines?country=us&apiKey=31ac28d2be5a4d76b9a3e1c16efbff4e"
    let newsSearchedString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=31ac28d2be5a4d76b9a3e1c16efbff4e&q="
    
    weak var delegate: NewsManagerDelegate?
    
    private var viewModels = [NewsTableViewCell]()
    
    func fetchData(completionHandler: @escaping (Result<[Articles], Error>) -> Void) {
        
        if let url = URL(string: newsApi) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completionHandler(.failure(error))
                }
                else if let data = data {
                    do {
                        let result = try JSONDecoder().decode(NewsData.self, from: data)
                        completionHandler(.success(result.articles))
                    } catch {
                        completionHandler(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    func search(with query: String, completionHandler: @escaping (Result<[Articles], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let urlString = newsSearchedString + query
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completionHandler(.failure(error))
                }
                else if let data = data {
                    do {
                        let result = try JSONDecoder().decode(NewsData.self, from: data)
                        completionHandler(.success(result.articles))
                    } catch {
                        completionHandler(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}


