//
//  ViewController.swift
//  News
//
//  Created by Willy Sato on 2022/07/31.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var newsManager = NewsManager()
    var newsModel = [NewsModel]()
    var customCell = NewsTableViewCell()
    var newsData = [NewsData]()
    
    var testArray = ["1", "2", "3", "4", "5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        view.backgroundColor = .darkGray
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        newsManager.fetchData { [weak self] result in
            switch result {
            case .success(let articles):
                self?.newsModel = articles.compactMap({
                    NewsModel(results: 0, title: $0.title, source: $0.source.name, urlToImage: $0.urlToImage)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}


//MARK: - TableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as! NewsTableViewCell
        
        cell.didUpdateNews(news: newsModel[indexPath.row])
//        var content = cell.defaultContentConfiguration()
//        content.text = testArray[indexPath.row]
//
//        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
