//
//  ViewController.swift
//  MyOkashi
//
//  Created by 吉田雄紀 on 2020/07/19.
//  Copyright © 2020 oremimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchText.delegate = self
        searchText.placeholder = "お菓子の名前を入力してください"
        tableVIew.dataSource = self
    }

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableVIew: UITableView!
    
    var okashiList : [(name:String, maker:String, link:URL, image:URL)] = []
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchWord = searchBar.text {
            <#statements#>
        }
    }
    
    struct ItemJson: Codable {
        let name: String?
        let maker: String?
        let url: URL?
        let image: URL?
    }
    
    struct ResultJson: Codable {
        let item:[ItemJson]?
    }
    
    func searchOkashi(keyword: String) {
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return  }
        
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else { return }
        print(req_url)
        
        let req = URLRequest(url:req_url)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            
            session.finishTasksAndInvalidate()
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                if let items = json.item {
                    self.okashiList.removeAll()
                    for item in items {
                        if let name = item.name, let maker = item.maker, let link = item.url, let image = item.image {
                            let okashi = (name,maker,link,image)
                            self.okashiList.append(okashi)
                        }
                    }
                    self.tableVIew.reloadData()
                }
            } catch {
                
            }
        })
        
        task.resume()
    }
    
    func tableView(_ tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)
        cell.textLabel?.text = okashiList[indexPath.row].name
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
            cell.imageView?.image = UIImage(data: imageData)
        }
    }
}

