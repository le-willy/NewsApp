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
    
    weak var delegate: NewsManagerDelegate?
    
    private var viewModels = [NewsTableViewCell]()
    
    func fetchData(completionHandler: @escaping (Result<[Articles], Error>) -> Void) {
        
        if let url = URL(string: newsApi) {
//            let session = URLSession(configuration: .default)
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completionHandler(.failure(error))
                }
                else if let data = data {
                    do {
                        let result = try JSONDecoder().decode(NewsData.self, from: data)
                        print(result.articles)
                        completionHandler(.success(result.articles))
                    } catch {
                        completionHandler(.failure(error))
                    }
                }
            }
            
//            let task = session.dataTask(with: url) { data, response, error in
//                if error != nil, data != nil {
//                    print(error!)
//                    return
//                }
//                if let safeData = data {
//                    //                    newsData = try! JSONDecoder().decode(NewsData.self, from: safeData)
//                    //                    if let news = parseJSON(newsData: safeData) {
//                    //                        delegate?.didUpdateNews(news: news)
//                    //                    }
//                    let decoder = JSONDecoder()
//                    do {
//                        let decodedData = try decoder.decode(NewsData.self, from: safeData)
//
//                        print(decodedData.articles)
//                        completionHandler(newsData)
//                    } catch {
//                        print(error)
//                    }
//
//                }
//
//            }
            task.resume()
            
        }
    }
    
    
    
    
    func fetchData() {
        performRequest(urlString: newsApi)
    }
    
    func performRequest(urlString: String) {
        
    }
    
    func parseJSON(newsData: Data) -> NewsModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(NewsData.self, from: newsData)
            let totalResults = decodedData.totalResults
            let name = decodedData.articles[0].source.name
            let title = decodedData.articles[0].title
            let newsImage = decodedData.articles[0].urlToImage
            
            let newsModel = NewsModel( results: totalResults, title: title, source: name, urlToImage: newsImage)
            
            return newsModel
        } catch {
            print(error)
            return nil
        }
    }
}


