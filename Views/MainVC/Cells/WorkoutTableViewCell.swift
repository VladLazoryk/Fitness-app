import UIKit

protocol StartWorkoutProtocol: AnyObject {
    func startButtonTapped(model: WorkoutModel)
}

protocol StartWorkoutTimerProtocol: AnyObject {
    func startButtonTapped(model: WorkoutModel)
}

class WorkoutTableViewCell: UITableViewCell {

    private let backgroundCell: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .specialBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let workoutImageCellWeight: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "imageCellWeight")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let workoutHeaderLabel: UILabel = {
       let label = UILabel()
        label.font = .robotoMedium22()
        label.text = "Pull Ups"
        label.textColor = .specialBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutRepsLabel: UILabel = {
       let label = UILabel()
        label.font = .robotoMedium16()
        label.text = "Reps: 10"
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutSetsLabel: UILabel = {
       let label = UILabel()
        label.font = .robotoMedium16()
        label.text = "Sets: 2"
        label.textColor = .specialGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelsStackView = UIStackView()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
//        button.setTitle("START", for: .normal)
        button.titleLabel?.font = .robotoBold16()
//        button.tintColor = .specialDarkGreen
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var workoutModel = WorkoutModel()
    
    weak var cellStartWorkoutDelegate: StartWorkoutProtocol?
    weak var cellStartWorkoutTimerDelegate: StartWorkoutTimerProtocol?
    
 //MARK: - override init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setCostraint()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - setupViews
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(backgroundCell)
        addSubview(workoutBackgroundView)
        addSubview(workoutImageCellWeight)
        addSubview(workoutHeaderLabel)
        labelsStackView = UIStackView(arrangeSubviews: [workoutRepsLabel, workoutSetsLabel],
                                     axis: .horizontal,
                                     spacing: 10)
        addSubview(labelsStackView)
        contentView.addSubview(startButton)

    }
    
    @objc private func startButtonTapped() {
        cellStartWorkoutDelegate?.startButtonTapped(model: workoutModel)
        cellStartWorkoutTimerDelegate?.startButtonTapped(model: workoutModel)
    }
    
   
    func cellConfigure(model: WorkoutModel) {
        workoutModel = model
        
        workoutHeaderLabel.text = model.workoutName
        
        
        let (min, sec) = {(secs: Int) -> (Int,Int) in
            return (secs / 60, secs % 60)} (model.workoutTimer)
        
        workoutRepsLabel.text = (model.workoutTimer == 0 ? "Reps: \(model.workoutReps)" : "Timer \(min) min \(sec) sec")
        workoutSetsLabel.text = "Sets: \(model.workoutSets)"
        guard let imageData = model.workoutImage else {return}
        guard let image = UIImage(data: imageData) else {return}
        workoutImageCellWeight.image = image
        
        if model.status {
            startButton.setTitle("COMPLETE", for: .normal)
            startButton.tintColor = .white
            startButton.backgroundColor = .specialGreen
            startButton.isEnabled = false
        }else{
            startButton.setTitle("START", for: .normal)
            startButton.tintColor = .specialDarkGreen
            startButton.backgroundColor = .specialYellow
            startButton.isEnabled = true
        }
    }
    
//MARK: - SetConstraints

    private func setCostraint() {
        
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            workoutBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            workoutBackgroundView.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            workoutBackgroundView.bottomAnchor.constraint(equalTo: backgroundCell.bottomAnchor, constant: -10),
            workoutBackgroundView.widthAnchor.constraint(equalToConstant: 75),
            workoutBackgroundView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            workoutImageCellWeight.leadingAnchor.constraint(equalTo: workoutBackgroundView.leadingAnchor, constant: 10),
            workoutImageCellWeight.topAnchor.constraint(equalTo: workoutBackgroundView.topAnchor, constant: 10),
            workoutImageCellWeight.trailingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: -10),
            workoutImageCellWeight.bottomAnchor.constraint(equalTo: workoutBackgroundView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            workoutHeaderLabel.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            workoutHeaderLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 5),
            workoutHeaderLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: workoutHeaderLabel.bottomAnchor, constant: 0),
            labelsStackView.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            labelsStackView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: workoutBackgroundView.trailingAnchor, constant: 10),
            startButton.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 5),
            startButton.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            startButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
