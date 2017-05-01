import ObjectMapper

struct User: Mappable {
    var email: String!
    var password: String!
    var username: String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.email <- map["email"]
        self.password <- map["password"]
        self.username <- map["username"]
    }
    
}
