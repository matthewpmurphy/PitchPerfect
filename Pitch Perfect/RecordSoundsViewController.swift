//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Murphy on 2/5/15.
//  Copyright (c) 2015 Gonzostew. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var lblRecording: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop, pause, and resume buttons by default
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        //set recording label to default
        lblRecording.text = "tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func recordAudio(sender: UIButton) {
        //update recording label to alert user that recording has commenced
        lblRecording.text = "recording in progress"
        //hide record button and enable stop/pause
        recordButton.enabled = false;
        stopButton.hidden = false
        pauseButton.hidden = false
        
        //setup file path/name information
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            let recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            //move to next schene
            self.performSegueWithIdentifier("iStopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            stopButton.hidden = true;   
        }
        
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        //set recording label to instruct user on how to resume recording
        lblRecording.text = "press play to resume"
        //Hide pause and reveal resume
        pauseButton.hidden = true
        resumeButton.hidden = false
        //pause recording
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        //notify user recording has resumed
        lblRecording.text = "recording in progress"
        //hide resume and reveal pause
        pauseButton.hidden = false
        resumeButton.hidden = true
        //start recording again
        audioRecorder.record()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "iStopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        //enable record button
        recordButton.enabled = true
        //Stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

