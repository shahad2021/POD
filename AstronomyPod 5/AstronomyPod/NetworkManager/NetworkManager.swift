import Foundation
import UIKit
class NetworkManager {
    private init () { }
    static let shared  = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()


    func getPlanetaryImage(for urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            // Return cached image if available
            completion(cachedImage)
        } else {
            guard let url = URL(string: urlString) else {
                // Handle invalid URL error
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let imageData = data, let downloadedImage = UIImage(data: imageData) else {
                    // Handle error if unable to download or create image
                    completion(nil)
                    return
                }
                self.cache.setObject(downloadedImage, forKey: urlString as NSString)
                completion(downloadedImage)
            }.resume()
        }
    }

        func fetchImageOfTheDay(completion: @escaping (AstronomyPicture?) -> Void) {

            guard let url = AstronomyPictureAPI.EndPoints.pictureOfTheDay.url else {
                // Handle invalid URL error
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    // Handle request error
                    print("Error fetching APOD: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    // Handle empty response data
                    completion(nil)
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                    let decoder = JSONDecoder()
                    let photo = try decoder.decode(AstronomyPicture.self, from: data)
                    completion(photo)
                } catch {
                    // Handle JSON parsing error
                    print("Error parsing APOD response: \(error.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }

}
