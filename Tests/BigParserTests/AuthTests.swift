import XCTest
@testable import BigParser

final class AuthTests: XCTestCase {

    func testLogin() async throws {
        let expectation = XCTestExpectation(description: "Log in")

        do {
            try await BigParser.shared.logIn(LoginRequest(
                emailId: "tester@unittesting.test",
                password: "vn0a9n2-svmadd-an8e62e-7cclw2",
                loggedIn: true)
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }

    func testSignUp() async throws {
        let expectation = XCTestExpectation(description: "Sign Up")

        do {
            try await BigParser.shared.signUp(
                SignUpRequest(
                    fullName: "Tester von Testburg",
                    emailId: "tester@unittesting.test",
                    password: "vn0a9n2-svmadd-an8e62e-7cclw2"
                )
            )
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        await fulfillment(of: [expectation], timeout: 3)
    }
}
