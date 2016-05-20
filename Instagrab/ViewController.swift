//
//  ViewController.swift
//  Instagrab
//
//  Created by ray on 5/19/16.
//  Copyright © 2016 rayps. All rights reserved.
//

import UIKit
import Kanna
import PlayerView
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var subView: UIView!
    
    let player = PlayerView(frame: CGRect(x: 10,y: 10,width: 300,height: 300))
    
    var source: NSURL = NSURL(fileURLWithPath: "")
    
//    let testUrl = "https://instagram.com/p/BAwilKUtf2H/"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.getTheShit), name:
        UIApplicationWillEnterForegroundNotification, object: nil)
        
        player.delegate = self
        player.interval = CMTimeMake(1, 30)
        subView.addSubview(player)
        
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
                self.player.url = self.source
                self.player.play()
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
        self.player.currentTime = 0.0
    }
    
    
}


extension ViewController: PlayerViewDelegate {
    func playerVideo(player: PlayerView, loadedTimeRanges: [PlayerviewTimeRange]) {
//        print(loadedTimeRanges.first!.end.seconds)
    }
    
    func playerVideo(player: PlayerView, duration: Double) {
        //the player knows the duration of the video to reproduce on seconds
//        print(duration)
    }
    
    func playerVideo(player: PlayerView, currentTime: Double) {
        print(currentTime)
        if currentTime > 13.0 {
            self.player.currentTime = 0.0
        }
    }
    
    func playerVideo(playerFinished player: PlayerView) {
        //when the video finishes the reproduction to the end
        print("playerFinished")
//        self.player.stop()
//        self.player.currentTime = 0.0
//        self.player.play()
    }
}








