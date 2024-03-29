//
//  GameViewController.swift
//  NanoChallengeGameOfLife
//
//  Created by Pedro Henrique Guedes Silveira on 31/10/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var grid: GridView?
    var tiles: [TileView]?
    var currentTime = 0.2
    var enabled = false
    var dead: [TileView] = []
    var demiDeads: [TileView] = []
    var survivors: [TileView] = []
    var constructors: [TileView] = []
    var timeInterval: TimeInterval = 0.0
    var playButton: UIButton?
    var sceneView: SCNView?
    var zPosition: Float = 0
    let scene = SCNScene(named: "art.scnassets/SceneKit Scene.scn")!
    let cameraNode = SCNNode()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        grid = GridView(rowSize: 40, numberOfElements: 1600)
        
        guard let grid = grid else {
            return
        }
        
        tiles = grid.tiles
        
        guard let tiles = tiles else {
            return
        }
        
        for i in tiles {
            scene.rootNode.addChildNode(i.tile)
        }
        
 
        
        sceneView = {
            guard let view = self.view as? SCNView else {
                fatalError("Não foi possível inicializar a view")
            }
            view.delegate = self
            view.scene = scene
            view.allowsCameraControl = true
            view.showsStatistics = true
            view.loops = true
            return view
        }()
        
        
        let tapInTile = UITapGestureRecognizer(target: self, action: #selector(selectTile))
    
        sceneView?.addGestureRecognizer(tapInTile)
        
        
        playButton = UIButton(frame: .zero)
        setPlayButton()
        setCamera()
        setLightNode()
        setAmbientLighNode()
  
    }
    
    func setCamera() {
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
    }
    
    func setPlayButton() {
        guard let playButton = playButton else {
              return
          }
          
        playButton.addTarget(self, action: #selector(tapPlayButton), for: .touchDown)
        playButton.backgroundColor = UIColor.red
        self.view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        playButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setLightNode() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
    }
    
    func setAmbientLighNode() {
        let ambientLighNode = SCNNode()
        ambientLighNode.light = SCNLight()
        ambientLighNode.light?.type = .ambient
        ambientLighNode.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLighNode)
    }
    
    @objc func tapPlayButton() {
        
        if sceneView?.isPlaying ?? false {
            sceneView?.isPlaying = false
        } else {
            sceneView?.isPlaying = true
        }
    }
    
    
    @objc func selectTile(_ gestureRecognizer: UIGestureRecognizer) {
        
        guard let scnView = self.view as? SCNView else {
            return
        }
        
        let position = gestureRecognizer.location(in: scnView)
        
        let hitResults = scnView.hitTest(position, options: [:])
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            guard let tile = result.node as? TileNode else {
                return
            }
            if tile.tileView?.type == .dead{
                tile.tileView?.changeTileState(state: true)
            }
            if tile.tileView?.type == .alive {
                tile.tileView?.changeTileState(state: false)
            }
                        
        }
    }
    
    func nextGeneration() {
        
        guard let tiles = grid?.tiles else {
            return
        }
        
        for tile in tiles {
                        
            let aliveNeighbors = grid?.aliveNeighbor(by: tile.x, by: tile.y)
            
            if tile.type == .alive {
                switch aliveNeighbors {
                case 1:
                    demiDeads.append(tile)
                case 2,3:
                    survivors.append(tile)
                default:
                    demiDeads.append(tile)
                }
            }

            if tile.type == .demiAlive{
                switch aliveNeighbors {
                case 1:
                    dead.append(tile)
                case 2,3:
                    survivors.append(tile)
                default:
                    dead.append(tile)
                }
            }
            
            if tile.type == .dead {
                switch aliveNeighbors {
                case 3:
                    survivors.append(tile)
                default:
                    dead.append(tile)
                }
            }
        }
    }
    
    
    
    func setBronzeGeneration() {
        for survivor in survivors {
            survivor.changeTileState(state: true)
        }
        
        for dead in dead{
            dead.changeTileState(state: false)
        }
    }
    

    func setSilverGeneration() {
        for survivor in survivors {
            survivor.changeTileState(state: true)
            let survivorCopy = survivor.copy()
            constructors.append(survivorCopy as! TileView)
            survivor.position.z = zPosition
        }
        
        for dead in dead{
            dead.changeTileState(state: false)
        }
        
        for constructor in constructors {
            scene.rootNode.addChildNode(constructor.tile)
            constructor.changeConstructTileState(state: false)
            constructor.position.z = zPosition - 0.8
        }
        
        zPosition += 0.8
    }
    
    func setGoldGeneration() {
        
        for survivor in survivors {
            survivor.changeTileState(state: true)
            let survuvorCopy = survivor.copy()
            constructors.append(survuvorCopy as! TileView)
            survivor.position.z = zPosition
        }
        
        for demiDead in demiDeads {
            demiDead.changeTileState(state: true)
            demiDead.position.z = zPosition
        }
        
        for dead in dead {
            dead.changeTileState(state: false)
        }
        
        for constructor in constructors {
            scene.rootNode.addChildNode(constructor.tile)
            constructor.changeConstructTileState(state: false)
            constructor.position.z = zPosition - 0.8
        }
        
        zPosition += 0.8
    }

    
    func cleanArray() {
        survivors.removeAll(keepingCapacity: false)
        dead.removeAll(keepingCapacity: false)
        demiDeads.removeAll(keepingCapacity: false)
        constructors.removeAll(keepingCapacity: false)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            
            if timeInterval < 0.01 {
                timeInterval = time
            }
            
            let deltaTime = time - timeInterval
            
        if deltaTime > currentTime && sceneView?.isPlaying == true {
                nextGeneration()
                setGoldGeneration()
                cleanArray()
                
                timeInterval = time
                                
            }
        
    }
}
