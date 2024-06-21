import CoreData
import Foundation

protocol TrackerStoreDelegate: AnyObject {
    
    func updateTrackers()
}

final class TrackerStore: NSObject {
    
    // MARK: - Properties
    
    static let shared = TrackerStore()
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    weak var delegate: TrackerStoreDelegate?
    var trackersCoreData: [TrackerCoreData] {
        guard let objects = self.fetchedResultsController?.fetchedObjects else { return [] }
        return objects
    }
    
    // MARK: - Inits
    
    convenience override init() {
        let persistentContainerCreator = PersistentContainerCreator.shared
        let context = persistentContainerCreator.persistentContainer.viewContext
        do {
            try self.init(context: context)
        } catch {
            preconditionFailure("Failed to initialize TrackerStore: \(error)")
        }
    }
    
    private init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    // MARK: - Methods

    func addTrackerToCoreData(for tracker: Tracker, to category: TrackerCategory) {
        guard let trackerEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCoreData", in: context) else { return }
        let trackerEntity = TrackerCoreData(entity: trackerEntityDescription, insertInto: context)
        trackerEntity.id = tracker.id
        trackerEntity.name = tracker.name
        trackerEntity.emoji = tracker.emoji
        trackerEntity.color = UIColorMarshalling.hexString(from: tracker.color)
        trackerEntity.schedule = tracker.schedule as NSObject
        trackerEntity.isPinned = tracker.isPinned
        trackerEntity.lastCategory = tracker.lastCategory
        
        let categoriesFromCoreData = TrackerCategoryStore.shared.fetchTrackerCategoriesFromCoreData()
        let currentCategory = categoriesFromCoreData.first(where: { $0.title == category.title})
        currentCategory?.addToTrackers(trackerEntity)
        
        do {
            try context.save()
        } catch {
            assertionFailure("Can't add a tracker")
        }
    }
    
    func deleteTrackerFromCoreData(for trackerID: UUID) {
        guard let trackerForDeletion = fetchedResultsController?.fetchedObjects?.first(where: { $0.id == trackerID }) else { return }
        context.delete(trackerForDeletion)
        
        do {
            try context.save()
        } catch {
            assertionFailure("Can't delete a tracker")
        }
    }
    
    func fetchTrackersFromCoreData() -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        guard let trackersFromCoreData = try? context.fetch(request) else {
            return []
        }
        return trackersFromCoreData
    }
    
    func convertTrackerCoreDataToTracker(for tracker: TrackerCoreData) -> Tracker? {
        guard
            let id = tracker.id,
            let name = tracker.name,
            let emoji = tracker.emoji,
            let color = tracker.color,
            let schedule = tracker.schedule,
            let lastCategory = tracker.lastCategory
        else { return nil }
        
        let isPinned = tracker.isPinned
        
        return Tracker(
            id: id,
            name: name,
            color: UIColorMarshalling.color(from: color),
            emoji: emoji,
            schedule: schedule as! [WeekDay], 
            isPinned: isPinned,
            lastCategory: lastCategory
        )
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.updateTrackers()
    }
}
