import UIKit

class RepsOrTimerView: UIView {

     private let setsLabel: UILabel = {
       let label = UILabel()
        label.text = "Sets"
        label.textColor = .specialBlack
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let numberOfSetsLabel: UILabel = {
       let label = UILabel()
        label.text = "0"
        label.textColor = .specialBlack
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let setsSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(setsSliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let repeatOfTimerLabel: UILabel = {
       let label = UILabel()
        label.text = "Choose repeat or timer"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     private let repsLabel: UILabel = {
       let label = UILabel()
        label.text = "Reps"
        label.textColor = .specialBlack
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let numberOfRepsLabel: UILabel = {
       let label = UILabel()
        label.text = "0"
        label.textColor = .specialBlack
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let repsSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 50
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(repsSliderChanged), for: .valueChanged)
        return slider
    }()
    
    private let timerLabel: UILabel = {
       let label = UILabel()
        label.text = "Timer"
        label.textColor = .specialBlack
        label.font = .robotoMedium18()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let numberOfTimerLabel: UILabel = {
       let label = UILabel()
        label.text = "0 min"
        label.textColor = .specialBlack
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let timerSlider: UISlider = {
       let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 600
        slider.maximumTrackTintColor = .specialLightBrown
        slider.minimumTrackTintColor = .specialGreen
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(timerSliderChanged), for: .valueChanged)
        return slider
    }()
    
    var setsStackView = UIStackView()
    var repsStackView = UIStackView()
    var timerStackView = UIStackView()
   
    
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
            
            setsStackView = UIStackView(arrangeSubviews: [setsLabel, numberOfSetsLabel], axis: .horizontal, spacing: 10)
            addSubview(setsStackView)
            addSubview(setsSlider)
            addSubview(repeatOfTimerLabel)
            repsStackView = UIStackView(arrangeSubviews: [repsLabel, numberOfRepsLabel], axis: .horizontal, spacing: 10)
            addSubview(repsStackView)
            addSubview(repsSlider)
            timerStackView = UIStackView(arrangeSubviews: [timerLabel, numberOfTimerLabel], axis: .horizontal, spacing: 10)
            addSubview(timerStackView)
            addSubview(timerSlider)
        }
    
    @objc private func setsSliderChanged() {
        numberOfSetsLabel.text = "\(Int(setsSlider.value))"
    }
    
    @objc private func repsSliderChanged() {
        numberOfRepsLabel.text = "\(Int(repsSlider.value))"
        
        setNegative(label: timerLabel, numberLabel: numberOfTimerLabel, slider: timerSlider)
        setActive(label: repsLabel, numberLabel: numberOfRepsLabel, slider: repsSlider)
    }
    
    @objc private func timerSliderChanged() {
        
        let (min, sec) = {(secs: Int) -> (Int,Int) in
            return (secs / 60, secs % 60)} (Int(timerSlider.value))
        
        numberOfTimerLabel.text = (sec != 0 ? "\(min) min \(sec) sec" : "\(min) min")
//        if sec != 0 {
//            numberOfTimerLabel.text = "\(min) min \(sec) sec"
//        } else {
//            numberOfTimerLabel.text = "\(min) min"
//        }
        setNegative(label: repsLabel, numberLabel: numberOfRepsLabel, slider: repsSlider)
        setActive(label: timerLabel, numberLabel: numberOfTimerLabel, slider: timerSlider)
    }
    
    private func setActive(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 1
        numberLabel.alpha = 1
        slider.alpha = 1
    }
    
    private func setNegative(label: UILabel, numberLabel: UILabel, slider: UISlider) {
        label.alpha = 0.5
        numberLabel.alpha = 0.5
        numberLabel.text = "0"
        slider.alpha = 0.5
        slider.value = 0
    }
    
//MARK: - setConstraints
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            setsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            setsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            setsSlider.topAnchor.constraint(equalTo: setsStackView.bottomAnchor, constant: 10),
            setsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            setsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            repeatOfTimerLabel.topAnchor.constraint(equalTo: setsSlider.bottomAnchor, constant: 15),
            repeatOfTimerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            repsStackView.topAnchor.constraint(equalTo: repeatOfTimerLabel.bottomAnchor, constant: 20),
            repsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            repsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            repsSlider.topAnchor.constraint(equalTo: repsStackView.bottomAnchor, constant: 10),
            repsSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            repsSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            timerStackView.topAnchor.constraint(equalTo: repsSlider.bottomAnchor, constant: 20),
            timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            timerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            timerSlider.topAnchor.constraint(equalTo: timerStackView.bottomAnchor, constant: 10),
            timerSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            timerSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
        
    }
}


//let (min, sec) = { (secs: Int) -> (Int, Int) in
//            return (secs / 60, secs % 60) }(Int(timerSlider.value))
