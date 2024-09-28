//
//  DecoratorNode.swift
//
//
//  Created by Joey Nelson on 6/9/24.
//

import Foundation

open class DecoratorNode<Blackboard>: BehaviorNode<Blackboard> {
    
    public typealias Child = BehaviorNode<Blackboard>
    
    public var child: Child?
    
    public init(child: Child) {
        self.child = child
    }
    
    open override func initialize(with blackboard: Blackboard, delegate: BehaviorNodeDelegate?) {
        super.initialize(with: blackboard, delegate: delegate)
        self.child?.initialize(with: blackboard, delegate: delegate)
    }
    
    open override func addChild(_ behaviorNode: Child) throws {
        self.child = behaviorNode
    }
    
    open override func removeChild(_ behaviorNode: Child) throws {
        if let child, child == behaviorNode {
            self.child = nil
        }
    }
    
    open override func removeChildren() throws {
        child = nil
    }
    
}

public class InfiniteRepeaterDecoratorNode<Blackboard>: DecoratorNode<Blackboard> {
    public override func tick(with blackboard: Blackboard) -> BehaviorStatus {
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
    public override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        super.tick(with: blackboard)
        guard let child else { return .failure }
        let currentStatus = child.tick(with: blackboard)
        return currentStatus.inverted
    }
}

public class ObserverAbortNode<Blackboard>: DecoratorNode<Blackboard> {
    
    public var conditional: BehaviorNode<Blackboard>
    
    public init(child: Child, if conditional: BehaviorNode<Blackboard>) {
        self.conditional = conditional
        super.init(child: child)
    }

    public override func tick(with blackboard: Blackboard) -> BehaviorStatus {
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
