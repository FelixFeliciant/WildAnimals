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
        // Do any additional setup after loading the view, typically from a nib.
        
        readJson()
        
    }
    
    
    
    private func readJson() {
        do {
            
            self.animals = [Animal]()
            if let file = Bundle.main.url(forResource: "animals", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    //parse title:
                    if (object["title"] as? String) != nil {
                        
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
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if !(self.animals?[indexPath.item].hasMultipleImages())! {
            let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalCell
            
            cell.name.text = self.animals?[indexPath.item].caption
            cell.info.text = self.animals?[indexPath.item].text
            
            cell.imgView.downloadImage(from: (self.animals?[indexPath.item].images?[0]["url"])!, name: (self.animals?[indexPath.item].images?[0]["name"])!)
            cell.imgView.accessibilityIdentifier = self.animals?[indexPath.item].images?[0]["name"]
            cell.imgView?.isUserInteractionEnabled = true
            //cell.imgView?.setValue(indexPath.item, forKeyPath: "animalIndex")
            //cell.imgView?.setValue(0, forKeyPath: "animalImageIndex")
            cell.imgView?.tag = indexPath.row
            
            let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnImage(sender: )))
            
            tapped.numberOfTapsRequired = 1
            cell.imgView?.addGestureRecognizer(tapped)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "animalCellTwo", for: indexPath) as! AnimaCellTwo
            
            cell.name.text = self.animals?[indexPath.item].caption
            cell.info.text = self.animals?[indexPath.item].text
            
            

            cell.imgViewLeft.downloadImage(from: (self.animals?[indexPath.item].images?[0]["url"])!, name: (self.animals?[indexPath.item].images?[0]["name"])!)
            cell.imgViewLeft.accessibilityIdentifier = self.animals?[indexPath.item].images?[0]["name"]
            cell.imgViewLeft?.isUserInteractionEnabled = true
            cell.imgViewLeft?.tag = indexPath.row
            
            let tappedLeft:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnImage(sender:)))
            tappedLeft.numberOfTapsRequired = 1
            cell.imgViewLeft?.addGestureRecognizer(tappedLeft)
            
            
            
            cell.imgViewRight.downloadImage(from: (self.animals?[indexPath.item].images?[1]["url"])!, name: (self.animals?[indexPath.item].images?[1]["name"])!)
            cell.imgViewRight.accessibilityIdentifier = self.animals?[indexPath.item].images?[1]["name"]
            cell.imgViewRight?.isUserInteractionEnabled = true
            cell.imgViewRight?.tag = indexPath.row
            
            let tappedRight:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedOnImage(sender:)))
            tappedRight.numberOfTapsRequired = 1
            cell.imgViewRight?.addGestureRecognizer(tappedRight)
            return cell
            
            
        }
        
    }
    
    
    
    func tappedOnImage(sender:UITapGestureRecognizer){
        let tappedImageName:String = (sender.view?.accessibilityIdentifier)!
        let animalIndx:Int =  (sender.view?.tag)!
        var animalExplanation:String?
        if self.animals?[animalIndx].images?[0]["name"] == tappedImageName {
            animalExplanation = self.animals?[animalIndx].images?[0]["explanation"]
        } else if self.animals?[animalIndx].images?[1]["name"] == tappedImageName{
            animalExplanation = self.animals?[animalIndx].images?[1]["explanation"]
        }
        
        let alert = UIAlertController(title: tappedImageName, message: animalExplanation, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go back", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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


let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func downloadImage(from imageUrl: String, name imageName: String) {
        
        var urlRequest:URLRequest
        let percentCharacter: Character = "%"
        if imageUrl.characters.contains(percentCharacter) {
            urlRequest = URLRequest(url: URL(string: imageUrl)!)
        } else {
            urlRequest = URLRequest(url: (URL(string: imageUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!))
        }
        
        if let imageFromCache = imageCache.object(forKey: imageName as AnyObject) as? UIImage {
            print("cached image: \(imageName)")
            self.image = imageFromCache
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            
            
            if (statusCode == 200) {
                DispatchQueue.main.async {
                    //print("downloading image: \(imageName)")
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: imageName as AnyObject)
                    self.image = imageToCache
                }
            }
            
            
            
            
        }
        task.resume()
        
    }
    
}




//TODO: TALK TO GDO



