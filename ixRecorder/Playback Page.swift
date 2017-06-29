
//  PlayBack Page.swift
//  ixRecorder
//
//  Created by David Brown on 6/28/17.
//  Copyright © 2017 David Brown. All rights reserved.
//

import UIKit
import AVFoundation


class Playback_Page: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    var receivedAudio: URL?
    var audioPlayer: AVAudioPlayer?
    var engine: AVAudioEngine!
    var file: AVAudioFile!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        engine = AVAudioEngine()

        do {
            file = try AVAudioFile(forReading: receivedAudio!, commonFormat: AVAudioCommonFormat.pcmFormatFloat32, interleaved: false)
 
        } catch let error as NSError {
            //soundFile = nil
            fatalError("Error creating soundFile, \(error.localizedDescription)")
        }
    }
    
    public func playAudio(value: Float, rateOrPitch: String) {
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        engine.stop()
        engine.reset()
        
        engine.attach(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (rateOrPitch == "rate") {
            changeAudioUnitTime.rate = value
        } else {
            changeAudioUnitTime.pitch = value
        }
        
        
        engine.attach(changeAudioUnitTime)
        engine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        engine.connect(changeAudioUnitTime, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(file!, at: nil, completionHandler: nil)
        
        do {
            try engine.start()
        } catch {
            print("Error starting engine")
        }
        
        audioPlayerNode.play()
    }
    
    func mixedAudio(rateLevel: Float, pitchLevel: Float) {
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        engine.stop()
        engine.reset()
        
        engine.attach(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        changeAudioUnitTime.rate = rateLevel
        changeAudioUnitTime.pitch = pitchLevel
        
        engine.attach(changeAudioUnitTime)
        engine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        engine.connect(changeAudioUnitTime, to: engine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(file!, at: nil, completionHandler: nil)
        
        do {
            try engine.start()
        } catch {
            print("Error starting engine")
        }
        
        audioPlayerNode.play()
    }

 
    @IBAction func Audio(_ sender: Any) {
        playAudio(value: 1, rateOrPitch: "rate")
    }
    
    @IBAction func highAudio(_ sender: Any) {
        playAudio(value: 1000, rateOrPitch: "pitch")
    }
    
    @IBAction func lowAudio(_ sender: Any) {
        playAudio(value: -500, rateOrPitch: "pitch")
    }
    
    @IBAction func bunnyAudio(_ sender: Any) {
        playAudio(value: 2, rateOrPitch: "rate")
    }
    
    @IBAction func slothAudio(_ sender: Any) {
        playAudio(value: 0.5, rateOrPitch: "rate")
    }
    
    @IBAction func mammothAudio(_ sender: Any) {
        mixedAudio(rateLevel: 0.3, pitchLevel: -500)
    }
    
    @IBAction func hummingbirdAudio(_ sender: Any) {
        mixedAudio(rateLevel: 4, pitchLevel: 1000)
    }

    

}
