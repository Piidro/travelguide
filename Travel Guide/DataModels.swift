import Foundation
import CoreLocation

struct GeoSearchResponse: Codable {
    var batchcomplete: String?
    var query: GeoSearchQueryResult?
    var queryContinue: GeoSearchQueryContinue?

    var picontinue: Int? {
        queryContinue?.picontinue
    }

    enum CodingKeys: String, CodingKey {
        case batchcomplete, query
        case queryContinue = "continue"
    }
}

struct GeoSearchQueryResult: Codable {
    var pages: [String: GeoSearchItem]

    var items: [GeoSearchItem] {
        Array(pages.values)
    }
}

struct GeoSearchItem: Codable, Hashable {
    var pageid: Int?
    var ns: Int?
    var title: String?
    var index: Int
    var thumbnail: GeoSearchItemThumbnail?
    var pageimage: String?
    var coordinates: [GeoSearchItemCoordinates]
    var contentmodel: String?
    var pagelanguage: String?
    var pagelanguagehtmlcode: String?
    var pagelanguagedir: String?
    //var touched: Date?
    var lastrevid: Int?
    var length: Int?
    var fullurl: URL?
    var editurl: URL?
    var canonicalurl: URL?
}

struct GeoSearchItemThumbnail: Codable, Hashable {
    var source: URL?
    var width: Int
    var height: Int
}

struct GeoSearchItemCoordinates: Codable, Hashable {
    var lat: Double
    var lon: Double
    var primary: String
    var globe: String
    var dist: Double

    var location: CLLocation {
        CLLocation(latitude: lat, longitude: lon)
    }
}

struct GeoSearchQueryContinue: Codable, Hashable {
    var picontinue: Int
}

let languages = [
   "ar": "العربية",
   "id": "Bahasa Indonesia",
   "ms": "Bahasa Melayu",
   "bg": "Български",
   "ca": "Català",
   "cs": "Čeština",
   "da": "Dansk",
   "de": "Deutsch",
   "en": "English",
   "simple": "Simple English",
   "es": "Español",
   "eo": "Esperanto",
   "et": "Eesti",
   "eu": "Euskara",
   "fr": "Français",
   "gl": "Galego",
   "hr": "Hrvatski",
   "he": "עברית",
   "fa": "فارسی",
   "hi": "हिन्दी",
   "it": "Italiano",
   "ja": "日本語",
   "kk": "Қазақша",
   "ko": "한국어",
   "lt": "Lietuvių",
   "hu": "Magyar",
   "nl": "Nederlands",
   "nn": "Nynorsk",
   "no": "Norsk (Bokmål)",
   "uz": "O‘zbek",
   "pl": "Polski",
   "pt": "Português",
   "ru": "Русский",
   "ro": "Română",
   "ceb": "Sinugboang Binisaya",
   "sk": "Slovenčina",
   "sr": "Српски / Srpski",
   "fi": "Suomi",
   "sv": "Svenska",
   "vi": "Tiếng Việt",
   "tr": "Türkçe",
   "uk": "Українська",
   "vo": "Volapük",
   "war": "Winaray",
   "zh": "中文"
]
