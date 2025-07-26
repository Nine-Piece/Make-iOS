import ProjectDescription

let projectName = "APP_NAME_PLACEHOLDER"
let bundleId = "BUNDLE_ID_PLACEHOLDER"
let iosVersion = "IOS_VERSION_PLACEHOLDER"

// Project Settings
let projectSettings = Settings.settings(
    configurations: [
        .debug(name: "Debug", xcconfig: .relativeToRoot("Configurations/Debug.xcconfig")),
        .release(name: "Release", xcconfig: .relativeToRoot("Configurations/Release.xcconfig"))
    ]
)

// Main App Target
let mainTarget = Target.target(
    name: projectName,
    destinations: .iOS,
    product: .app,
    bundleId: bundleId,
    deploymentTargets: .iOS(iosVersion),
    infoPlist: .extendingDefault(with: [:]),
    sources: ["Targets/\(projectName)/Sources/**"],
    resources: ["Targets/\(projectName)/Resources/**"],
    dependencies: [
        // Dependencies will be added here dynamically
    ],
    settings: .settings(
        base: [:],
        configurations: [
            .debug(
                name: "Debug",
                settings: [
                    "PRODUCT_BUNDLE_IDENTIFIER": "\(bundleId).dev",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon-Debug",
                    "INFOPLIST_FILE": "Targets/\(projectName)/Resources/Info-Debug.plist",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
                    "OTHER_SWIFT_FLAGS": "-D DEBUG"
                ]
            ),
            .release(
                name: "Release",
                settings: [
                    "PRODUCT_BUNDLE_IDENTIFIER": "\(bundleId)",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "INFOPLIST_FILE": "Targets/\(projectName)/Resources/Info-Release.plist",
                    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE"
                ]
            )
        ]
    )
)

// Unit Tests Target
let unitTestsTarget = Target.target(
    name: "\(projectName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "\(bundleId).tests",
    deploymentTargets: .iOS(iosVersion),
    infoPlist: .default,
    sources: ["Targets/\(projectName)Tests/Sources/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

// UI Tests Target
let uiTestsTarget = Target.target(
    name: "\(projectName)UITests",
    destinations: .iOS,
    product: .uiTests,
    bundleId: "\(bundleId).uitests",
    deploymentTargets: .iOS(iosVersion),
    infoPlist: .default,
    sources: ["Targets/\(projectName)UITests/Sources/**"],
    dependencies: [
        .target(name: projectName)
    ]
)

// Schemes
let devScheme = Scheme.scheme(
    name: "\(projectName)-Dev",
    shared: true,
    buildAction: .buildAction(
        targets: [TargetReference(stringLiteral: projectName)]
    ),
    testAction: .targets(
        [TestableTarget(stringLiteral: "\(projectName)Tests")],
        configuration: "Debug"
    ),
    runAction: .runAction(
        configuration: "Debug",
        executable: TargetReference(stringLiteral: projectName)
    ),
    archiveAction: .archiveAction(configuration: "Debug"),
    profileAction: .profileAction(
        configuration: "Debug",
        executable: TargetReference(stringLiteral: projectName)
    ),
    analyzeAction: .analyzeAction(configuration: "Debug")
)

let releaseScheme = Scheme.scheme(
    name: "\(projectName)",
    shared: true,
    buildAction: .buildAction(
        targets: [TargetReference(stringLiteral: projectName)]
    ),
    testAction: .targets(
        [TestableTarget(stringLiteral: "\(projectName)Tests")],
        configuration: "Release"
    ),
    runAction: .runAction(
        configuration: "Release",
        executable: TargetReference(stringLiteral: projectName)
    ),
    archiveAction: .archiveAction(configuration: "Release"),
    profileAction: .profileAction(
        configuration: "Release",
        executable: TargetReference(stringLiteral: projectName)
    ),
    analyzeAction: .analyzeAction(configuration: "Release")
)

// Project
let project = Project(
    name: projectName,
    organizationName: "YourOrganization",
    packages: [
        // SPM packages will be added here dynamically
    ],
    settings: projectSettings,
    targets: [mainTarget, unitTestsTarget, uiTestsTarget],
    schemes: [devScheme, releaseScheme]
)