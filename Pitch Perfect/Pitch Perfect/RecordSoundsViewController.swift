//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thor Nicolaysen on 4/8/15.
//  Copyright (c) 2015 Thor Nicolaysen. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    //var audioPlayerFile = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.text = "Tap to Record"
        pauseLabel.hidden = true;
        pauseAudio.hidden = true;
        stopAudio.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopAudio: UIButton!
    @IBOutlet weak var pauseAudio: UIButton!
    
    @IBAction func recordAudio(sender: UIButton) {
        recordAudio.enabled = false;
        pauseLabel.hidden = false;
        recordingLabel.text = "Recording";
        stopAudio.hidden = false;
        pauseAudio.hidden = false;
  
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        //audioPlayerFile = recordingName

        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(fromFileName: audioRecorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordAudio.enabled = true
            recordingLabel.text = "Tap to Record"
            stopAudio.hidden = true
            pauseLabel.hidden = true
            pauseAudio.hidden = true
        }
    }

    @IBAction func pauseAudio(sender: UIButton) {
        //image swap modified from "http://stackoverflow.com/questions/26837371/how-to-change-uibutton-image-in-swift"
        
        let image = UIImage(named: "record") as UIImage!
        let image1 = UIImage(named: "pause") as UIImage!
        
        if audioRecorder.recording {
            audioRecorder.pause()
            pauseLabel.text = "Tap to resume"
            recordingLabel.text = "Paused"
            pauseAudio.setImage(image, forState: .Normal)
        } else {
            audioRecorder.record()
            pauseLabel.text = "Tap to pause"
            recordingLabel.text = "Recording"
            pauseAudio.setImage(image1, forState: .Normal)
        }
    
    }
    @IBAction func stopAudio(sender: UIButton) {
        recordAudio.enabled = true;
        recordingLabel.text = "Tap to Record";
        stopAudio.hidden = true;
        audioRecorder.stop()
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
 
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}


