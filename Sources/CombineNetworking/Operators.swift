import Foundation

precedencegroup LoaderChainingPrecedence {
    higherThan: NilCoalescingPrecedence
    associativity: right
}

infix operator --> : LoaderChainingPrecedence

@discardableResult
public func --> (lhs: HTTPLoader, rhs: HTTPLoader) -> HTTPLoader {
    lhs.nextLoader = rhs
    return lhs
}
