import Foundation
import UIKit

extension UINavigationController {
    
    public func pushViewController(
        animated: Bool,
        viewName: String,
        completion: @escaping (UIViewController) -> Void)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewName)
        
        pushViewController(vc, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion(vc) }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion(vc) }
    }
}
