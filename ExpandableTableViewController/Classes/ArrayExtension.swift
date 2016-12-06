//
//  ArrayExtension.swift
//
//  Created by Enric Macias Lopez on 6/25/15.
//

extension Array {
    
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
