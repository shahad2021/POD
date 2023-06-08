
import Foundation
import CoreData


extension AstronomyPictureModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AstronomyPictureModel> {
        return NSFetchRequest<AstronomyPictureModel>(entityName: "AstronomyPictureModel")
    }

    @NSManaged public var url: URL?
    @NSManaged public var title: String?
    @NSManaged public var explanation: String?
    @NSManaged public var imageData: Data?
    
}

extension AstronomyPictureModel : Identifiable {

}
