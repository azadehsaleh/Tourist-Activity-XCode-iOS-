import Foundation
class Activity: Codable {
    var name:String
    var price:Double
    var image:String
    var hostingName:String
    var describtion:String
    var isPopular:Bool
    var websiteLink:String

    init(name:String,price:Double,image:String,hostingName:String,describtion:String,isPopular:Bool,websiteLink:String){
        self.name = name
        self.price = price
        self.image = image
        self.hostingName = hostingName
        self.describtion = describtion
        self.isPopular = isPopular
        self.websiteLink = websiteLink
    }
}
