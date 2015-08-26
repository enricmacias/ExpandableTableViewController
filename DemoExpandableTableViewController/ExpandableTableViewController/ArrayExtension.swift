//
//  ArrayExtension.swift
//  scc
//
//  Created by Enric Macias Lopez on 6/25/15.
//  Copyright (c) 2015 株式会社ガラパゴス. All rights reserved.
//

extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(index: Int) -> T? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}