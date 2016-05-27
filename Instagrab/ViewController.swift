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
import Kingfisher
import Photos

class ViewController: UIViewController, PlayerDelegate {
    
    @IBOutlet weak var subView: UIView!
    
    

    let player = Player()
    let photoView = UIImageView()
    
    var imageUrl: NSURL = NSURL()
    var videoUrl: NSURL? = nil
    
    
//    let testUrl = "https://instagram.com/p/BAwilKUtf2H/" "https://instagram.com/p/BBmgXFItf0w/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.getTheShit), name:
        UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.photoView.frame = subView.frame
        self.photoView.kf_showIndicatorWhenLoading = true
        self.photoView.contentMode = .ScaleAspectFit
        self.subView.addSubview(photoView)
        
        self.player.delegate = self
        self.player.view.backgroundColor = UIColor.whiteColor()
        self.player.view.frame = subView.frame
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
        
        print("Paste board : \(pbsurl)")
        grabContent(pbsurl)
    }
    
    @IBAction func buttonDidTouch(sender: AnyObject) {
        self.player.view.hidden = true
    }
    

    func grabContent(url: NSURL) {
        grabHTML(url) { (document) in
            
            let video: XMLNodeSet = document.css("meta[property='og:video']")
            let image: XMLNodeSet = document.css("meta[property='og:image']")
            
            let imageUrlString: String = image.first!["content"]!
            self.imageUrl = NSURL(string: imageUrlString)!
            
            self.photoView.kf_setImageWithURL(self.imageUrl)
            
            if video.count > 0 {
                
                let videoUrlString: String = video.first!["content"]!
                self.videoUrl = NSURL(string: videoUrlString)!
                self.player.view.hidden = false
                self.player.setUrl(self.videoUrl!)
                self.player.playFromBeginning()
            } else {
                self.videoUrl = nil
                print("This is not a video")
            }
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
        player.export()
    }
    
    
    func playerReady(player: Player) {
        print("...Player Ready")
        if self.videoUrl == nil {
            self.player.stop()
            self.player.view.hidden = true
        }
    }
    
    func playerPlaybackStateDidChange(player: Player) {
        print("...playerPlaybackStateDidChange")
    }
    
    func playerBufferingStateDidChange(player: Player) {
        if player.bufferingState == BufferingState.Unknown {
            print("...Downloading...")
        } else {
            print("...Downloaded")
            
            print(player.reset())
        }
        
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
        print("...SRART")
    }
    
    func playerPlaybackDidEnd(player: Player) {
        print("...END")
    }
    
    
}







