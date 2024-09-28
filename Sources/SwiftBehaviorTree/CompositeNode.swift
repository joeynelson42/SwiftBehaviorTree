//
//  CompositeNode.swift
//
//
//  Created by Joey Nelson on 6/8/24.
//

import Foundation

open class CompositeNode<Blackboard>: BehaviorNode<Blackboard> {
    
    public typealias Child = BehaviorNode<Blackboard>
    
    public var children: [Child] = []
    
    var currentNodeIndex: Int = 0
    
    open override func initialize(with blackboard: Blackboard, delegate: BehaviorNodeDelegate? = nil) {
        super.initialize(with: blackboard, delegate: delegate)
        currentNodeIndex = 0
        children.forEach { $0.initialize(with: blackboard, delegate: delegate) }
    }
    
    public required init(children: [Child] = []) {
        self.children = children
    }
    
    public init(_ children: Child...) {
        self.children = children
    }
    
    private var currentNode: Child? { children[safe: currentNodeIndex] }
    
    private var hasMoreChildren: Bool { return children.count > currentNodeIndex + 1 }
    
    func tick(with blackboard: Blackboard, endCondition: BehaviorStatus) -> BehaviorStatus {
        super.tick(with: blackboard)
        guard let currentNode else { return .failure }

        let currentStatus = currentNode.tick(with: blackboard)
        
        if currentStatus == .running || currentStatus == endCondition {
            return currentStatus
        } else if hasMoreChildren {
            currentNodeIndex += 1
            return .running
        } else {
            return currentStatus
        }
    }
    
    open override func onAbort(with blackboard: Blackboard) {
        currentNodeIndex = 0
        children.forEach { $0.onAbort(with: blackboard) }
    }
    
    open override func addChild(_ behaviorNode: Child) throws {
        if children.contains(where: { $0.id == behaviorNode.id }) {
            throw BehaviorNodeError.childNodeHasParent
        } else {
            children.append(behaviorNode)
        }
    }
    
    open override func removeChild(_ behaviorNode: Child) throws {
        children.removeAll(where: { $0.id == behaviorNode.id })
    }
    
    open override func removeChildren() throws {
        children.removeAll()
    }
}

/// Runs until it finds success
public final class SelectorNode<Blackboard>: CompositeNode<Blackboard> {
    
//    override var name: String { "Selector" }
    
    public override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        return tick(with: blackboard, endCondition: .success)
    }
}

/// Runs until it finds Failure
public final class SequenceNode<Blackboard>: CompositeNode<Blackboard> {
    
//    override var name: String { "Sequence" }
    
    public override func tick(with blackboard: Blackboard) -> BehaviorStatus {
        return tick(with: blackboard, endCondition: .failure)
    }
}

fileprivate extension Array {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
