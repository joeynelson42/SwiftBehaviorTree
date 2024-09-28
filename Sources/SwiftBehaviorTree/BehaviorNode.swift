//
//  BehaviorNode.swift
//
//
//  Created by Joey Nelson on 6/8/24.
//

import Foundation

enum BehaviorNodeError: Error {
    
    case childNodeHasParent
    
    case leafNodeHasNoChildren
    
}

public protocol BehaviorNodeDelegate {
    
    func didTick(nodeName: String)
    
}

open class BehaviorNode<Blackboard> {
    
    open var id: UUID = UUID()
    
    open var name: String { "" }
    
    public var delegate: BehaviorNodeDelegate?
    
    public init() {}
    
    open func initialize(with blackboard: Blackboard, delegate: BehaviorNodeDelegate?) {
        self.delegate = delegate
    }
    
    @discardableResult
    open func tick(with blackboard: Blackboard) -> BehaviorStatus {
        delegate?.didTick(nodeName: name)
        return .failure
    }
    
    open func onAbort(with blackboard: Blackboard) {}
    
    open func addChild(_ behaviorNode: BehaviorNode) throws {}
    
    open func removeChild(_ behaviorNode: BehaviorNode) throws {}
    
    open func removeChildren() throws {}
}

public extension BehaviorNode {
    static func == (lhs: BehaviorNode, rhs: BehaviorNode) -> Bool {
        return lhs.id == rhs.id
    }
}
