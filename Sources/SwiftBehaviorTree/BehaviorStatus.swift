//
//  BehaviorStatus.swift
//
//
//  Created by Joey Nelson on 6/8/24.
//

import Foundation

public enum BehaviorStatus {
    case success, failure, running
    
    public var inverted: BehaviorStatus {
        switch self {
        case .success: .failure
        case .failure: .success
        case .running: .running
        }
    }
}
