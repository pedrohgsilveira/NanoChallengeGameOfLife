//
//  TileType.swift
//  NanoChallengeGameOfLife
//
//  Created by Pedro Henrique Guedes Silveira on 06/11/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//


public enum TileType: Int {

    case alive = 1
    case demiAlive = 2
    case dead = 3

    var isAlive: Bool {
        switch self {
        case .alive:
            return true
        case .demiAlive:
            return true
        case .dead:
            return false
        }
    }
  
}
