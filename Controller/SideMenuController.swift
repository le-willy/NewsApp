//
//  SideMenuNavigationController.swift
//  News
//
//  Created by Willy Sato on 2022/08/10.
//

import UIKit
import SideMenu

class SideMenuController: UITableViewController {
    let menu = ["Settings"]
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var contents = cell.defaultContentConfiguration()
        contents.text = menu[indexPath.row]
        cell.contentConfiguration = contents
        return cell
    }
}
