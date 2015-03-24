//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Matthew Murphy on 2/10/15.
//  Copyright (c) 2015 Matthew Murphy. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioPlayerForReverb:[AVAudioPlayer] = []
    var audioPlayerForEcho:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    let N:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayerForEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
            audioPlayerForReverb.append(temp)
        }
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    func playAudio(aRate: Float) {
        resetAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = aRate
        audioPlayer.volume = 1.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
       playAudio(0.5)
    }
 
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        resetAudio()
   
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)

        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset( AVAudioUnitReverbPreset.Cathedral )
        reverbEffect.wetDryMix  = 50
        audioEngine.attachNode( reverbEffect )
        audioEngine.connect( audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect( reverbEffect, to: audioEngine.outputNode, format: nil )
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        resetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(0.3)
        audioEngine.attachNode( echoNode )
        audioEngine.connect( audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect( echoNode, to: audioEngine.outputNode, format: nil )
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

    }
    
    func resetAudio() {
        audioPlayer.stop()
        audioPlayerForEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        resetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        resetAudio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
