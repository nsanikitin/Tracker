import CoreData
import Foundation

final class TrackerRecordStore: NSObject {
    
    // MARK: - Properties
    
    static let shared = TrackerRecordStore()
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    var trackersRecordCoreData: [TrackerRecordCoreData] {
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
            preconditionFailure("Failed to initialize TrackerRecordStore: \(error)")
        }
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    // MARK: - Methods
    
    func addTrackerRecordToCoreData(for trackerRecord: TrackerRecord) {
        guard let trackerRecordEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else { return }
        let trackerRecordEntity = TrackerRecordCoreData(entity: trackerRecordEntityDescription, insertInto: context)
        trackerRecordEntity.id = trackerRecord.id
        trackerRecordEntity.date = trackerRecord.date
        
        do {
            try context.save()
        } catch {
            assertionFailure("Can't add a tracker record")
        }
    }
    
    func deleteTrackerRecordFromCoreData(for trackerRecord: TrackerRecord) {
        guard let recordForDeletion = fetchedResultsController?.fetchedObjects?.first(
            where: { $0.id == trackerRecord.id && $0.date == trackerRecord.date}
        ) else { return }
        context.delete(recordForDeletion)
        
        do {
            try context.save()
        } catch {
            assertionFailure("Can't delete a tracker record")
        }
    }
    
    func fetchTrackersRecordFromCoreData() -> Set<TrackerRecordCoreData> {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let trackersRecordFromCoreData = try? context.fetch(request) else {
            return []
        }
        return Set(trackersRecordFromCoreData)
    }
    
    func convertTrackerRecordCoreDataToTrackerRecord(for trackerRecord: TrackerRecordCoreData) -> TrackerRecord? {
        guard
            let id = trackerRecord.id,
            let date = trackerRecord.date
        else { return nil }
        
        return TrackerRecord(
            id: id,
            date: date
        )
    }
}
