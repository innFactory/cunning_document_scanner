import Foundation

enum CunningScannerImageFormat: String {
    case jpg
    case png
}

enum CunningScannerSource: String {
    case camera
    case gallery
    case cameraAndGallery = "camera_and_gallery"
}

struct CunningScannerOptions {
    let imageFormat: CunningScannerImageFormat
    let jpgCompressionQuality: Double
    let asPdf: Bool
    let isGalleryImportAllowed: Bool
    let scannerSource: CunningScannerSource

    init() {
        self.imageFormat = .png
        self.jpgCompressionQuality = 1.0
        self.asPdf = false
        self.isGalleryImportAllowed = false
        self.scannerSource = .camera
    }

    init(imageFormat: CunningScannerImageFormat, jpgCompressionQuality: Double, asPdf: Bool, isGalleryImportAllowed: Bool, scannerSource: CunningScannerSource) {
        self.imageFormat = imageFormat
        self.jpgCompressionQuality = jpgCompressionQuality
        self.asPdf = asPdf
        self.isGalleryImportAllowed = isGalleryImportAllowed
        self.scannerSource = scannerSource
    }

    static func fromArguments(args: Any?) -> CunningScannerOptions {
        guard let arguments = args as? [String: Any] else {
            return CunningScannerOptions()
        }

        let asPdf = (arguments["asPdf"] as? Bool) ?? false
        let isGalleryImportAllowed = (arguments["isGalleryImportAllowed"] as? Bool) ?? false
        let sourceString = arguments["scannerSource"] as? String
        let scannerSource = CunningScannerSource(rawValue: sourceString ?? "") ?? (isGalleryImportAllowed ? .cameraAndGallery : .camera)
        
        let scannerOptionsDict = arguments["iosScannerOptions"] as? [String: Any]
        let imageFormat = (scannerOptionsDict?["imageFormat"] as? String) ?? "png"
        let jpgCompressionQuality = (scannerOptionsDict?["jpgCompressionQuality"] as? Double) ?? 1.0

        return CunningScannerOptions(
            imageFormat: CunningScannerImageFormat(rawValue: imageFormat) ?? .png,
            jpgCompressionQuality: jpgCompressionQuality,
            asPdf: asPdf,
            isGalleryImportAllowed: isGalleryImportAllowed,
            scannerSource: scannerSource
        )
    }
}
