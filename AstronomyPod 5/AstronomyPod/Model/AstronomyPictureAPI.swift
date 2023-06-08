import UIKit

class AstronomyPictureAPI {
    
    static let apikey = "eGRxJhhe4ger77tcDZXIvh8aLwT6GgG5oGfAbMJX"
    
    enum EndPoints {
        case pictureOfTheDay
        var url: URL? {
            return URL(string: self.stringValue)
        }
        var stringValue: String {
            switch self {
            case .pictureOfTheDay:
                return "https://api.nasa.gov/planetary/apod?api_key=\(AstronomyPictureAPI.apikey)"
            }
        }
    }
}
