//
//  ViewController.swift
//  News
//
//  Created by Willy Sato on 2022/07/31.
//

import UIKit
import SafariServices
import SideMenu

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsManager = NewsManager()
    var articles = [Articles]()
    var newsModel = [NewsModel]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var sideMenu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        view.backgroundColor = .darkGray
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        createSearchBar()
        fetchData()
        
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuController())
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func fetchData() {
        newsManager.fetchData { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
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
    
    func createSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    @IBAction func sideMenuPressed(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }
    
}

//MARK: - Search Delegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        newsManager.search(with: text) {[weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.newsModel = articles.compactMap({
                    NewsModel(results: 0, title: $0.title, source: $0.source.name, urlToImage: $0.urlToImage)
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            fetchData()
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let articles = articles[indexPath.row]
        
        guard let url = URL(string: articles.url ?? "") else {
            return
        }
        let view = SFSafariViewController(url: url)
        present(view, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
