import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "de13f763-be36-4b24-8486-05220a3e5051") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
