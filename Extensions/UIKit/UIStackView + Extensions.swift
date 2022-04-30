import UIKit

extension UIStackView {
    
    convenience init(arrangeSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
    self.init(arrangedSubviews: arrangeSubviews)
    self.axis = axis
    self.spacing = spacing
    self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
