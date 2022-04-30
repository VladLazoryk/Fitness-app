import UIKit
import RealmSwift

class NewWorkoutViewController: UIViewController {

    private let newWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "NEW WORKOUT"
        label.textColor = .specialBlack
        label.font = .robotoMedium24()
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
    
    private let nameLabel = UILabel(text: "Name")
    
    private let nameTextField: UITextField = {
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
    
    private let dateAndRepeatLabel = UILabel(text: "Date and repeat")
    
    private let repsOrTimerLabel: UILabel = {
       let label = UILabel()
        label.text = "Reps or timer"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .white
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateAndRepeatView = DateAndRepeatView()
    private let repsOrTimerView = RepsOrTimerView()
    
    private let localRealm = try! Realm()
    private var workoutModel = WorkoutModel()
    
    private let testImage = UIImage(named: "imageCellWeight")
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
//MARK: - VIEW DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setConstraints()
        setDelegates()
        addTaps()
        nameTextField.becomeFirstResponder()
    }
    
//MARK: -  SETUP VIEW

    private func setupView() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(newWorkoutLabel)
        view.addSubview(closeButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(dateAndRepeatLabel)
        view.addSubview(dateAndRepeatView)
        view.addSubview(repsOrTimerLabel)
        view.addSubview(repsOrTimerView)
        view.addSubview(saveButton)
    }
    
    private func setDelegates() {
        nameTextField.delegate = self
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        setModel()
        saveModel()
    }
    
    private func addTaps() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setModel() {
        guard let nameWorkout = nameTextField.text else {return}
        workoutModel.workoutName = nameWorkout
        
        workoutModel.workoutDate = dateAndRepeatView.datePicker.date.localDate() 
        workoutModel.workoutNumberOfDay = dateAndRepeatView.datePicker.date.getWeekDayNumber()
        
        workoutModel.workoutRepeat = (dateAndRepeatView.repeatSwitch.isOn)
        
        workoutModel.workoutSets = Int(repsOrTimerView.setsSlider.value)
        workoutModel.workoutReps = Int(repsOrTimerView.repsSlider.value)
        workoutModel.workoutTimer = Int(repsOrTimerView.timerSlider.value)
        
        guard let imageData = testImage?.pngData() else {return}
        workoutModel.workoutImage = imageData
    }
    
    private func saveModel() {
        guard let text = nameTextField.text else {return}
        let count = text.filter{$0.isNumber || $0.isLetter}.count
        
        if count != 0 && workoutModel.workoutSets != 0 && (workoutModel.workoutReps != 0 || workoutModel.workoutTimer != 0) {
            RealmManager.shared.saveWorkoutModel(model: workoutModel)
            createNotification()
            alertOk(title: "Saved", message: nil)
            workoutModel = WorkoutModel()
            refreshWorkoutObjects()
        }else{
            alertOk(title: "Error", message: "Enter all parameters")
        }
    }
    
    private func refreshWorkoutObjects() {
        dateAndRepeatView.datePicker.setDate(Date(), animated: true)
        nameTextField.text = ""
        dateAndRepeatView.repeatSwitch.isOn = true
        repsOrTimerView.numberOfSetsLabel.text = "0"
        repsOrTimerView.setsSlider.value = 0
        repsOrTimerView.numberOfRepsLabel.text = "0"
        repsOrTimerView.repsSlider.value = 0
        repsOrTimerView.numberOfTimerLabel.text = "0"
        repsOrTimerView.timerSlider.value = 0
    }
    
    private func createNotification() {
        let notifications = Notifications()
        let stringDate = workoutModel.workoutDate.ddMyyyyFromeDate()
        notifications.sheduleDateNitification(date: workoutModel.workoutDate, id: "workout" + stringDate)
    }

}

extension NewWorkoutViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
    }
}

//MARK: - CONSRAINTS

extension NewWorkoutViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            newWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            newWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: newWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: newWorkoutLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            dateAndRepeatLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            dateAndRepeatLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            dateAndRepeatLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            dateAndRepeatView.topAnchor.constraint(equalTo: dateAndRepeatLabel.bottomAnchor, constant: 3),
            dateAndRepeatView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateAndRepeatView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateAndRepeatView.heightAnchor.constraint(equalToConstant: 95)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimerLabel.topAnchor.constraint(equalTo: dateAndRepeatView.bottomAnchor, constant: 20),
            repsOrTimerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            repsOrTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            repsOrTimerView.topAnchor.constraint(equalTo: repsOrTimerLabel.bottomAnchor, constant: 3),
            repsOrTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repsOrTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repsOrTimerView.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            
            saveButton.topAnchor.constraint(equalTo: repsOrTimerView.bottomAnchor, constant: 25),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
}
