import Foundation

/// The default outcome type for any Repository / Manager call.
///
/// Default choice per Flutter rules. Upgrade to `CotdLongResult` only when an
/// actual domain-specific failure case emerges during implementation.
enum CotdResult<T> {
    case success(T)
    case failure
    case networkIssue
}

extension CotdResult {
    /// Map the success payload, preserving failure cases.
    func map<U>(_ transform: (T) -> U) -> CotdResult<U> {
        switch self {
        case .success(let value): .success(transform(value))
        case .failure: .failure
        case .networkIssue: .networkIssue
        }
    }

    /// Get the success value, or nil if not a success.
    var value: T? {
        if case .success(let v) = self { return v }
        return nil
    }
}

/// `LongResult` — adds a domain-specific issue case to `CotdResult`.
/// Use only when a domain failure mode actually exists (per Flutter rules: progressive upgrade only).
enum CotdLongResult<T, E> {
    case success(T)
    case failure
    case networkIssue
    case domainIssue(E)
}

extension CotdLongResult {
    func map<U>(_ transform: (T) -> U) -> CotdLongResult<U, E> {
        switch self {
        case .success(let value): .success(transform(value))
        case .failure: .failure
        case .networkIssue: .networkIssue
        case .domainIssue(let e): .domainIssue(e)
        }
    }

    var value: T? {
        if case .success(let v) = self { return v }
        return nil
    }
}
