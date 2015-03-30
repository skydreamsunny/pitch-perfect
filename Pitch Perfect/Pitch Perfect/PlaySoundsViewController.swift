//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Steven on 18/03/2015.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create AVAudioPlayer instance to play slow / fast sound
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Create AVAudioEngine instance to play sound effect on sound
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        
        stopAudio()
        
        // Play the audio slowly
        playSound(0.5)
        
    }

    @IBAction func playFastSound(sender: UIButton) {
        
        stopAudio()
        
        // Play the audio quickly
        playSound(1.5)
        
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        
        stopAudio()
        
        // Play chip munk sound
        playSoundWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthVaderSound(sender: UIButton) {
        
        stopAudio()
        
        // Play darth vader sound
        playSoundWithVariablePitch(-1000)
        
    }
    
    @IBAction func stopSound(sender: UIButton) {
        
        // Stop playing sound
        stopAudio()
        
    }
    
    @IBAction func playSoundWithReverbEffect(sender: UIButton) {
        
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset( AVAudioUnitReverbPreset.LargeHall )
        reverbEffect.wetDryMix = 80.0
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    /**
    Play sound using AVAudioPlayer instance
    
    @param rate The speed rate
    */
    func playSound( rate: Float ) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    /**
    Play sound using AVAudioEngine instance
    
    @param pith The pitch value
    */
    func playSoundWithVariablePitch(pitch: Float) {
        
        stopAudio()
        
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
    
    /**
    Stop All Audio
    */
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
