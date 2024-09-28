//
//  DecoratorNode.swift
//
//
//  Created by Joey Nelson on 6/9/24.
//

import Foundation

public class DecoratorNode<Blackboard>: BehaviorNode<Blackboard> {
    
    typealias Child = BehaviorNode<Blackboard>
    
    var child: Child?
    
    init(child: Child) {
        self.child = child
    }
    
    override func initialize(with blackboard: Blackboard, delegate: BehaviorNodeDelegate?) {
        super.initialize(with: blackboard, delegate: delegate)
        self.child?.initialize(with: blackboard, delegate: delegate)
    }
    
    override func addChild(_ behaviorNode: Child) throws {
        self.child = behaviorNode
    }
    
    override func removeChild(_ behaviorNode: Child) throws {
        if let child, child == behaviorNode {
            self.child = nil
        }
    }
    
    override func removeChildren() throws {
        child = nil
    }
    
}

public class InfiniteRepeaterDecoratorNode<Blackboard>: DecoratorNode<Blackboard> {
    override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        super.tick(with: blackboard)
        guard let child else { return .failure }
        let currentStatus = child.tick(with: blackboard)
        if currentStatus != .running {
            initialize(with: blackboard, delegate: delegate)
            child.initialize(with: blackboard, delegate: delegate)
        }
        return .running
    }
}

public class InverterDecoratorNode<Blackboard>: DecoratorNode<Blackboard> {
    override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        super.tick(with: blackboard)
        guard let child else { return .failure }
        let currentStatus = child.tick(with: blackboard)
        return currentStatus.inverted
    }
}

public class ObserverAbortNode<Blackboard>: DecoratorNode<Blackboard> {
    
    var conditional: BehaviorNode<Blackboard>
    
    init(child: Child, if conditional: BehaviorNode<Blackboard>) {
        self.conditional = conditional
        super.init(child: child)
    }

    override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        super.tick(with: blackboard)
        guard let child else { return .failure }
        let conditionStatus = conditional.tick(with: blackboard)
        
        switch conditionStatus {
        case .success:
            return child.tick(with: blackboard)
        case .failure:
            child.onAbort(with: blackboard)
            return .failure
        case .running:
            return .running
        }
    }
}
