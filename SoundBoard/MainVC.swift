//
//  MainVC.swift
//  SoundBoard
//
//  Created by David Boles on 2/20/17.
//  Copyright © 2017 David Boles. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var theTableView: UITableView!
    
    
    var audioPlayer : AVAudioPlayer?
    
    var sounds : [Sound] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView.dataSource = self
        theTableView.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            sounds = try theContext.fetch(Sound.fetchRequest())
            theTableView.reloadData()
        } catch {}
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theCell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
        
        theCell.textLabel?.text = sound.name
        
        return theCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            audioPlayer = try AVAudioPlayer(data: sound.audio as! Data)
            audioPlayer?.play()
        } catch {}
        theTableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sound = sounds[indexPath.row]
            let theContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            theContext.delete(sound)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                sounds = try theContext.fetch(Sound.fetchRequest())
                theTableView.reloadData()
            } catch {}

        }
    }
    
}

