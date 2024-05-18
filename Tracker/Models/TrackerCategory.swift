import Foundation

struct TrackerCategory {
    
    let title: String
    let trackers: [Tracker]
}

struct CategoriesMock {
    
    static let shared = CategoriesMock()
    
    let categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Обучение",
            trackers: [Tracker(
                id: UUID(),
                name: "Практикум",
                color: .color1,
                emoji: "👨‍💻",
                schedule: [WeekDay.monday,
                           WeekDay.thursday,
                           WeekDay.friday]),
                       
                       Tracker(
                        id: UUID(),
                        name: "Языки",
                        color: .color2,
                        emoji: "🤔",
                        schedule: [WeekDay.monday,
                                   WeekDay.wednesday]
                       )
            ]
        ),
        TrackerCategory(
            title: "Дом",
            trackers: [Tracker(
                id: UUID(),
                name: "Уборка",
                color: .color3,
                emoji: "🤯",
                schedule: [WeekDay.tuesday,
                           WeekDay.wednesday,
                           WeekDay.thursday,
                           WeekDay.friday]
            ),
                       Tracker(
                        id: UUID(),
                        name: "Готовка",
                        color: .color4,
                        emoji: "😇",
                        schedule: [WeekDay.saturday]
                       ),
                       
                       Tracker(
                        id: UUID(),
                        name: "Отдых",
                        color: .color5,
                        emoji: "🥶",
                        schedule: [WeekDay.friday]
                       )
            ]
        )
    ]
}
