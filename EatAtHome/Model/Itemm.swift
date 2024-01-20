import Foundation

import FirebaseFirestoreSwift

struct Itemm : Codable, Identifiable {
    @DocumentID var id : String?
    var name : String
    var category : String = ""
    var done: Bool = false
}
