import XCTest
@testable import BigParserSwiftSDK

final class BigParserSwiftSDKTests: XCTestCase {

    func testLogin() async throws {
        let expectation = XCTestExpectation(description: "Log in")

        do {
            let response = try await BigParser.shared.logIn(LoginRequest(
                emailId: "tester@unittesting.test",
                password: "vn0a9n2-svmadd-an8e62e-7cclw2",
                loggedIn: true)
            )
            print(response)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }

    func testSignUp() async throws {
        let expectation = XCTestExpectation(description: "Sign Up")

        do {
            let response = try await BigParser.shared.signUp(
                SignUpRequest(
                    fullName: "Tester von Testburg",
                    emailId: "tester@unittesting.test",
                    password: "vn0a9n2-svmadd-an8e62e-7cclw2"
                )
            )
            print(response)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }
}
