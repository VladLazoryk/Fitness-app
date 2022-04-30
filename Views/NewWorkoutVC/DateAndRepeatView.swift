import UIKit

class DateAndRepeatView: UIView {

    private let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "Date"
        label.textColor = .specialBlack
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.tintColor = .specialGreen
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let repeatLabel: UILabel = {
       let label = UILabel()
        label.text = "Repeat every 7 days"
        label.textColor = .specialBlack
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let repeatSwitch: UISwitch = {
        let repeatSwitch = UISwitch()
        repeatSwitch.isOn = true
        repeatSwitch.onTintColor = .specialGreen
        repeatSwitch.translatesAutoresizingMaskIntoConstraints = false
        return repeatSwitch
    }()
    
    var dateStackView = UIStackView()
    var repeatStackView = UIStackView()
    
    
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
        layer.cornerRadius = 10
        backgroundColor = .specialBrown
        translatesAutoresizingMaskIntoConstraints = false
        
        dateStackView = UIStackView(arrangeSubviews: [dateLabel, datePicker],
                                    axis: .horizontal,
                                    spacing: 10)
        addSubview(dateStackView)
        
        repeatStackView = UIStackView(arrangeSubviews: [repeatLabel, repeatSwitch],
                                      axis: .horizontal,
                                      spacing: 10)
        addSubview(repeatStackView)
    }

//MARK: - setConstraints
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            dateStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            repeatStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 10),
            repeatStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            repeatStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
    }
}

