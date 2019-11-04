//
//  Grid.swift
//  NanoChallengeGameOfLife
//
//  Created by Pedro Henrique Guedes Silveira on 01/11/19.
//  Copyright © 2019 Pedro Henrique Guedes Silveira. All rights reserved.
//

import Foundation

public class Grid {
    
    public var gridArray: [GridElement]
    public var rowSize: Int
    public var numberOfElements: Int
    
    init(rowSize: Int, numberOfElements: Int){
        self.rowSize = rowSize
        self.numberOfElements = numberOfElements
        self.gridArray = []
                
        for i in 0..<numberOfElements {
            guard let x = findElementPosition(by: i)?.0 else {
                return
            }
            guard let y = findElementPosition(by: i)?.1 else {
                return
            }
            let gridElement = GridElement(x: x, y: y)
            gridArray.append(gridElement)
        }
    }
    
    func findElementPosition(by Index: Int) -> (Int, Int)? {
        let index = Index
        if index <= numberOfElements {
            let x = index / rowSize
            let y = index % rowSize
            
            return (x, y)
        }
        
        return nil
        
    }
    
    func findElementIndex(by xPosition: Int, by yPosition: Int) -> Int? {
        let x = xPosition
        let y = yPosition
        if x >= 0 && y >= 0 {
            let index = (x * rowSize) + y
            if index <= numberOfElements, x < rowSize, y < numberOfElements / rowSize {
                return index
            }
        }
        return nil
    }
        
    
    func calculateNumberOfLines () -> Int{
        
        let lines: Int
        lines = self.numberOfElements / self.rowSize
        return lines
    }
}
