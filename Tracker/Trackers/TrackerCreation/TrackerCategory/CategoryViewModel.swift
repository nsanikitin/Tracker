import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    // MARK: - Properties
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    var categories: Binding<[TrackerCategoryCoreData]>?
    var selectedCategory: Binding<TrackerCategoryCoreData>?
    
    // MARK: - Methods
    
    func fetchTrackerCategoriesFromCoreData() {
        categories?(trackerCategoryStore.fetchTrackerCategoriesFromCoreData())
    }
    
    func selectCategory(with category: TrackerCategoryCoreData) {
        selectedCategory?(category)
    }
}
