import UIKit

extension UIViewController {
   
    public func presentAlert(_ message: String, title: String, actionTitle: String = "Ok", animated: Bool = true, rotationAngle: CGFloat? = nil, okHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: okHandler))

        present(alert, animated: animated) {
            guard let rotationAngle = rotationAngle else { return }
            alert.view.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}
