import UIKit

class RepsWorkoutViewController: UIViewController {
    
    private let startWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "START WORKOUT"
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
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
    }
    
    private let sportmanImageView: UIImageView = {  
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sportsmanImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let detailsLabel = UILabel(text: "Details")
    private var numberOfSet = 1
    
    private let workoutParametersView = WorkoutParametersView()
    
    private let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.layer.cornerRadius = 10
        button.setTitle("FINISH", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .white
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var workoutModel = WorkoutModel()
    
    let customAlert = CustomAlert()
    
//MARK: - VIEW DIDLOAD
        override func viewDidLoad() {
            super.viewDidLoad()

            setupView()
            setConstrainst()
            setWorkoutParameters()
            setDelegates()
            
        }
    
//MARK: -  SETUP VIEW

        private func setupView() {
            view.backgroundColor = .specialBackground
            
            view.addSubview(startWorkoutLabel)
            view.addSubview(closeButton)
            view.addSubview(sportmanImageView)
            view.addSubview(detailsLabel)
            view.addSubview(workoutParametersView)
            view.addSubview(finishButton)
        }
    
    private func setDelegates() {
        workoutParametersView.cellNextSetDelegate = self
    }
    
    @objc private func finishButtonTapped() {
        if numberOfSet == workoutModel.workoutSets {
            dismiss(animated: true)
            RealmManager.shared.updateStatusWorkoutModel(model: workoutModel, bool: true)
        } else {
            alertOkCancel(title: "Warning", message: "You haven't finished your workout") {
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setWorkoutParameters() {
        workoutParametersView.workoutNameLabel.text = workoutModel.workoutName
        workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        workoutParametersView.numberOfRepsLabel.text = "\(workoutModel.workoutReps)"
    }
}

//MARK: - NextSetProtocoll
 
extension RepsWorkoutViewController: NextSetProtocoll {
    
    func editingTapped() {
        customAlert.alertCustom(viewControler: self, repsOrTimer: "Reps") { [self] sets, reps in
            if sets != "" && reps != "" {
            workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(sets)"
            workoutParametersView.numberOfRepsLabel.text = reps
            guard let numberOfSets = Int(sets) else {return}
            guard let numberOfReps = Int(reps) else {return}
            RealmManager.shared.updateSetsRepsWorkoutModel(model: workoutModel, sets: numberOfSets, reps: numberOfReps)
           }
        }
    }
    
    func nextSetTapped() {

        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametersView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        }else{
            alertOk(title: "Finish", message: "You have finished your workout")
        }
    }
}

//MARK: - CONSRAINTS

extension RepsWorkoutViewController {
    
    private func setConstrainst() {
       
        NSLayoutConstraint.activate([
            startWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            startWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: startWorkoutLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            sportmanImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20),
            sportmanImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sportmanImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            sportmanImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: sportmanImageView.bottomAnchor, constant: 25),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            workoutParametersView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            workoutParametersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutParametersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutParametersView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: workoutParametersView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
    
}
