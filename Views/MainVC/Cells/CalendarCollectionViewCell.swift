import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    private let dayOfWeekLabel: UILabel = {
       let label = UILabel()
        label.text = "We"
        label.font = .robotoBold16()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfDayLabel: UILabel = {
       let label = UILabel()
        label.text = "29"
        label.font = .robotoBold20()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                backgroundColor = .specialYellow
                layer.cornerRadius = 10
                dayOfWeekLabel.textColor = .specialBlack
                numberOfDayLabel.textColor = .specialDarkGreen
            }else{
                backgroundColor = .specialGreen
                dayOfWeekLabel.textColor = .white
                numberOfDayLabel.textColor = .white
            }
        }
    }
//MARK: - override init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstrainst()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: -  setupViews

    private func setupViews() {
      
        addSubview(dayOfWeekLabel)
        addSubview(numberOfDayLabel)
    }
    
    func cellConfigure(numberOfDay: String, dayOfWeek: String) {
        numberOfDayLabel.text = numberOfDay
        dayOfWeekLabel.text = dayOfWeek
    }
    
//MARK: - SetConstraints

    private func setConstrainst() {
     
        NSLayoutConstraint.activate([
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayOfWeekLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7)
        ])
        
        NSLayoutConstraint.activate([
            numberOfDayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberOfDayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
    }
    
}
