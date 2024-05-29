import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    // MARK: - Properties
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    var viewModelsCells: [CategoryTableViewCellModel] = []
    var categoriesCoreData: [TrackerCategoryCoreData] = []
    var selectedCategoryCoreData: TrackerCategoryCoreData?
    var categories: Binding<[TrackerCategoryCoreData]>?
    var selectedCategory: Binding<TrackerCategoryCoreData>?
    
    // MARK: - Methods
    
    private func updateViewModelsCells() {
        viewModelsCells.removeAll()
        for categoryCoreData in categoriesCoreData {
            viewModelsCells.append(
                CategoryTableViewCellModel(text: categoryCoreData.title ?? "",
                                           shouldMakeCornerRadius: false,
                                           shouldSetCheckmark: false)
            )
        }
        viewModelsCells.indices.last.map { viewModelsCells[$0].shouldMakeCornerRadius = true }
        setCategorySelection()
    }

    private func setCategorySelection() {
        if let selectedCategoryCoreData = selectedCategoryCoreData {
            guard let index = categoriesCoreData.firstIndex(of: selectedCategoryCoreData) else { return }
            viewModelsCells[index].shouldSetCheckmark = true
        }
    }
    
    private func resetCategorySelection() {
        guard let index = viewModelsCells.firstIndex(where: { $0.shouldSetCheckmark == true }) else { return }
        viewModelsCells[index].shouldSetCheckmark = false
    }
    
    func fetchTrackerCategoriesFromCoreData() {
        categoriesCoreData = trackerCategoryStore.fetchTrackerCategoriesFromCoreData()
        updateViewModelsCells()
    }
    
    func updateCategories(with categoryTitle: String) {
        trackerCategoryStore.addTrackerCategoryToCoreData(categoryTitle: categoryTitle)
        fetchTrackerCategoriesFromCoreData()
        categories?(trackerCategoryStore.fetchTrackerCategoriesFromCoreData())
    }
    
    func selectCategory(with category: TrackerCategoryCoreData) {
        resetCategorySelection()
        selectedCategoryCoreData = category
        selectedCategory?(category)
    }
}
