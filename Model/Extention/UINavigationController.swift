import Foundation
import UIKit

extension UINavigationController {
    
    /* 해당 코드는 UINavigationController의 extension으로, pushViewController 메서드를 wrapping하여 애니메이션과 함께 ViewController를 push할 때, completion handler를 실행할 수 있도록 구현한 것입니다. 코드의 주요 기능은 다음과 같습니다.
    
    viewName 매개변수를 통해 push할 ViewController의 identifier를 전달받습니다.
    UIStoryboard를 통해 해당 identifier를 가진 ViewController 인스턴스를 생성합니다.
    pushViewController를 호출하여 생성된 ViewController를 push합니다.
    애니메이션을 사용하여 push하는 경우, transitionCoordinator를 통해 애니메이션이 완료된 후 completion handler를 실행합니다. 애니메이션을 사용하지 않는 경우, DispatchQueue.main.async를 통해 즉시 completion handler를 실행합니다. */
    
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
