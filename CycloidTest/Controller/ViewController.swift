//
//  ViewController.swift
//  CycloidTest
//
//  Created by abc on 07/04/20.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var arrFacts:Facts?
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(requestData), for:.valueChanged)
        return refreshControl
    }()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        jsonParsing()
        tableView.refreshControl = refresher
    }
    
    @objc func requestData() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        // Simply adding an object to the data source for this example
        print("Pull To Refresh")
        let deadline = DispatchTime.now() + .milliseconds(600)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
        
        
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 {
            return 0
        }
        
        return tableView.rowHeight
    }
    func jsonParsing(){
        let url = Bundle.main.path(forResource: "facts", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: url!), options: .alwaysMapped)
            guard let string = String(data: data, encoding: String.Encoding.isoLatin1) else { return }
            guard let properData = string.data(using: .utf8, allowLossyConversion: true) else { return }
            self.arrFacts = try JSONDecoder().decode(Facts.self, from:properData)
            guard let facts = self.arrFacts?.rows else{return}
            for _ in facts{
                //                print(arr.title ?? "No Title")
                //                print(arr.description ?? "No Description")
                //                print(arr.imageHref ?? "No Image")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }catch {
            print("parse error: \(error.localizedDescription)")
        }
        
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let facts = self.arrFacts?.rows
        let fact  = facts!
        return fact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let facts = self.arrFacts?.rows
        let fact  = facts!
        
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.lblTitle.text = fact[indexPath.row].title
        cell.lblDescription.text =  fact[indexPath.row].description
        let url = URL(string: fact[indexPath.row].imageHref ?? "")
        cell.img.kf.setImage(with: url)
        return cell
    }
    
}


