import CoreData
import Foundation

protocol TrackerCategoryStoreDelegate: AnyObject {
    
    func updateCategories()
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Properties
    
    static let shared = TrackerCategoryStore()
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    weak var delegate: TrackerCategoryStoreDelegate?
    var trackerCategoriesCoreData: [TrackerCategoryCoreData] {
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
            preconditionFailure("Failed to initialize TrackerCategoryStore: \(error)")
        }
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
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
    
    func addTrackerCategoryToCoreData(categoryTitle: String) {
        guard let trackerCategoryEntityDescription = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return }
        let newTrackerCategoryEntity = TrackerCategoryCoreData(entity: trackerCategoryEntityDescription, insertInto: context)
        newTrackerCategoryEntity.title = categoryTitle
        
        do {
            try context.save()
        } catch {
            assertionFailure("Can't add a category")
        }
    }
    
    func deleteTrackerCategoryFromCoreData(for category: TrackerCategory) {
        guard let categoryForDeletion = fetchedResultsController?.fetchedObjects?.first(where: { $0.title == category.title }) else { return }
        context.delete(categoryForDeletion)
        
        do {
            try context.save()
        } catch {
            assertionFailure("Can't delete a category")
        }
    }
    
    func fetchTrackerCategoriesFromCoreData() -> [TrackerCategoryCoreData] {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        guard let trackerCategoriesFromCoreData = try? context.fetch(request) else {
            return []
        }
        return trackerCategoriesFromCoreData
    }
    
    func convertTrackerCategoryCoreDataToTrackerCategory(for trackerCategory: TrackerCategoryCoreData) -> TrackerCategory? {
        guard
            let title = trackerCategory.title,
            let trackers = trackerCategory.trackers
        else { return nil }
        
        return TrackerCategory(
            title: title,
            trackers: trackers.compactMap { trackerCoreData -> Tracker? in
                guard let trackerCoreData = trackerCoreData as? TrackerCoreData else { return nil }
                return TrackerStore.shared.convertTrackerCoreDataToTracker(for: trackerCoreData)
            }
        )
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        // TODO: - Add action with delegate after creation of categories screen
    }
}
