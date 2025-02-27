import Foundation
import TuistServer
import TuistSupport

struct AppPreviewsKey: AppStorageKey {
    static let key = "appPreviews"
    static let defaultValue: [AppPreview] = []
}

enum AppPreviewsModelError: FatalError, Equatable {
    case previewNotFound(String)

    var type: ErrorType {
        switch self {
        case .previewNotFound:
            return .abort
        }
    }

    var description: String {
        switch self {
        case let .previewNotFound(displayName):
            return "The latest preview for \(displayName) was not found. Has any preview been published?"
        }
    }
}

@Observable
final class AppPreviewsViewModel: Sendable {
    private(set) var appPreviews: [AppPreview] = [] {
        didSet {
            try? appStorage.set(AppPreviewsKey.self, value: appPreviews)
        }
    }

    private let listProjectsService: ListProjectsServicing
    private let listPreviewsService: ListPreviewsServicing
    private let serverURLService: ServerURLServicing
    private let appCredentialsService: any AppCredentialsServicing
    private let deviceService: any DeviceServicing
    private let appStorage: AppStoring

    init(
        appCredentialsService: any AppCredentialsServicing,
        deviceService: any DeviceServicing,
        listProjectsService: ListProjectsServicing = ListProjectsService(),
        listPreviewsService: ListPreviewsServicing = ListPreviewsService(),
        serverURLService: ServerURLServicing = ServerURLService(),
        appStorage: AppStoring = AppStorage()
    ) {
        self.appCredentialsService = appCredentialsService
        self.deviceService = deviceService
        self.listProjectsService = listProjectsService
        self.listPreviewsService = listPreviewsService
        self.serverURLService = serverURLService
        self.appStorage = appStorage
    }

    func loadAppPreviewsFromCache() {
        appPreviews = (try? appStorage.get(AppPreviewsKey.self)) ?? []
    }

    func onAppear() async throws {
        try await updatePreviews()
    }

    func onAuthenticationStateChanged() async throws {
        try await updatePreviews()
    }

    private func updatePreviews() async throws {
        switch appCredentialsService.authenticationState {
        case .loggedIn:
            let serverURL = serverURLService.serverURL()
            let projects = try await listProjectsService.listProjects(serverURL: serverURL)
            let listPreviewsService = listPreviewsService
            appPreviews = try await projects.concurrentMap { project in
                try await listPreviewsService.listPreviews(
                    displayName: nil,
                    specifier: "latest",
                    supportedPlatforms: [],
                    page: nil,
                    pageSize: nil,
                    distinctField: .bundleIdentifier,
                    fullHandle: project.fullName,
                    serverURL: serverURL
                )
                .compactMap { preview in
                    guard let bundleIdentifier = preview.bundleIdentifier else { return nil }
                    return AppPreview(
                        fullHandle: project.fullName,
                        displayName: preview.displayName ?? project.fullName,
                        bundleIdentifier: bundleIdentifier,
                        iconURL: preview.iconURL
                    )
                }
            }
            .flatMap { $0 }
            .sorted(by: { $0.displayName < $1.displayName })
        case .loggedOut:
            appPreviews = []
        }
    }

    func launchAppPreview(_ appPreview: AppPreview) async throws {
        let serverURL = serverURLService.serverURL()

        let previews = try await listPreviewsService.listPreviews(
            displayName: nil,
            specifier: "latest",
            supportedPlatforms: [deviceService.selectedDevice?.destinationType].compactMap { $0 },
            page: nil,
            pageSize: 1,
            distinctField: nil,
            fullHandle: appPreview.fullHandle,
            serverURL: serverURL
        )

        guard let preview = previews.first else { throw AppPreviewsModelError.previewNotFound(appPreview.displayName) }

        try await deviceService.launchPreview(
            with: preview.id,
            fullHandle: appPreview.fullHandle,
            serverURL: serverURL
        )
    }
}
