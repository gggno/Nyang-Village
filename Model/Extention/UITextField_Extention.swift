import Foundation
import UIKit

extension UITextField {

    func addLeftPadding() {
    
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }

    func setIcon(_ image: UIImage) {
       
        let iconView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
       iconView.image = image
       
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 50, height: 30))
        iconContainerView.addSubview(iconView)
       
        self.leftView = iconContainerView
        self.leftViewMode = .always
    }
}
