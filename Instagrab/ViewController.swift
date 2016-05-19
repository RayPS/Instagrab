//
//  ViewController.swift
//  Instagrab
//
//  Created by ray on 5/19/16.
//  Copyright © 2016 rayps. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController {
    
    let myURLString: String = "https://www.instagram.com/p/BFk9vOTEcGj/"
//    let myURLString: String = "https://www.instagram.com/p/BFkpmSIx5KT/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        grabContent { (result) in
            print(result)
        }
    }
    
    
    
    func grabContent(completion: (result: String) -> Void) {
        grabHTML(myURLString) { (document) in
            
            let video: XMLNodeSet = document.css("meta[property='og:video']")
            let image: XMLNodeSet = document.css("meta[property='og:image']")
            
            var metaTag: XMLElement
            
            if video.count > 0 {
                metaTag = video.first!
            } else {
                metaTag = image.first!
            }
            
            completion(result: metaTag["content"]!)
        }
    }
    
        
    func grabHTML(url: String, completion: (document: HTMLDocument) -> Void) {
        guard let myURL = NSURL(string: url) else {
            print("Error: \(url) doesn't seem to be a valid URL")
            return
        }
        do {
            let myHTMLString = try String(contentsOfURL: myURL)
            //            print(myHTMLString)
            if let html = Kanna.HTML(html: myHTMLString, encoding: NSUTF8StringEncoding) {
                completion(document: html)
            }
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
        
    }
}



