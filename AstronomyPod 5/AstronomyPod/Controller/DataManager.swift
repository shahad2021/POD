
import Foundation
import CoreData
import UIKit
import StoreKit

class DataManager{
    
    static let shared = DataManager()
    let moc = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
  
    
    func saveImages(pictire: AstronomyPicture){
        let pic = getImages()
        let url = pictire.hdurl
        let urls = pic.map{ $0.url!}
        guard !urls.contains(url) else{
            return
        }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "AstronomyPictureModel", into: moc!) as? AstronomyPictureModel
        entity?.title = pictire.title
        entity?.url = pictire.hdurl
        entity?.explanation = pictire.explanation
        entity?.imageData = pictire.data
        saveMOC()
    }
    
    func getImages() -> [AstronomyPictureModel]{
        var pics = [AstronomyPictureModel]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AstronomyPictureModel")
        do{
            pics = try (moc?.fetch(fetchRequest) as? [AstronomyPictureModel])!
        }catch{
            print("can not get data")
        }
        return pics
    }
    
    func deleteImages(index: URL) {
        let pic = getImages()
        let urls = pic.map{ $0.url!}
        guard urls.contains(index) else{
            return
        }
        pic.forEach { img in
            if img.url == index{
                moc?.delete(img)
                saveMOC()
            }
        }
    }
    
    func deleteAllImage(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AstronomyPictureModel")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try moc?.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Failed to clear Core Data: \(error), \(error.userInfo)")
        }

    }
    
    func saveMOC(){
        do {
            try moc?.save()
            print("Image saved successfully.")
        } catch {
            print("Failed to save image: \(error)")
        }
    }
}
