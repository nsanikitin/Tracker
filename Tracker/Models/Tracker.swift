import Foundation
import UIKit

struct Tracker {
    
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Schedule]
}

enum Schedule: Equatable {
    case monday
    case tuesday
    case wendeday
    case thursday
    case friday
    case saturdat
    case sunday
    case none
}
