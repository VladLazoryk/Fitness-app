import UIKit
import RealmSwift

struct DifferenceWorkout {
    let name: String
    let lastReps: Int
    let firstReps: Int
}

class StatisticViewController: UIViewController {
    
    private let statisticWorkoutLabel: UILabel = {
        let label = UILabel()
        label.text = "STATISTIC"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "Month"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .specialGreen
        segmentedControl.selectedSegmentTintColor = .specialDarkYellow
        let font = UIFont(name: "Roboto-Medium", size: 16)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font as Any,
                                                 NSAttributedString.Key.foregroundColor: UIColor.white],
                                                 for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font as Any,
                                                 NSAttributedString.Key.foregroundColor: UIColor.specialGray],
                                                 for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedChenged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let exercisesLabel = UILabel(text: "Exercises")
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .none
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let idStatisticsTableViewCell = "idStatisticsTableViewCell"
    
    let localRealm = try! Realm()
    var workoutArray: Results<WorkoutModel>!
    
    var differenceArray = [DifferenceWorkout]()
    
    let dateToday = Date().localDate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setCostraint()
        setDelegate()
        setStartScreen()
    }
    
// MARK: - setupView
    private func setupView() {
        view.backgroundColor = .specialBackground

        view.addSubview(statisticWorkoutLabel)
        view.addSubview(segmentedControl)
        view.addSubview(exercisesLabel)
        view.addSubview(tableView)
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: idStatisticsTableViewCell)
    }
    
//MARK: - setDelegate
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//MARK: - setStartScreen
    private func setStartScreen() {
        getDifferenceModel(dateStart: dateToday.offsetDays(days: 7))
        tableView.reloadData()
    }
    
//MARK: - segmentedChenged
    @objc private func segmentedChenged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetDays(days: 7)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        }else{
            differenceArray = [DifferenceWorkout]()
            let dateStart = dateToday.offsetMonth(month: 1)
            getDifferenceModel(dateStart: dateStart)
            tableView.reloadData()
        }
    }

    private func getWorkoutName() -> [String] {

        var nameArray = [String]()
        workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getDifferenceModel(dateStart: Date) {

        let dateEnd = Date().localDate()
        let nameArray = getWorkoutName()
        
        for name in nameArray {
            
            let predicateDifference = NSPredicate(format: "workoutName = '\(name)' AND workoutDate BETWEEN %@",[dateStart, dateEnd])
            workoutArray = localRealm.objects(WorkoutModel.self).filter(predicateDifference).sorted(byKeyPath: "workoutDate")

            guard let last = workoutArray.last?.workoutReps,
                  let first = workoutArray.first?.workoutReps else {
                        return
                    }
            let differenceWorkout = DifferenceWorkout(name: name, lastReps: last, firstReps: first)
            differenceArray.append(differenceWorkout)
        }

    }
    
}

//MARK: - UITableViewDataSource

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        differenceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idStatisticsTableViewCell, for: indexPath) as! StatisticsTableViewCell
        let differenceModel = differenceArray[indexPath.row]
        cell.cellConfigure(differenceWorkout: differenceModel)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

// MARK: - setCostraint

extension StatisticViewController {
    private func setCostraint() {
        
        NSLayoutConstraint.activate([
            statisticWorkoutLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            statisticWorkoutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: statisticWorkoutLabel.bottomAnchor, constant: 20),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 340),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])

        
        NSLayoutConstraint.activate([
            exercisesLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            exercisesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: exercisesLabel.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}
