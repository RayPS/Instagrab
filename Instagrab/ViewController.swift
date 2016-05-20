//
//  ViewController.swift
//  Instagrab
//
//  Created by ray on 5/19/16.
//  Copyright © 2016 rayps. All rights reserved.
//

import UIKit
import Kanna
import AVFoundation

class ViewController: UIViewController, PlayerDelegate {
    
    @IBOutlet weak var subView: UIView!
    
    

    let player = Player()

    
    
    
    
    
    
    var source: NSURL = NSURL(fileURLWithPath: "")
    
//    let testUrl = "https://instagram.com/p/BAwilKUtf2H/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.getTheShit), name:
        UIApplicationWillEnterForegroundNotification, object: nil)
        
        let screen: CGRect = self.view.frame
        
        self.player.delegate = self
        self.player.view.backgroundColor = UIColor.whiteColor()
        self.player.view.frame = CGRect(x: 0,y: 0, width: screen.width, height: screen.width)
        self.player.playbackLoops = true
        self.subView.addSubview(self.player.view)
        self.player.didMoveToParentViewController(self)
        
        getTheShit()
    }
    
    
    func getTheShit() {
        let pasteboardString: String? = UIPasteboard.generalPasteboard().string
        guard let pbsurl = NSURL(string: pasteboardString!) else {
            print("Error: \(pasteboardString) doesn't seem to be a valid URL")
            return
        }
        
        grabContent (pbsurl){ (result) in
            print(result)
            if let url = NSURL(string: result) {
                self.source = url
                self.player.setUrl(url)
                self.player.playFromBeginning()
            }
        }
    }

    func grabContent(url: NSURL, completion: (result: String) -> Void) {
        grabHTML(url) { (document) in
            
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
    
        
    func grabHTML(url: NSURL, completion: (document: HTMLDocument) -> Void) {
        do {
            let myHTMLString = try String(contentsOfURL: url)
            //            print(myHTMLString)
            if let html = Kanna.HTML(html: myHTMLString, encoding: NSUTF8StringEncoding) {
                completion(document: html)
            }
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
        
    }
    
    @IBAction func buttonTouch(sender: UIButton) {
    }
    
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
    }
    
    func playerBufferingStateDidChange(player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
    }
    
    
}







