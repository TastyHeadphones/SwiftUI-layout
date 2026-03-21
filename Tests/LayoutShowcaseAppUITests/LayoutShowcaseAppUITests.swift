import XCTest

final class LayoutShowcaseAppUITests: XCTestCase {
    private let demoScreens: [(title: String, fileName: String)] = [
        ("AnyLayout Adaptation", "02-anylayout-adaptation"),
        ("Custom Flow Layout", "03-custom-flow-layout"),
        ("Anchor Preferences", "04-anchor-preferences"),
        ("ViewThatFits Dashboard", "05-viewthatfits-dashboard")
    ]

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testCaptureAllScreens() throws {
        let outputDirectory = try makeOutputDirectory()
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Layout Showcase"].waitForExistence(timeout: 8))
        try captureScreenshot(named: "01-layout-showcase-home", to: outputDirectory)

        for demo in demoScreens {
            let cell = app.staticTexts[demo.title].firstMatch
            XCTAssertTrue(cell.waitForExistence(timeout: 8), "Missing list row: \(demo.title)")
            cell.tap()

            XCTAssertTrue(app.navigationBars[demo.title].waitForExistence(timeout: 8), "Failed to open screen: \(demo.title)")
            try captureScreenshot(named: demo.fileName, to: outputDirectory)

            let backButton = app.navigationBars.buttons.firstMatch
            XCTAssertTrue(backButton.waitForExistence(timeout: 8))
            backButton.tap()

            XCTAssertTrue(app.navigationBars["Layout Showcase"].waitForExistence(timeout: 8))
        }
    }
}

private extension LayoutShowcaseAppUITests {
    func makeOutputDirectory() throws -> URL {
        let fileManager = FileManager.default
        let environment = ProcessInfo.processInfo.environment

        let basePath = environment["SCREENSHOT_OUTPUT_DIR"]
            ?? NSTemporaryDirectory().appending("layout-showcase-screenshots")
        let url = URL(fileURLWithPath: basePath, isDirectory: true)

        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    func captureScreenshot(named fileName: String, to directory: URL) throws {
        let screenshot = XCUIScreen.main.screenshot()
        let outputURL = directory.appendingPathComponent("\(fileName).png")
        try screenshot.pngRepresentation.write(to: outputURL)
    }
}
