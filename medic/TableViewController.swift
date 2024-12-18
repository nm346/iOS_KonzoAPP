//
//  TableViewController.swift
//  medic
//
//  Created by Nathan May on 17/03/2020.
//  Copyright © 2020 Nathan May. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

       var selectedCategory : String = ""
        var allTopHeader: String!
        var model: SourceModel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            model = SourceModel()
            showAllSources()
            tableView.tableFooterView = UIView()
        }
        
        func showAllSources() {
            model.getAllSources(selectedCategory, completion: {DispatchQueue.main.async {self.tableView.reloadData()
                }})
        }
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return model.sections
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return model.numberOfRowsInSection(section)
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sourceList", for: indexPath)
            
            guard let myValue = model.sources(at: indexPath) else {return cell}
                    
            cell.textLabel?.text = "\(indexPath.row+1) - \(myValue.name)"

            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let getHeader = model.sources(at: indexPath) else {return print("Nothing")}
            allTopHeader = getHeader.id
            performSegue(withIdentifier: "goToHeader", sender: self)
            
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let goToTopHeader = segue.destination as? HeaderCollectionViewController{
                goToTopHeader.selectedSource = allTopHeader
                
            }
        }
}
    struct SourceRootObject: Codable{
        var sources : [Sources]
    }

    struct Sources: Codable {
        var id : String
        var name : String
    }


    class SourceModel{
        
        var allSources = [Sources]()
        
        func getAllSources(_ source: String, completion: @escaping () -> Void) {
            
            var urlComponents = URLComponents()
            
            urlComponents.scheme = "https"
            urlComponents.host  = "newsapi.org"
            urlComponents.path = "/v2/sources"
            urlComponents.queryItems = [URLQueryItem(name: "health", value: source), URLQueryItem(name: "apiKey", value: "f632366b1e564129b789d859d72821d0")]
            
            guard let url = urlComponents.url else { return print("Unable to create URL \(urlComponents)")}
            
            let dataTask = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let error = error{
                    print("Error - \(error.localizedDescription)")
                } else if let data = data{
                    self.parseJSON(data)
                    completion()
                }else{
                    print("This should never happen")
                }
            }
            dataTask.resume()
        }
        
        func parseJSON(_ data : Data) {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(SourceRootObject.self, from: data)
                self.allSources = decodedData.sources
            }
            catch {
                print(error)
            }
        }
    }



    extension SourceModel{
        var sections: Int{
            return 1
        }

        func numberOfRowsInSection(_ section: Int) -> Int {
            return allSources.count
        }

        func sources(at indexPath: IndexPath) -> Sources? {
            if indexPath.section < 0 || indexPath.section > sections{
                return nil
            }
            if indexPath.row < 0 || indexPath.row > numberOfRowsInSection(indexPath.section){
                return nil
            }
            return allSources[indexPath.row]
        }
    }

/////////
private let reuseIdentifier = "Cell"

class HeaderCollectionViewController: UICollectionViewController {
    
    var selectedSource : String = ""
    var stories: Article!
    var model: HeaderModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = HeaderModel()
        showAllTopHeadlines()
    }
    
    func showAllTopHeadlines() {
        model.getAllTopHeadlines(selectedSource,completion: {DispatchQueue.main.async {
            self.collectionView.reloadData()
            }})
    }
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return model.sections
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return model.numberOfRowsInSection(section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { print("OUTTTT")
        let Headrcell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? topHeaderCollection else { return Headrcell }
         print("OUTTTT")
        if let topHeader = model.topHeadlines(at: indexPath){
             print("INNNNN")
            cell.topHeaderLable.text = topHeader.title
            print("TOP:\(topHeader.title)")
       //    cell.topHeaderImageView.imageFromURL(topHeader.urlToImage, placeHolder: #imageLiteral(resourceName: "placeholder"))
        }
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let getFullNews = model.topHeadlines(at: indexPath) else {return print("Nothing")}
        stories = getFullNews
        
        performSegue(withIdentifier: "goToFullStory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let topHeadlines = segue.destination as? FullArticleViewController{
            topHeadlines.fullStory = stories
        }
    }
}

class topHeaderCollection: UICollectionViewCell {
    @IBOutlet var topHeaderImageView: UIImageView!
    @IBOutlet var topHeaderLable: UILabel!
}

//////

struct TopHeadlineRootObject: Codable {
    var articles: [Article]
}

struct Article: Codable {
    var title: String
    var url : URL
    var urlToImage: URL
    var content: String
}

class HeaderModel{
    
    var getTopHeader = [Article]()
    
    func getAllTopHeadlines(_ artical: String, completion: @escaping () -> Void) {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host  = "newsapi.org"
        urlComponents.path = "/v2/top-headlines"
        urlComponents.queryItems = [URLQueryItem(name: "sources", value: artical), URLQueryItem(name: "apiKey", value: "f632366b1e564129b789d859d72821d0")]
        
        guard let url = urlComponents.url else { return print("Unable to create URL \(urlComponents)")}
        print(url)
        
        let dataTask = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error{
                print("Error - \(error.localizedDescription)")
            } else if let data = data{
                self.parseJSON(data)
                completion()
            }else{
                print("This should never happen")
            }
        }
        dataTask.resume()
    }
    
    
    func parseJSON(_ data : Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TopHeadlineRootObject.self, from: data)
            self.getTopHeader = decodedData.articles
        }
        catch {
            print(error)
        }
    }
}



extension HeaderModel{
    
    var sections: Int{
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return getTopHeader.count
    }
    
    func topHeadlines(at indexPath: IndexPath) -> Article? {
        if indexPath.section < 0 || indexPath.section > sections{
            return nil
        }
        if indexPath.row < 0 || indexPath.row > numberOfRowsInSection(indexPath.section){
            return nil
        }
        return getTopHeader[indexPath.row]
    }
}
/////
class FullArticleViewController: UIViewController {

    
    @IBOutlet var scrollNews: UIScrollView!
    @IBOutlet var headlineLable: UILabel!
    @IBOutlet var contextLable: UILabel!
    @IBOutlet var newImageView: UIImageView!
    
    var fullStory: Article!
    override func viewDidLoad() {
        super.viewDidLoad()
       newImageView.imageFromURL(fullStory.urlToImage, placeHolder: #imageLiteral(resourceName: "960x0"))
        headlineLable.text = fullStory.title
        contextLable.text = fullStory.content
    }

    @IBAction func goToFavouritesPage(_ sender: Any) {
        
        performSegue(withIdentifier: "goToFavourites", sender: sender)
        
    }


}

let topHeaderImages = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromURL(_ url: URL, placeHolder: UIImage?) {
        
        self.image = nil
        
        if let myCachedImage = topHeaderImages.object(forKey: url.absoluteString as NSString) {
            self.image = myCachedImage
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.image = placeHolder
                }
                return
            }
            
            DispatchQueue.global().async {
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                        topHeaderImages.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                        self.image = downloadedImage
                        }
                    }
                }
            }
        }).resume()
    }
}
