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

    func testSearchGrid() async throws {
        let authId = "fcd0b8a0-5fae-449d-a977-0426915f42a0"
        let gridId = "638f43e7cc3151353d14a63a"
        let shareId = "638f48d68108ee25ecc3a11a"

        let expectation = XCTestExpectation(description: "Search")

        BigParser.shared.authId = authId

        let query = Query(
            globalFilter: GlobalFilter(filters: [GlobalFilterFilter(filterOperator: "LIKE", keyword: "Paper")],
                             filtersJoinOperator: "OR"),
            columnFilter: nil,
            sort: nil,
            pagination: Pagination(startRow: 0, rowCount: 100)
        )

        do {
            let response = try await BigParser.shared.searchGrid(
                gridId,
                shareId: shareId,
                searchRequest: SearchRequest(query: query))
            print(response)
            expectation.fulfill()
        } catch {
            XCTFail("\(error)")
        }

        wait(for: [expectation], timeout: 3)
    }
}
