import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    // MARK: - Properties
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    var categoriesCoreData: [TrackerCategoryCoreData] = []
    var selectedCategoryCoreData: TrackerCategoryCoreData?
    var categories: Binding<[TrackerCategoryCoreData]>?
    var selectedCategory: Binding<TrackerCategoryCoreData>?
    
    // MARK: - Methods
    
    func fetchTrackerCategoriesFromCoreData() {
        categoriesCoreData = trackerCategoryStore.fetchTrackerCategoriesFromCoreData()
    }
    
    func updateCategories(with categoryTitle: String) {
        trackerCategoryStore.addTrackerCategoryToCoreData(categoryTitle: categoryTitle)
        categories?(trackerCategoryStore.fetchTrackerCategoriesFromCoreData())
    }
    
    func selectCategory(with category: TrackerCategoryCoreData) {
        selectedCategoryCoreData = category
        selectedCategory?(category)
    }
}
