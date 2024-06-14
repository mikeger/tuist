// swift-tools-version:5.10

import PackageDescription

let swiftToolsSupportDependency: Target.Dependency = .product(name: "SwiftToolsSupport-auto", package: "swift-tools-support-core")
let pathDependency: Target.Dependency = .product(name: "Path", package: "Path")
let loggingDependency: Target.Dependency = .product(name: "Logging", package: "swift-log")
let argumentParserDependency: Target.Dependency = .product(name: "ArgumentParser", package: "swift-argument-parser")
let swiftGenKitDependency: Target.Dependency = .product(name: "SwiftGenKit", package: "SwiftGen")

var targets: [Target] = [
    .executableTarget(
        name: "tuistbenchmark",
        dependencies: [
            argumentParserDependency,
            pathDependency,
            swiftToolsSupportDependency,
        ]
    ),
    .executableTarget(
        name: "tuistfixturegenerator",
        dependencies: [
            argumentParserDependency,
            pathDependency,
            swiftToolsSupportDependency,
        ]
    ),
    .target(
        name: "TuistCore",
        dependencies: [
            pathDependency,
            "ProjectDescription",
            "TuistSupport",
            "XcodeGraph",
            "XcodeProj",
            "Mockable",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistCoreTesting",
        dependencies: [
            "TuistCore",
            "TuistSupportTesting",
            pathDependency,
        ],
        linkerSettings: [.linkedFramework("XCTest")]
    ),
    .target(
        name: "TuistKit",
        dependencies: [
            "XcodeProj",
            pathDependency,
            argumentParserDependency,
            "TuistSupport",
            "TuistGenerator",
            "TuistAutomation",
            "ProjectDescription",
            "ProjectAutomation",
            "TuistLoader",
            "TuistScaffold",
            "TuistDependencies",
            "GraphViz",
            "TuistMigration",
            "TuistAsyncQueue",
            "TuistAnalytics",
            "TuistPlugin",
            "XcodeGraph",
            "Mockable",
            "TuistServer",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .executableTarget(
        name: "tuist",
        dependencies: [
            "TuistKit",
            "ProjectDescription",
            "ProjectAutomation",
            swiftToolsSupportDependency,
        ]
    ),
    .target(
        name: "ProjectDescription",
        dependencies: []
    ),
    .target(
        name: "ProjectAutomation"
    ),
    .target(
        name: "TuistSupport",
        dependencies: [
            pathDependency,
            loggingDependency,
            swiftToolsSupportDependency,
            "KeychainAccess",
            "ZIPFoundation",
            "ProjectDescription",
            "Mockable",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistSupportTesting",
        dependencies: [
            "TuistSupport",
            "XcodeGraph",
            pathDependency,
            "Difference",
        ],
        linkerSettings: [.linkedFramework("XCTest")]
    ),
    .target(
        name: "TuistAcceptanceTesting",
        dependencies: [
            "TuistKit",
            "TuistCore",
            "TuistSupport",
            "TuistSupportTesting",
            "XcodeProj",
            pathDependency,
        ],
        linkerSettings: [.linkedFramework("XCTest")]
    ),
    .target(
        name: "TuistGenerator",
        dependencies: [
            "XcodeProj",
            pathDependency,
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "GraphViz",
            swiftGenKitDependency,
            "StencilSwiftKit",
            "Mockable",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistGeneratorTesting",
        dependencies: [
            "TuistGenerator",
            pathDependency,
        ],
        linkerSettings: [.linkedFramework("XCTest")]
    ),
    .target(
        name: "TuistScaffold",
        dependencies: [
            pathDependency,
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "StencilSwiftKit",
            "Stencil",
            "Mockable",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistAutomation",
        dependencies: [
            "XcodeProj",
            pathDependency,
            .product(name: "XcbeautifyLib", package: "xcbeautify"),
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "Mockable",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistDependencies",
        dependencies: [
            "ProjectDescription",
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "TuistPlugin",
            "Mockable",
            pathDependency,
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistMigration",
        dependencies: [
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "XcodeProj",
            "Mockable",
            pathDependency,
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistAsyncQueue",
        dependencies: [
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "XcodeProj",
            "Mockable",
            pathDependency,
            "Queuer",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistLoader",
        dependencies: [
            "XcodeProj",
            pathDependency,
            "TuistCore",
            "XcodeGraph",
            "TuistSupport",
            "Mockable",
            "ProjectDescription",
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistLoaderTesting",
        dependencies: [
            "TuistLoader",
            pathDependency,
            "TuistCore",
            "ProjectDescription",
            "TuistSupportTesting",
        ],
        linkerSettings: [.linkedFramework("XCTest")]
    ),
    .target(
        name: "TuistAnalytics",
        dependencies: [
            .byName(name: "AnyCodable"),
            "TuistAsyncQueue",
            "TuistCore",
            "XcodeGraph",
            "TuistLoader",
            "Mockable",
            pathDependency,
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistPlugin",
        dependencies: [
            "XcodeGraph",
            "TuistLoader",
            "TuistSupport",
            "TuistScaffold",
            "Mockable",
            pathDependency,
        ],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
    .target(
        name: "TuistServer",
        dependencies: [
            "TuistCore",
            "TuistSupport",
            pathDependency,
            .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession"),
        ],
        exclude: ["OpenAPI/cloud.yml"],
        swiftSettings: [
            .define("MOCKING", .when(configuration: .debug)),
        ]
    ),
]

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "SystemPackage": .staticFramework,
            "TSCBasic": .staticFramework,
            "TSCUtility": .staticFramework,
            "TSCclibc": .staticFramework,
            "TSCLibc": .staticFramework,
            "ArgumentParser": .staticFramework,
            "Mockable": .staticFramework,
            "MockableTest": .staticFramework,
        ]
    )

#endif

let package = Package(
    name: "tuist",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "tuistbenchmark", targets: ["tuistbenchmark"]),
        .executable(name: "tuistfixturegenerator", targets: ["tuistfixturegenerator"]),
        .executable(name: "tuist", targets: ["tuist"]),
        .library(
            name: "ProjectDescription",
            type: .dynamic,
            targets: ["ProjectDescription"]
        ),
        .library(
            name: "ProjectAutomation",
            type: .dynamic,
            targets: ["ProjectAutomation"]
        ),
        .library(
            name: "TuistKit",
            targets: ["TuistKit"]
        ),
        .library(
            name: "TuistSupport",
            targets: ["TuistSupport"]
        ),
        .library(
            name: "TuistSupportTesting",
            targets: ["TuistSupportTesting"]
        ),
        .library(
            name: "TuistCore",
            targets: ["TuistCore"]
        ),
        .library(
            name: "TuistCoreTesting",
            targets: ["TuistCoreTesting"]
        ),
        .library(
            name: "TuistLoader",
            targets: ["TuistLoader"]
        ),
        .library(
            name: "TuistLoaderTesting",
            targets: ["TuistLoaderTesting"]
        ),
        .library(
            name: "TuistAnalytics",
            targets: ["TuistAnalytics"]
        ),
        .library(
            name: "TuistAutomation",
            targets: ["TuistAutomation"]
        ),
        .library(
            name: "TuistDependencies",
            targets: ["TuistDependencies"]
        ),
        .library(
            name: "TuistAcceptanceTesting",
            targets: ["TuistAcceptanceTesting"]
        ),
        .library(
            name: "TuistServer",
            targets: ["TuistServer"]
        ),
        /// TuistGenerator
        ///
        /// A high level Xcode generator library
        /// responsible for generating Xcode projects & workspaces.
        ///
        /// This library can be used in external tools that wish to
        /// leverage Tuist's Xcode generation features.
        ///
        /// Note: This library should be treated as **unstable** as
        ///       it is still under development and may include breaking
        ///       changes in future releases.
        .library(
            name: "TuistGenerator",
            targets: ["TuistGenerator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
        .package(url: "https://github.com/apple/swift-log", from: "1.5.3"),
        .package(url: "https://github.com/apple/swift-tools-support-core", from: "0.6.1"),
        .package(url: "https://github.com/FabrizioBrancati/Queuer", from: "2.1.1"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.7"),
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.17"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/stencilproject/Stencil", exact: "0.15.1"),
        .package(url: "https://github.com/SwiftDocOrg/GraphViz", exact: "0.2.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", exact: "2.10.1"),
        .package(url: "https://github.com/leszko11/SwiftGen", branch: "feature/xcstrings-support"),
        .package(url: "https://github.com/tuist/XcodeProj", exact: "8.19.0"),
        .package(url: "https://github.com/cpisciotta/xcbeautify", exact: "2.0.1"),
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", from: "1.0.2"),
        .package(url: "https://github.com/Kolos65/Mockable.git", from: "0.0.2"),
        .package(url: "https://github.com/tuist/swift-openapi-runtime", branch: "swift-tools-version"),
        .package(url: "https://github.com/tuist/swift-openapi-urlsession", branch: "swift-tools-version"),
        .package(url: "https://github.com/tuist/Path", .upToNextMajor(from: "0.3.0")),
        .package(url: "https://github.com/tuist/XcodeGraph.git", .upToNextMajor(from: "0.5.0")),
    ],
    targets: targets
)
