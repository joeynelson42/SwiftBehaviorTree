//
//  LeafNode.swift
//  
//
//  Created by Joey Nelson on 6/8/24.
//

import Foundation

/// Use LeafNode to implement your own behaviors
public class LeafNode<Blackboard>: BehaviorNode<Blackboard> {

    override func addChild(_ behaviorNode: BehaviorNode<Blackboard>) throws {
        throw BehaviorNodeError.leafNodeHasNoChildren
    }
    
    override func removeChild(_ behaviorNode: BehaviorNode<Blackboard>) throws {
        throw BehaviorNodeError.leafNodeHasNoChildren
    }
    
    override func removeChildren() throws {
        throw BehaviorNodeError.leafNodeHasNoChildren
    }
}

/// LeafNode that always immediately succeeds. Used for testing purposes.
public class SucceedingLeafNode<Blackboard>: LeafNode<Blackboard> {
    override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        super.tick(with: blackboard)
        return .success
    }
}

/// LeafNode that always immediately fails. Used for testing purposes.
public class FailingLeafNode<Blackboard>: LeafNode<Blackboard> {
    override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        super.tick(with: blackboard)
        return .failure
    }
}
