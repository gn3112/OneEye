//
//  PlayerView.swift
//  OneEye
//
//  Created by Georges on 12/06/2020.
//  Copyright © 2020 Nomicos. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class PlayerView: UIView {
    override static var layerClass: AnyClass{
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer?{
        
        get{
            return playerLayer.player;
        }
        set{
            playerLayer.player = newValue;
        }
        
    }
}
