//
//  RecordSoundsViewController
//  Pitch Perfect
//
//  Created by Steven on 10/03/2015.
//  Copyright (c) 2015 Lime. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // It's possible to combine tapToRecordLabel with recordLabel, but evaluation criteria specifically said that Record Button should be hidden by default and shown after record button is tapped
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingStateButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var isRecordingPaused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Show tap to record label
        tapToRecordLabel.hidden = false
        
        // Hide the record label
        recordLabel.hidden = true
        
        // Hide the stop button
        stopButton.hidden = true
        
        // Hide the recording state button
        recordingStateButton.hidden = true
        
        // Enable the record button
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if ( flag ) {
           
            // Save the recorded audio
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            
            // Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            // Display error message
            println("Recording was not successful")
            
            // Re-enable record button and hide stop button
            recordButton.enabled = true
            stopButton.hidden = true
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "stopRecording" ) {
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        
        // Show the recording label
        recordLabel.hidden = false
        
        // Show the stop button
        stopButton.hidden = false
        
        // Show pause recording button
        recordingStateButton.hidden = false
        
        // Disable the record button
        recordButton.enabled = false
        
        // Hide tap to record label
        tapToRecordLabel.hidden = true
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        
        // Hide record label
        recordLabel.hidden = true
        
        // If recording is paused, update the button and label title
        if ( isRecordingPaused ) {
            isRecordingPaused = false
            recordingStateButton.setTitle("Pause Recording", forState: .Normal)
            recordLabel.text = "Recording.."
        }
        
        // Stop audio recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func updateRecordingState(sender: UIButton) {
        
        if ( !isRecordingPaused ) {
            
            // Pause recording
            audioRecorder.pause()
            isRecordingPaused = true
            recordingStateButton.setTitle("Resume Recording", forState: .Normal)
            recordLabel.text = "Recording paused.."
            
        } else {
            
            // Resume recording
            audioRecorder.record()
            isRecordingPaused = false
            recordingStateButton.setTitle("Pause Recording", forState: .Normal)
            recordLabel.text = "Recording.."
            
        }
        
    }
    
}

