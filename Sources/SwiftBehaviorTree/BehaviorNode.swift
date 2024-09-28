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

public class BehaviorNode<Blackboard> {
    
    var id: UUID = UUID()
    
    var name: String { "" }
    
    var delegate: BehaviorNodeDelegate?
    
    init() {}
    
    func initialize(with blackboard: Blackboard, delegate: BehaviorNodeDelegate?) {
        self.delegate = delegate
    }
    
    @discardableResult
    func tick(with blackboard: Blackboard) -> BehaviorStatus {
        delegate?.didTick(nodeName: name)
        return .failure
    }
    
    func onAbort(with blackboard: Blackboard) {}
    
    func addChild(_ behaviorNode: BehaviorNode) throws {}
    
    func removeChild(_ behaviorNode: BehaviorNode) throws {}
    
    func removeChildren() throws {}
}

extension BehaviorNode {
    static func == (lhs: BehaviorNode, rhs: BehaviorNode) -> Bool {
        return lhs.id == rhs.id
    }
}
