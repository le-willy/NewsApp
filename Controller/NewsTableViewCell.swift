//
//  NewsTableViewCell.swift
//  News
//
//  Created by Willy Sato on 2022/08/04.
//

import UIKit

class NewsTableViewCell: UITableViewCell, NewsManagerDelegate {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    var newsManager = NewsManager()
    var newsData = [NewsData]()
    var newsModel = [NewsModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newsManager.delegate = self
        
        newsManager.fetchData { news in
            
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func didUpdateNews(news: NewsModel) {
        titleLabel.text = news.title
        sourceLabel.text = news.source
        
        if let imageData = news.urlToImage {
            newsImageView.downloaded(from: imageData)
        }
    }

    
}


//if let image = news.urlToImage {
//self.newsImageView.downloaded(from: image)
//}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
