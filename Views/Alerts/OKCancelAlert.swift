import UIKit

extension UIViewController {
    
    func alertOkCancel(title: String, message: String?, completionHandler: @escaping () -> Void) {
        let alertCotroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertCotroller.addAction(ok)
        alertCotroller.addAction(cancel)
        
        present(alertCotroller, animated: true, completion: nil)
    }
}
