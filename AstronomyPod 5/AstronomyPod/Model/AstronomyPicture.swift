import UIKit

struct AstronomyPicture: Codable {
    var explanation: String
    var hdurl: URL
    var mediaType: String
    var title: String
    var data: Data?
    
    enum CodingKeys: String, CodingKey {
        case explanation
        case hdurl
        case mediaType = "media_type"
        case title
        case data
    }
}
