import UIKit

extension UIViewController {
    
    func alertOk(title: String, message: String?) {
        let alertCotroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alertCotroller.addAction(ok)
        
        present(alertCotroller, animated: true, completion: nil)
    }
}
