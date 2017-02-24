//
//  SoundVC.swift
//  SoundBoard
//
//  Created by David Boles on 2/20/17.
//  Copyright © 2017 David Boles. All rights reserved.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController  {
    
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer?
    var theAudioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTheRecorder()
        //Pro Tip Below xxx.isEnabled   
        playBtn.isEnabled = false
        addBtn.isEnabled = false
        
        
        
    }//
    
    func setUpTheRecorder() {
        do {
            
            //create an audio session
            let theSession = AVAudioSession.sharedInstance()
            try theSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try theSession.overrideOutputAudioPort(.speaker)
            try theSession.setActive(true)
            
            //create URL for the audio file
            let theBasePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let thePathComponents = [theBasePath, "audio.m4a"]
            theAudioURL = NSURL.fileURL(withPathComponents: thePathComponents)!
            

            
            //create settings for the audio recorder
            
            var theSettings : [String:AnyObject] = [:]
            theSettings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            theSettings[AVSampleRateKey] = 44100.0 as AnyObject?
            theSettings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //create audio recorder object
            audioRecorder = try AVAudioRecorder(url: theAudioURL!, settings: theSettings)
            audioRecorder!.prepareToRecord()
        } catch let err as NSError {
            print(err)
            
        }
    }
    
    
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            //stop recording + Pro Tip Below xxx.isEnabled
            audioRecorder?.stop()
            playBtn.isEnabled = true
            addBtn.isEnabled = true

            
            
            //change title button to record
            //Pro Tip Below xxx.setTitle
            recordBtn.setTitle("Record", for: .normal)
            
        } else {
            //start recording
            audioRecorder?.record()
            
            //change button title to stop
            recordBtn.setTitle("Stop", for: .normal)
        }
        
        

        
    }
    
    
    @IBAction func playBtnPressed(_ sender: Any) {
        do {
       try  audioPlayer = AVAudioPlayer(contentsOf: theAudioURL!)
        
        audioPlayer!.play()
        
        } catch {}
        
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        let theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: theContext)
        
        sound.name = textField.text
        sound.audio = NSData(contentsOf: theAudioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
        
        
        
        
    }
}//
