import UIKit

class TimerWorkoutViewController: UIViewController {
 
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
    
    private let ellipseImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timerLabel: UILabel = {
       let label = UILabel()
        label.text = "1:35"
        label.textColor = .specialGray
        label.font = .robotoBold48()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel = UILabel(text: "Details")
    private var numberOfSet = 0
    
    let workoutParametersTimerView = WorkoutParametersTimerView()
    
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
    
    let shapeLayer = CAShapeLayer()
    
    var timer = Timer()
    var durationTimer = 10
    
    override func viewDidLayoutSubviews() {
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        animationCircular()
    }
    
//MARK: - VIEW DIDLOAD
        
        override func viewDidLoad() {
            super.viewDidLoad()

            setupView()
            setConstrainst()
            setDelegates()
            setWorkoutTimerParameters()
            addTaps()
        }
    
//MARK: -  SETUP VIEW

        private func setupView() {
            view.backgroundColor = .specialBackground
            
            view.addSubview(startWorkoutLabel)
            view.addSubview(closeButton)
            view.addSubview(ellipseImageView)
            view.addSubview(timerLabel)
            view.addSubview(detailsLabel)
            view.addSubview(workoutParametersTimerView)
            view.addSubview(finishButton)
        }
    
    private func setDelegates() {
        workoutParametersTimerView.cellNextSetTimerDelegate = self
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
        timer.invalidate()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
        timer.invalidate()
    }
    
    private func setWorkoutTimerParameters() {
        workoutParametersTimerView.workoutNameLabel.text = workoutModel.workoutName
        workoutParametersTimerView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        
        let (min, sec) = workoutModel.workoutTimer.convertSeconds()
        workoutParametersTimerView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
        
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
        durationTimer = workoutModel.workoutTimer
    }
    
    private func addTaps() {
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(startTimer))
        timerLabel.isUserInteractionEnabled = true
        timerLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc private func startTimer() {
        
        workoutParametersTimerView.editingButton.isEnabled = false
        workoutParametersTimerView.nextSetsButton.isEnabled = false
        
        if numberOfSet == workoutModel.workoutSets {
            alertOk(title: "Finish", message: "You have finished your workout")
        }else{
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerAction),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc private func timerAction() {
        durationTimer -= 1
        
        if durationTimer == 0 {
            timer.invalidate()
            durationTimer = workoutModel.workoutTimer
            
            numberOfSet += 1
            
            workoutParametersTimerView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
            
            workoutParametersTimerView.editingButton.isEnabled = true
            workoutParametersTimerView.nextSetsButton.isEnabled = true
        }
        
        let (min, sec) = durationTimer.convertSeconds()
        timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
    }
}

//MARK: - NextSetTimerProtocoll

extension TimerWorkoutViewController: NextSetTimerProtocoll {
   
    func nextSetTapped() {

        if numberOfSet < workoutModel.workoutSets {
            numberOfSet += 1
            workoutParametersTimerView.numberOfSetsLabel.text = "\(numberOfSet)/\(workoutModel.workoutSets)"
        }else{
            alertOk(title: "Finish", message: "You have finished your workout")
        }
    }
    
    func editingTapped() {
        customAlert.alertCustom(viewControler: self, repsOrTimer: "Timer of set") { [self] sets, timerOfSet in
            if sets != "" && timerOfSet != "" {
            guard let numberOfSets = Int(sets) else {return}
            guard let numberOfTimer = Int(timerOfSet) else {return}
            let (min, sec) = numberOfTimer.convertSeconds()
            workoutParametersTimerView.numberOfSetsLabel.text = "\(numberOfSet)/\(sets)"
            workoutParametersTimerView.numberOfTimerLabel.text = "\(min) min \(sec) sec"
            timerLabel.text = "\(min):\(sec.setZeroForSeconds())"
            durationTimer = numberOfTimer
            RealmManager.shared.updateSetsTimerWorkoutModel(model: workoutModel, sets: numberOfSets, timer: numberOfTimer)
           }
        }
     }
}
//MARK: - ANIMATION

extension TimerWorkoutViewController {
    
    private func animationCircular() {
        
        let center = CGPoint(x: ellipseImageView.frame.width / 2, y: ellipseImageView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 135,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        shapeLayer.strokeColor = UIColor.specialGreen.cgColor
        ellipseImageView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

//MARK: - CONSRAINTS

extension TimerWorkoutViewController {
    
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
            ellipseImageView.topAnchor.constraint(equalTo: startWorkoutLabel.bottomAnchor, constant: 20),
            ellipseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ellipseImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            ellipseImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: ellipseImageView.leadingAnchor, constant: 40),
            timerLabel.trailingAnchor.constraint(equalTo: ellipseImageView.trailingAnchor, constant: -40),
            timerLabel.centerYAnchor.constraint(equalTo: ellipseImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: ellipseImageView.bottomAnchor, constant: 25),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            workoutParametersTimerView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 5),
            workoutParametersTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            workoutParametersTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            workoutParametersTimerView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            finishButton.topAnchor.constraint(equalTo: workoutParametersTimerView.bottomAnchor, constant: 20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            finishButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
    
}
