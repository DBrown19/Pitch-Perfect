//
//  ViewController.swift
//  ixRecorder
//
//  Created by David Brown on 6/28/17.
//  Copyright © 2017 David Brown. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopButton.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        // Dispose of any resources that can be recreated.
        super.didReceiveMemoryWarning()
        
        audioRecorder = nil
    }
 
    func setupRecorder()  {
        
      
                }
  
    
    
    @IBAction func playSound(_ sender: Any) {
             finishAudioRecording(success: true)
        StopButton.isHidden = true
        StartButton.isHidden = true
    }


    @IBAction func Record(_ sender: Any) {
        if isAudioRecordingGranted {
            
            //Create the session.
            let session = AVAudioSession.sharedInstance()
            
            do {
                //Configure the session for recording and playback.
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                try session.setActive(true)
                //Set up a high-quality recording session.
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                //Create audio file name URL
                let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
                //Create the audio recording, and assign ourselves as the delegate
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.record()
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            }
            catch let error {
                print("Error for start audio recording: \(error.localizedDescription)")
            }
        }
StopButton.isHidden = false
    }
    func finishAudioRecording(success: Bool) {
        
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
        
        if success {
            print("Recording finished successfully.")
        } else {
            print("Recording failed :(")
        }
    }
    func updateAudioMeter(timer: Timer) {
        
        if audioRecorder.isRecording {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            print (totalTimeString)
         //   recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK:- Audio recoder delegate methods
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            finishAudioRecording(success: false)
        }
    }
}

  
  
