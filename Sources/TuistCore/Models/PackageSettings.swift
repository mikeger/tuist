import Foundation
import XcodeGraph

/// Contains the description of custom SPM settings
public struct PackageSettings: Equatable, Codable {
    /// The custom `Product` types to be used for SPM targets.
    public let productTypes: [String: Product]

    /// Custom destinations to be used for SPM products.
    public let productDestinations: [String: Destinations]

    // The base settings to be used for targets generated from SwiftPackageManager
    public let baseSettings: Settings

    /// The custom `Settings` to be applied to SPM targets
    public let targetSettings: [String: SettingsDictionary]

    /// The custom project options for each project generated from a swift package
    public let projectOptions: [String: XcodeGraph.Project.Options]

    /// A Boolean value that indicates whether the test targets of local swift packages are included in generated project.
    ///
    /// - Note: When generating an [SPM package](https://docs.tuist.io/guide/project/directory-structure.html#swift-package),
    /// test targets are always included regardless of the value of this property.
    public var includeLocalPackageTestTargets: Bool

    /// Swift tools version of the parsed `Package.swift`
    public let swiftToolsVersion: Version

    /// Initializes a new `PackageSettings` instance.
    /// - Parameters:
    ///    - productTypes: The custom `Product` types to be used for SPM targets.
    ///    - productDestinations: Custom destinations to be used for SPM products.
    ///    - baseSettings: The base settings to be used for targets generated from SwiftPackageManager
    ///    - targetSettings: The custom `SettingsDictionary` to be applied to denoted targets
    ///    - projectOptions: The custom project options for each project generated from a swift package
    ///    - includeLocalPackageTestTargets: A Boolean value that indicates whether the test targets of
    ///    local swift packages are included in the generated project.
    ///    - swiftToolsVersion: Swift tools version of the parsed `Package.swift`
    public init(
        productTypes: [String: Product],
        productDestinations: [String: Destinations],
        baseSettings: Settings,
        targetSettings: [String: SettingsDictionary],
        projectOptions: [String: XcodeGraph.Project.Options] = [:],
        includeLocalPackageTestTargets: Bool,
        swiftToolsVersion: Version
    ) {
        self.productTypes = productTypes
        self.productDestinations = productDestinations
        self.baseSettings = baseSettings
        self.targetSettings = targetSettings
        self.projectOptions = projectOptions
        self.includeLocalPackageTestTargets = includeLocalPackageTestTargets
        self.swiftToolsVersion = swiftToolsVersion
    }
}

#if DEBUG
    extension PackageSettings {
        public static func test(
            productTypes: [String: Product] = [:],
            productDestinations: [String: Destinations] = [:],
            baseSettings: Settings = Settings.default,
            targetSettings: [String: SettingsDictionary] = [:],
            projectOptions: [String: XcodeGraph.Project.Options] = [:],
            includeLocalPackageTestTargets: Bool = false,
            swiftToolsVersion: Version = Version("5.4.9")
        ) -> PackageSettings {
            PackageSettings(
                productTypes: productTypes,
                productDestinations: productDestinations,
                baseSettings: baseSettings,
                targetSettings: targetSettings,
                projectOptions: projectOptions,
                includeLocalPackageTestTargets: includeLocalPackageTestTargets,
                swiftToolsVersion: swiftToolsVersion
            )
        }
    }
#endif
