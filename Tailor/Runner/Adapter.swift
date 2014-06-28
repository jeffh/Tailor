import Foundation
import XCTest

protocol AssertionHandler {
    func assert(assertion: Bool, message: String, location: SourceLocation)
}

class XCTestHandler : AssertionHandler {
    func assert(assertion: Bool, message: String, location: SourceLocation) {
        if !assertion {
            XCTFail(message, file: location.file, line: location.line)
        }
    }
}

var CurrentAssertionHandler: AssertionHandler = XCTestHandler()

struct AssertionRecord {
    let success: Bool
    let message: String
    let location: SourceLocation
}

class AssertionRecorder : AssertionHandler {
    var assertions = AssertionRecord[]()

    func assert(assertion: Bool, message: String, location: SourceLocation) {
        assertions.append(
            AssertionRecord(
                success: assertion,
                message: message,
                location: location))
    }
}

func withAssertionHandler(recorder: AssertionHandler, closure: () -> Void) {
    let oldRecorder = CurrentAssertionHandler
    CurrentAssertionHandler = recorder
    closure()
    CurrentAssertionHandler = oldRecorder
}


func fail(message: String, #location: SourceLocation) {
    CurrentAssertionHandler.assert(false, message: message, location: location)
}

func must(assertion: Bool, message: String, #location: SourceLocation) {
    CurrentAssertionHandler.assert(assertion, message: message, location: location)
}