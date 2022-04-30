import UIKit
import RealmSwift

class MainViewController: UIViewController {

    
    private let userPhotoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "User Name"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
//        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addWorkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialYellow
        button.layer.cornerRadius = 10
        button.setTitle("Add workout", for: .normal)
        button.titleLabel?.font = .robotoMedium12()
        button.tintColor = .specialDarkGreen
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 15, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 50, left: -40, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(addWorkoutButtonTapped), for: .touchUpInside)
        button.addShadowOnView()
        button.setImage(UIImage(named: "addWorkout"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let workoutTodayLabel: UILabel = {
       let label = UILabel()
        label.text = "Workout today"
        label.textColor = .specialLightBrown
        label.font = .robotoMedium14()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delaysContentTouches = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    private let noTrainingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noTraining")
        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let calendarView = CalendarView()
    private let weatherView = WeatherView()
    
    private let idWorkoutTableViewCell = "idWorkoutTableViewCell"
    
    private let localRealm = try!Realm()
    private var workoutArray: Results<WorkoutModel>! = nil
    private var userArray: Results<UserModel>!

    
    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.width / 2
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        getWeather()
        setupUserParameters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showOnboarding()
    }
    
//MARK: - VIEW DIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        setupView()
        setConstraints()
        setDelegate()
        getWorkouts(date: Date().localDate())
        setupUserParameters()
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: idWorkoutTableViewCell)
        
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        calendarView.cellCollectionViewDelegate = self
    }

//MARK: -  SETUP VIEW
    private func setupView() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(calendarView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        view.addSubview(addWorkoutButton)
        view.addSubview(weatherView)
        view.addSubview(workoutTodayLabel)
        view.addSubview(tableView)
        view.addSubview(noTrainingImageView)
    }
    
    @objc private func addWorkoutButtonTapped() {
       let newWorkoutViewController = NewWorkoutViewController()
        newWorkoutViewController.modalPresentationStyle = .fullScreen
        present(newWorkoutViewController, animated: true)
    }
    
    private func setupUserParameters() {
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + userArray[0].userSecondName
        
            guard let data = userArray[0].userImage else { return }
            guard let image = UIImage(data: data) else { return }
            userPhotoImageView.image = image
        }
    }
    
    
    private func getWorkouts(date: Date) {
               
        let dateTimeZone = date
        let weekday = dateTimeZone.getWeekDayNumber()
        let dateStart = dateTimeZone.startEndDate().0
        let dateEnd = dateTimeZone.startEndDate().1
        
        let predicateRepeat = NSPredicate(format: "workoutNumberOfDay = \(weekday) AND workoutRepeat = true")
        let predicateUnrepeat = NSPredicate(format: "workoutRepeat = False AND workoutDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicateRepeat, predicateUnrepeat])
        
        workoutArray = localRealm.objects(WorkoutModel.self).filter(compound).sorted(byKeyPath: "workoutName")
        
        checkWorkoutsToday()
        tableView.reloadData()
    }
    
    private func checkWorkoutsToday() {
       
        if workoutArray.count == 0 {
            tableView.isHidden = true
            noTrainingImageView.isHidden = false
        }else{
            tableView.isHidden = false
            noTrainingImageView.isHidden = true
            tableView.reloadData()
        }
    }
    
    private func showOnboarding() {
        let userDefaults = UserDefaults.standard
        let onBoardingWasViewed = userDefaults.bool(forKey: "OnBoardingWasViewed")
        if onBoardingWasViewed == false {
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: false)
        }
    }
    
    private func getWeather() {
        NetworkDataFetch.shared.fetchWeather { [weak self] model, error in
            guard let self = self else {return}
            if error == nil {
                guard let model = model else {return}
                self.weatherView.weatherTitle.text = "\(model.currently.iconLocal) \(model.currently.temperatureCelsius)°C"
                self.weatherView.weatherContent.text = model.currently.description
                
                guard let imageIcon = model.currently.icon else {return}
                self.weatherView.weatherImage.image = UIImage(named: imageIcon)
            } else {
                self.alertOk(title: "Error", message: "No weather data")
            }
        }
    }
    
}

//MARK: - StartWorkoutProtocol

extension MainViewController: StartWorkoutProtocol {
    
    func startButtonTapped(model: WorkoutModel) {
        
        if model.workoutTimer == 0 {
            let startWorkoutViewController = RepsWorkoutViewController()
            startWorkoutViewController.modalPresentationStyle = .fullScreen
            startWorkoutViewController.workoutModel = model
            present(startWorkoutViewController, animated: true)
        } else {
            let startWorkoutTimerViewController = TimerWorkoutViewController()
            startWorkoutTimerViewController.modalPresentationStyle = .fullScreen
            startWorkoutTimerViewController.workoutModel = model
            present(startWorkoutTimerViewController, animated: true)
        }
       
    }
}

//MARK: - SelectCollectionViewItemProtocol

extension MainViewController: SelectCollectionViewItemProtocol {
    
    func selectItem(date: Date) {
        getWorkouts(date: date)
    }
    
    
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workoutArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idWorkoutTableViewCell, for: indexPath) as! WorkoutTableViewCell
        let model = workoutArray[indexPath.row]
        cell.cellConfigure(model: model)
        cell.cellStartWorkoutDelegate = self
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "") { _, _, _ in
            let deleteModel = self.workoutArray[indexPath.row]
            RealmManager.shared.deleteWorkoutModel(model: deleteModel)
            tableView.reloadData()
        }
        
        action.backgroundColor = .specialBackground
//        action.image = UIImage(named: "Delete")
        action.image = UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: - CONSRAINTS
extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            userPhotoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            userPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
            userPhotoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userPhotoImageView.trailingAnchor, constant: 5),
            userNameLabel.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            addWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addWorkoutButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            addWorkoutButton.widthAnchor.constraint(equalToConstant: 80),
            addWorkoutButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: addWorkoutButton.trailingAnchor, constant: 10),
            weatherView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 5),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            weatherView.widthAnchor.constraint(equalToConstant: 265),
            weatherView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            workoutTodayLabel.topAnchor.constraint(equalTo: addWorkoutButton.bottomAnchor, constant: 10),
            workoutTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            noTrainingImageView.topAnchor.constraint(equalTo: workoutTodayLabel.bottomAnchor, constant: 10),
            noTrainingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            noTrainingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            noTrainingImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        ])
        
    }
    
}
