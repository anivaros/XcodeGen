import XCTest
import ProjectSpec
import XcodeGenKit

final class ProjectFormatTests: XCTestCase {
    func testProjectFormatSettingsAreAppliedToGeneratedProject() throws {
        try assertProjectFormat(
            "xcode16_3",
            objectVersion: 90,
            compatibilityVersion: nil,
            preferredProjectObjectVersion: 90
        )
        try assertProjectFormat(
            "xcode16_0",
            objectVersion: 77,
            compatibilityVersion: nil,
            preferredProjectObjectVersion: 77
        )
        try assertProjectFormat(
            "xcode15_3",
            objectVersion: 63,
            compatibilityVersion: "Xcode 15.3",
            preferredProjectObjectVersion: nil
        )
        try assertProjectFormat(
            "xcode15_0",
            objectVersion: 60,
            compatibilityVersion: "Xcode 15.0",
            preferredProjectObjectVersion: nil
        )
        try assertProjectFormat(
            "xcode14_0",
            objectVersion: 56,
            compatibilityVersion: "Xcode 14.0",
            preferredProjectObjectVersion: nil
        )
    }

    func testDefaultProjectFormatIsUsedWhenNotSpecified() throws {
        let project = makeProject(projectFormat: nil)
        let pbxProj = try project.generatePbxProj()
        XCTAssertEqual(pbxProj.objectVersion, 77)
        XCTAssertEqual(pbxProj.projects.first?.compatibilityVersion, nil)
        XCTAssertEqual(pbxProj.projects.first?.preferredProjectObjectVersion, 77)
    }

    private func assertProjectFormat(
        _ projectFormat: String,
        objectVersion: UInt,
        compatibilityVersion: String?,
        preferredProjectObjectVersion: Int?
    ) throws {
        let project = makeProject(projectFormat: projectFormat)
        let pbxProj = try project.generatePbxProj()
        XCTAssertEqual(pbxProj.objectVersion, objectVersion)
        XCTAssertEqual(pbxProj.projects.first?.compatibilityVersion, compatibilityVersion)
        XCTAssertEqual(pbxProj.projects.first?.preferredProjectObjectVersion, preferredProjectObjectVersion)
    }

    private func makeProject(projectFormat: String?) -> Project {
        Project(
            name: "ProjectFormatTests",
            targets: [
                Target(
                    name: "App",
                    type: .application,
                    platform: .iOS
                ),
            ],
            options: SpecOptions(projectFormat: projectFormat)
        )
    }
}
