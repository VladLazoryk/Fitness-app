import UIKit

class WeatherView: UIView {
    
     let weatherBlock: UIView = {
       let block = UIView()
        block.backgroundColor = .white
        block.layer.cornerRadius = 10
        block.addShadowOnView()
        block.translatesAutoresizingMaskIntoConstraints = false
        return block
    }()
    
     let weatherImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "sunImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
     let weatherTitle: UILabel = {
       let title = UILabel()
        title.text = "Солнечно"
        title.textColor = .specialGray
        title.font = .robotoMedium18()
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
     let weatherContent: UILabel = {
       let title = UILabel()
        title.text = "Хорошая погода, чтобы позаниматься на улице"
        title.textColor = .lightGray
        title.font = .robotoMedium14()
        title.numberOfLines = 2
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
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
        addShadowOnView()
        layer.cornerRadius = 10
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(weatherBlock)
        addSubview(weatherImage)
        addSubview(weatherTitle)
        addSubview(weatherContent)
    }
}

//MARK: - SetConstraints

extension WeatherView {

    private func setConstraints() {

        NSLayoutConstraint.activate([
            weatherImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            weatherImage.widthAnchor.constraint(equalToConstant: 60),
            weatherImage.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            weatherTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherTitle.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: -10),
            weatherTitle.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            weatherContent.topAnchor.constraint(equalTo: weatherTitle.bottomAnchor, constant: 5),
            weatherContent.trailingAnchor.constraint(equalTo: weatherImage.leadingAnchor, constant: 5),
            weatherContent.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherContent.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
