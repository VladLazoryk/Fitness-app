import UIKit

class CustomAlert {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    private let alertView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let scrollView = UIScrollView()
    
    private let setsTextField = UITextField()
    private let repsTextField = UITextField()
    
    private var mainView: UIView?
    var buttonAction: ((String, String) -> Void)?
    
    func alertCustom(viewControler: UIViewController, repsOrTimer: String, completion: @escaping (String, String) -> Void) {
        
        registerForKeyboardNotification()
        
        guard let parentView = viewControler.view else {return}
        mainView = parentView
        
        scrollView.frame = parentView.frame
        parentView.addSubview(scrollView)
        
        backgroundView.frame = parentView.frame
        scrollView.addSubview(backgroundView)
        
        alertView.frame = CGRect(x: 40,
                                 y: -430,
                                 width: parentView.frame.width - 80,
                                 height: -430)
        scrollView.addSubview(alertView)
        
        let sportsmanImageView = UIImageView(frame: CGRect(x: (alertView.frame.width - alertView.frame.height * 0.4) / 2,
                                                           y: 30,
                                                           width: alertView.frame.height * 0.4,
                                                           height: alertView.frame.height * 0.4))
        sportsmanImageView.image = UIImage(named: "sportsmanAlert")
        sportsmanImageView.contentMode = .scaleAspectFit
        alertView.addSubview(sportsmanImageView)
        
        let editingLabel = UILabel(frame: CGRect(x: 10,
                                                 y: alertView.frame.height * 0.4 + 50,
                                                 width: alertView.frame.width - 20,
                                                 height: 25))
        editingLabel.text = "Editing"
        editingLabel.textAlignment = .center
        editingLabel.font = .robotoMedium22()
        alertView.addSubview(editingLabel)
        
        let setsLabel = UILabel(text: "Sets")
        setsLabel.translatesAutoresizingMaskIntoConstraints = true
        setsLabel.frame = CGRect(x: 30,
                                 y: editingLabel.frame.maxY + 10,
                                 width: alertView.frame.width - 60,
                                 height: 20)
        alertView.addSubview(setsLabel)
        
        setsTextField.frame = CGRect(x: 20,
                                    y: setsLabel.frame.maxY,
                                    width: alertView.frame.width - 40,
                                    height: 30)
        setsTextField.backgroundColor = .specialBrown
        setsTextField.borderStyle = .none
        setsTextField.layer.cornerRadius = 10
        setsTextField.textColor = .specialGray
        setsTextField.font = .robotoBold20()
        setsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: setsTextField.frame.height))
        setsTextField.leftViewMode = .always
        setsTextField.returnKeyType = .done
        setsTextField.keyboardType = .numberPad
        alertView.addSubview(setsTextField)
        
        let repsOrTimerLabel = UILabel(text: "\(repsOrTimer)")
        repsOrTimerLabel.translatesAutoresizingMaskIntoConstraints = true
        repsOrTimerLabel.frame = CGRect(x: 30,
                                 y: setsTextField.frame.maxY + 10,
                                 width: alertView.frame.width - 60,
                                 height: 20)
        alertView.addSubview(repsOrTimerLabel)
        
        repsTextField.frame = CGRect(x: 20,
                                     y: repsOrTimerLabel.frame.maxY,
                                     width: alertView.frame.width - 40,
                                     height: 30)
        repsTextField.backgroundColor = .specialBrown
        repsTextField.borderStyle = .none
        repsTextField.layer.cornerRadius = 10
        repsTextField.textColor = .specialGray
        repsTextField.font = .robotoBold20()
        repsTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: repsTextField.frame.height))
        repsTextField.leftViewMode = .always
        repsTextField.returnKeyType = .done
        repsTextField.keyboardType = .numberPad
        alertView.addSubview(repsTextField)
        
        let okButton = UIButton(frame: CGRect(x: 50,
                                              y: repsTextField.frame.maxY + 14,
                                              width: alertView.frame.width - 100,
                                              height: 35))
        okButton.backgroundColor = .specialGreen
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.titleLabel?.font = .robotoMedium18()
        okButton.layer.cornerRadius = 10
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        buttonAction = completion
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.8
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.alertView.center = parentView.center
                }
            }
        }
    }
    
    @objc private func dismissAlert() {
        guard let setsNumber = setsTextField.text else {return}
        guard let repsNumber = repsTextField.text else {return}

        buttonAction? (setsNumber, repsNumber)
        
        guard let targetView = mainView else {return}
        
        UIView.animate(withDuration: 0.3) {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.height, width: targetView.frame.width - 80, height: 430)
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.alpha = 0
                } completion: { done in
                    self.alertView.removeFromSuperview()
                    self.backgroundView.removeFromSuperview()
                    self.scrollView.removeFromSuperview()
                    self.removeForKeyboardNotification()
                }
            }
        }
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func kbWillShow() {
        scrollView.contentOffset = CGPoint(x: 0, y: 100)
    }
    
    @objc private func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
