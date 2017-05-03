//
//  ViewController.swift
//  Wild Animals
//
//  Created by Felix Feliciant on 4/30/17.
//  Copyright © 2017 FelixFeliciant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var animals: [Animal]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. haha
     
        readJson()
        
        fetchAnimals()
        
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    private func readJson() {
        do {
            
            self.animals = [Animal]()
            
            
            
            if let file = Bundle.main.url(forResource: "animals", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    
                    //parse title:
                    if let title = object["title"] as? String {
                        
                    }
                    
                    
                    var isAnimal: Bool
                    
                    //parse the paragrapphs which is an array
                    if let paragraphs = object["paragraphs"] as? [[String: AnyObject]] {
                        
                        for paragraph in paragraphs {
                            
                            isAnimal = true
                            
                            let caption  = paragraph["caption"]
                            let text  = paragraph["text"]
                            if let images = paragraph["images"] as? [[String:AnyObject]] {
                                
                                if images.count == 0 {
                                    isAnimal = false
                                }
                                
                                
                                var imageObjects = [[String:String]]()
                                
                                for image in images {
                                    let imageName = image["name"] as? String
                                    let imageUrl = image["url"] as? String
                                    let imageExplanation = image["explanation"] as? String
                                    
                                    var imgDict = [String: String]()
                                    imgDict["name"] = imageName
                                    imgDict["url"] = imageUrl
                                    imgDict["explanation"] = imageExplanation
                                    imageObjects.append(imgDict)
                                    
                                }
                                
                                if isAnimal == true {
                                    let animal = Animal()
                                    animal.caption = caption as! String?
                                    animal.text = text as! String?
                                    animal.images = imageObjects
                                    self.animals?.append(animal)
                                }
                            }
                            
                        }
                        
                    }
               
                    // json is a dictionary
//                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    func fetchAnimals() {
        
        // json url : https://api.myjson.com/bins/yapvl
        
        let urlRequest = URLRequest(url: URL(string:"https://api.myjson.com/bins/yapvl")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error)
                
            }
            
            self.animals = [Animal]()
            
            do {
                // global json object containing titile(string), paragraps(array of objects)
                let json  = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                //parse title:
                if let title = json["title"] as? String {
                    
                }
                
                
                var isAnimal: Bool
                
                //parse the paragrapphs which is an array
                if let paragraphs = json["paragraphs"] as? [[String: AnyObject]] {
                    
                    for paragraph in paragraphs {
                        
                        isAnimal = true
                        
                        let caption  = paragraph["caption"]
                        let text  = paragraph["text"]
                        if let images = paragraph["images"] as? [[String:AnyObject]] {
                            
                            if images.count == 0 {
                                isAnimal = false
                            }
                            
                            
                            var imageObjects = [[String:String]]()
                            
                            for image in images {
                                let imageName = image["name"] as? String
                                let imageUrl = image["url"] as? String
                                let imageExplanation = image["explanation"] as? String
                                
                                var imgDict = [String: String]()
                                imgDict["name"] = imageName
                                imgDict["url"] = imageUrl
                                imgDict["explanation"] = imageExplanation
                                imageObjects.append(imgDict)
                                
                            }
                            
                            if isAnimal == true {
                                let animal = Animal()
                                animal.caption = caption as! String?
                                animal.text = text as! String?
                                animal.images = imageObjects
                                self.animals?.append(animal)
                            }
                        }
                        
                    }
                    
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error{
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalCell
        
        cell.name.text = self.animals?[indexPath.item].caption
        
        cell.info.text = self.animals?[indexPath.item].text
        
        cell.imgView.downloadImage(from: (self.animals?[indexPath.item].images?[0]["url"])!)
        
//        cell.imgView.image = UIImage(named: (self.animals?[indexPath.item].images?[0]["name"])!)
        cell.imgView.accessibilityIdentifier = self.animals?[indexPath.item].images?[0]["name"]
        
        
    
        cell.imgView?.isUserInteractionEnabled = true
        
        cell.imgView?.tag = indexPath.row
        
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.TappedOnImage(sender:)))
        
        
        tapped.numberOfTapsRequired = 1
        cell.imgView?.addGestureRecognizer(tapped)
        
        return cell
    }
    
    
    
    func TappedOnImage(sender:UITapGestureRecognizer){
//        print(sender.view?.tag)
        print("heelo")
        
    
        
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals?.count ?? 0
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}






extension UIImageView {
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    func downloadImage(from url: String) {
        
        
        
            let urlRequest = URLRequest(url: (URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!))
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                DispatchQueue.main.async {
//                    var temp: UIImage = UIImage(data: data!)!
//                    self.image = self.resizeImage(image: temp, newWidth: 200)
                    self.image = UIImage(data: data!)!
                

                }
            }
            task.resume()
        
            
       
        
        

        
        
        
    }
    
}


//
//
//
//
//
//
//                if let animalsFromJson = json["paragraphs"] as? [[String: AnyObject]] {
//                    for animalFromJson in animalsFromJson {
//
//                        let animal = Animal()
//
//                        if let name = animalFromJson["caption"] as? String, let info = animalFromJson["text"] as? String, let imagesUrl = animalFromJson["images"] as? [AnyObject] {
//
//                            animal.caption = name
//                            animal.text = info
////                            animal.images = imagesUrl as! [String]
//
//
//                        }
//                        self.animals?.append(animal)
//                    }
//                }
