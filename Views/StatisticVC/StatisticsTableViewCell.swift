import UIKit

class StatisticsTableViewCell: UITableViewCell {
    
    private let backgroundCell: UIView = {
        let view = UIView()
         view.backgroundColor = .clear
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
         label.font = .robotoMedium22()
         label.text = "Biceps"
         label.textColor = .specialBlack
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let beforeLabel = UILabel(text: "Before: 18" )

    private let nowLabel = UILabel(text: "Now: 20")

    private let differenceLabel: UILabel = {
        let label = UILabel()
         label.text = "+"
         label.textColor = .specialGreen
         label.font = .robotoMedium24()
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
    }()
    
    private let statisticsLineView: UIView = {
       let uiView = UIView()
        uiView.backgroundColor = .specialLine
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
   
    var labelsStackView = UIStackView()
    
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
        addSubview(nameLabel)
        addSubview(differenceLabel)
        addSubview(statisticsLineView)
        labelsStackView = UIStackView(arrangeSubviews: [beforeLabel, nowLabel],
                                      axis: .horizontal,
                                      spacing: 10)
        addSubview(labelsStackView)
    }
    
    func cellConfigure(differenceWorkout: DifferenceWorkout) {
        nameLabel.text = differenceWorkout.name
        beforeLabel.text = "Before: \(differenceWorkout.firstReps)"
        nowLabel.text = "Now: \(differenceWorkout.lastReps)"
        
        let difference = differenceWorkout.lastReps - differenceWorkout.firstReps
        differenceLabel.text = "\(difference)"
        
        switch difference {
        case ..<0: differenceLabel.textColor = .specialGreen
        case 1...: differenceLabel.textColor = .specialDarkYellow
                   differenceLabel.text = "+\(difference)"
        default:
            differenceLabel.textColor = .specialGray
        }
    }
    
//MARK: - setCostraint
    private func setCostraint() {
        
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 5),
//            statisticsHeaderLabel.bottomAnchor.constraint(equalTo: backgroundCell.bottomAnchor, constant: -25),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo:backgroundCell.trailingAnchor , constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            labelsStackView.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 15),
            labelsStackView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        NSLayoutConstraint.activate([
            differenceLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            differenceLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            statisticsLineView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 2),
            statisticsLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statisticsLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            statisticsLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}



