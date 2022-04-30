import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    
    
    private let editingProfileLabel: UILabel = {
       let label = UILabel()
        label.text = "EDITING PROFILE"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.image = UIImage(named: "addPhoto")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userPhotoView: UIView =  {
       let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameLabel = UILabel(text: "First name")

    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let secondNameLabel = UILabel(text: "Second name")
    
    private let secondNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let heightLabel = UILabel(text: "Height")
    
    private let heightTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let weightLabel = UILabel(text: "Weight")
    
    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .specialBrown
        textField.borderStyle = .none
        textField.layer.cornerRadius = 10
        textField.textColor = .specialGray
        textField.font = .robotoBold20()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .white
//        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let localRealm = try! Realm()
    private var userArray: Results<UserModel>!
    
    private var userModel = UserModel()
    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height/2
    }
    
    
//MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraint()
        addTaps()
        
        userArray = localRealm.objects(UserModel.self)
        loadUserInfo()
    }
    
//MARK: - setupView

    private func setupView() {
        view.backgroundColor = .specialBackground

        view.addSubview(editingProfileLabel)
        view.addSubview(closeButton)
        view.addSubview(userPhotoView)
        view.addSubview(userPhotoImageView)
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(secondNameLabel)
        view.addSubview(secondNameTextField)
        view.addSubview(heightLabel)
        view.addSubview(heightTextField)
        view.addSubview(weightLabel)
        view.addSubview(weightTextField)
        view.addSubview(saveButton)
        
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        
        setUserModel()
        
        if userArray.count == 0 {
            RealmManager.shared.saveUserModel(model: userModel)
        }else{
            RealmManager.shared.updateUserModel(model: userModel)
        }
        userModel = UserModel()
    }
    
    private func loadUserInfo() {
        if userArray.count != 0 {
            firstNameTextField.text = userArray[0].userFirstName
            secondNameTextField.text = userArray[0].userSecondName
            heightTextField.text = "\(userArray[0].userHeight)"
            weightTextField.text = "\(userArray[0].userWeight)"
            
            guard let data = userArray[0].userImage else {return}
            guard let image = UIImage(data: data) else {return}
            userPhotoImageView.image = image
            userPhotoImageView.contentMode = .scaleAspectFit
        }
    }
    
    private func setUserModel() {
        guard let firstName = firstNameTextField.text,
              let secondName = secondNameTextField.text,
              let height = heightTextField.text,
              let weight = weightTextField.text else {
                  return
              }
        guard let intHeight = Int(height),
              let intWeght = Int(weight) else {
                  return
              }
        
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userHeight = intHeight
        userModel.userWeight = intWeght
        
        if userPhotoImageView.image == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
            guard let imageData = userPhotoImageView.image?.pngData() else {return}
            userModel.userImage = imageData
        }
                
    }
    
    private func addTaps() {
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        userPhotoImageView.isUserInteractionEnabled = true
        userPhotoImageView.addGestureRecognizer(tapImageView)
    }
    
    @objc private func setUserPhoto() {
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else {return}
            self.chooseImagePicker(source: source)
        }
    }
}
//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType){
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        userPhotoImageView.image = image
        userPhotoImageView.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
}

//MARK: - setConstraint

extension SettingViewController{
    
    private func setConstraint(){
        NSLayoutConstraint.activate([
            editingProfileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            editingProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: editingProfileLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: editingProfileLabel.bottomAnchor, constant: 15),
            userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            userPhotoView.topAnchor.constraint(equalTo: userPhotoImageView.topAnchor, constant: 50),
            userPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userPhotoView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            firstNameLabel.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 40),
            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            firstNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 3),
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            secondNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 15),
            secondNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            secondNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            secondNameTextField.topAnchor.constraint(equalTo: secondNameLabel.bottomAnchor, constant: 3),
            secondNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            heightLabel.topAnchor.constraint(equalTo: secondNameTextField.bottomAnchor, constant: 15),
            heightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            heightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            heightTextField.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 3),
            heightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            heightTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 15),
            weightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            weightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            weightTextField.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 3),
            weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weightTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

