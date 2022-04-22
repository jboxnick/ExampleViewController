//
//  ExampleViewController.swift
//  App.app
//
//  Created by Julian Boxnick on 22.04.22.
//

import UIKit
import AVKit

class PlayerUIView: UIView {
    
    //MARK: - Properties
    
    private let video = "myVideo"
    private let playerLayer = AVPlayerLayer()
    private var counter = 0
    
    //MARK: - Initializer

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        guard let fileUrl = Bundle.main.url(forResource: video, withExtension: "mov") else { return }
        
        let player = AVPlayer(url: fileUrl)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Schleife Setup
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)

        // Player starten
        player.play()
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        
        counter += 1
        
        if counter == 5 {
            print("5 Mal abgespielt!")
            playerLayer.player?.pause()
            playerLayer.player = nil
        } else {
            playerLayer.player?.seek(to: CMTime.zero)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = bounds
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
}


//MARK: - ViewController

class ExampleViewController: UIViewController {
    
    //MARK: - Outlets
    
    //Klasse im Storyboard muss unbedingt auf PlayerUIView gesetzt werden!
    @IBOutlet weak var videoView: PlayerUIView!
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
