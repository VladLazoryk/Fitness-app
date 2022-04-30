import UIKit

protocol NextSetTimerProtocoll: AnyObject {
    func nextSetTapped()
    func editingTapped()
}

class WorkoutParametersTimerView: UIView {
    
    let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Squats"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setsLabel: UILabel = {
        let label = UILabel()
         label.text = "Sets"
         label.textColor = .specialGray
         label.font = .robotoMedium18()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    let numberOfSetsLabel: UILabel = {
        let label = UILabel()
         label.text = "1/4"
         label.textColor = .specialGray
         label.font = .robotoMedium24()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let setsLineView: UIView = {
        let view = UIView()
         view.backgroundColor = .specialLine
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
         label.text = "Timer of set"
         label.textColor = .specialGray
         label.font = .robotoMedium18()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    let numberOfTimerLabel: UILabel = {
        let label = UILabel()
         label.text = "1 min 30 sec"
         label.textColor = .specialGray
         label.font = .robotoMedium24()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let repsLineView: UIView = {
        let view = UIView()
         view.backgroundColor = .specialLine
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "editingButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Editing", for: .normal)
        button.tintColor = .specialLightBrown
        button.titleLabel?.font = .robotoMedium16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let nextSetsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("NEXT SET", for: .normal)
        button.tintColor = .specialGray
        button.titleLabel?.font = .robotoBold16()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextSetsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var setsStackView = UIStackView()
    var timerStackView = UIStackView()
    
    weak var cellNextSetTimerDelegate: NextSetTimerProtocoll?

//MARK: - override init
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupView()
            setConstraints()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: -  setupView
    private func setupView() {
        
        backgroundColor = .specialBrown
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(workoutNameLabel)
        
        setsStackView = UIStackView(arrangeSubviews: [setsLabel, numberOfSetsLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        setsStackView.distribution = .equalSpacing
        addSubview(setsStackView)
        addSubview(setsLineView)
 
        timerStackView = UIStackView(arrangeSubviews: [timerLabel, numberOfTimerLabel],
                                    axis: .horizontal,
                                    spacing: 10)
        timerStackView.distribution = .equalSpacing
        addSubview(timerStackView)
        addSubview(repsLineView)
        addSubview(editingButton)
        addSubview(nextSetsButton)
    }
    
    @objc private func editingButtonTapped() {
        cellNextSetTimerDelegate?.editingTapped()
    }
    
    @objc private func nextSetsButtonTapped() {
        cellNextSetTimerDelegate?.nextSetTapped()
    }
    
//MARK: - setConstraints
        private func setConstraints() {
            
            NSLayoutConstraint.activate([
                workoutNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                workoutNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                workoutNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            ])
            
            NSLayoutConstraint.activate([
                setsStackView.topAnchor.constraint(equalTo: workoutNameLabel.bottomAnchor, constant: 10),
                setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                setsStackView.heightAnchor.constraint(equalToConstant: 25)
            ])
            
            NSLayoutConstraint.activate([
                setsLineView.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 2),
                setsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                setsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                setsLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
            
            NSLayoutConstraint.activate([
                timerStackView.topAnchor.constraint(equalTo: setsLineView.bottomAnchor, constant: 20),
                timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                timerStackView.heightAnchor.constraint(equalToConstant: 25)
            ])
            
            NSLayoutConstraint.activate([
                repsLineView.topAnchor.constraint(equalTo: timerStackView.bottomAnchor, constant: 2),
                repsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                repsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                repsLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
            
            NSLayoutConstraint.activate([
                editingButton.topAnchor.constraint(equalTo: repsLineView.bottomAnchor, constant: 10),
                editingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                editingButton.heightAnchor.constraint(equalToConstant: 20),
                editingButton.widthAnchor.constraint(equalToConstant: 80)
            ])
            
            NSLayoutConstraint.activate([
                nextSetsButton.topAnchor.constraint(equalTo: editingButton.bottomAnchor, constant: 10),
                nextSetsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                nextSetsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                nextSetsButton.heightAnchor.constraint(equalToConstant: 45)
            ])
            
        }
}
