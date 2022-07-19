import Foundation
import UIKit

class ActivityDatabase {
    static let shared = ActivityDatabase()
    private init() {}
    
    // list of Activities
    private var activitiesList:[Activity] = [
        Activity(name: "Tour of Eiffel Tower", price: 52, image: "eiffel-tower",hostingName: "CITY AGENCY",
                 describtion: "A 60-minute guided tour of the most famous works of Tour of Eiffel Tower. Bring a camera!",isPopular: true, websiteLink: "https://www.hackingwithswift.com"),
        Activity(name: "Riverboat Cruise", price: 30, image: "riverboat",hostingName: "BOAR AGENCY", describtion: "A 60-minute guided tour of the most famous works of Riverboat Cruise. Bring a camera!",isPopular: false, websiteLink: "https://www.vedettesdupontneuf.com/home/"),
        Activity(name: "Art at the Louvre", price: 55, image: "Louvre",hostingName: "EXPLORE AGENCY", describtion: "A 60-minute guided tour of the most famous works of Art at the Louvre. Bring a camera!",isPopular: false, websiteLink: "https://www.louvre.fr/en/explore"),
        Activity(name: "French Pastry Tour", price: 100, image: "french-pastries",hostingName: "LOCAL AGENCY", describtion: "A 60-minute guided tour of the most famous works of French Pastry Tour. Bring a camera!",isPopular: false, websiteLink: "https://doucefrance.ca"),
        Activity(name: "Cabaret Show", price: 85, image: "carbaret-show",hostingName: "Smith Burgh", describtion: "A 60-minute guided tour of the most famous works of Cabaret Show. Bring a camera!",isPopular: true, websiteLink: "https://www.lido.fr/en")
    ]
    
    private var activitiesListLondon:[Activity] = [
        Activity(name: "Activity1", price: 1, image: "",hostingName: "CITY WONDERS",describtion: "A 60-minute guided tour of the most famous works of Tour of Eiffel Tower . Bring a camera!",isPopular: false, websiteLink: ""),
        Activity(name: "Activity2", price: 2, image: "",hostingName: "CITY WONDERS",describtion: "A 60-minute guided tour of the most famous works of Tour of Eiffel Tower . Bring a camera!",isPopular: false, websiteLink: "https://www.google.com")
    ]
    
   
    
    func getAll() -> [Activity] {
        return activitiesList
    }
    
    func getAllLondon() -> [Activity] {
        return activitiesListLondon
    }
    
    
}
