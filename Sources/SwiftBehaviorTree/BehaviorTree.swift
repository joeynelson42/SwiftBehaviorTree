//
//  BehaviorTree.swift
//  
//
//  Created by Joey Nelson on 6/9/24.
//

import Foundation

public protocol Tickable {
    func tick()
}

public final class BehaviorTree<Blackboard>: Tickable {
    private var blackboard: Blackboard
    
    private var delegate: BehaviorNodeDelegate?
    
    private var rootNode: BehaviorNode<Blackboard>
    
    init(blackboard: Blackboard, rootNode: BehaviorNode<Blackboard>, delegate: BehaviorNodeDelegate?) {
        self.blackboard = blackboard
        self.rootNode = rootNode
        self.delegate = delegate
        
        self.rootNode.initialize(with: blackboard, delegate: delegate)
    }
    
    private var isFinished: Bool = false
    
    public func tick() {
        guard !isFinished else { return }
        let status = rootNode.tick(with: blackboard)

        if status != .running {
            isFinished = true
            print("behavior tree has finished running with a result of \(status)")
        }
    }
}

