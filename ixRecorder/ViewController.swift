import UIKit
import AVFoundation


class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopButton.isEnabled = false
        stopButton.isHidden = true
        rightArrow.isHidden = true
        recordButton.isHidden = false
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        stopButton.isHidden = false
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        rightArrow.isHidden = false
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
            shouldPerformSegue(withIdentifier: "stopRecording", sender: sender)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let pitchVC: Playback_Page = segue.destination as! Playback_Page
            pitchVC.receivedAudio = (audioRecorder?.url)!
     
}
}
