import UIKit
import RealmSwift

struct ResultWorkout {
    let name: String
    let result: Int
    let imageData: Data?
}

class ProfileViewController: UIViewController {
  
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.text = "PROFILE"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userPhotoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.7607843137, blue: 0.7607843137, alpha: 1)
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 5
        imageView.image = UIImage(named: "addPhoto")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    private let userPhotoView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "User Name"
        label.textColor = .white
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userHeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height: _"
        label.textColor = .specialGray
        label.font = .robotoBold16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight: _"
        label.textColor = .specialGray
        label.font = .robotoBold16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editingButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .specialGreen
        button.setTitle("Editing ", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(named: "profileEditing"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(editingButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.text = "TARGET: 20 workouts"
        label.textColor = .specialGray
        label.font = .robotoBold16()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutsNowLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workoutsTargetLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .specialGray
        label.font = .robotoMedium24()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let targetView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .specialBrown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var labelsStackView = UIStackView()
    
    private let idProfileCollectionViewCell = "idProfileCollectionViewCell"
    
    private let localRealm = try!Realm()
    private var workoutArray: Results<WorkoutModel>!
    private var userArray: Results<UserModel>!
    
    private var resultWorkout = [ResultWorkout]()
    
    
//MARK: - viewWillAppear

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUserParameters()
    }
    
//MARK: - viewDidLayoutSubviews

    override func viewDidLayoutSubviews() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height / 2
    }
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = localRealm.objects(UserModel.self)
        
        setupView()
        setConstraint()
        setDelegate()
        getWorkoutResults()
        setupUserParameters()
    }
    
// MARK: - setupView

    private func setupView() {
        view.backgroundColor = .specialBackground

        view.addSubview(profileLabel)
        view.addSubview(userPhotoView)
        view.addSubview(userPhotoImageView)
        view.addSubview(userNameLabel)
        labelsStackView = UIStackView(arrangeSubviews: [userHeightLabel,userWeightLabel],
                                      axis: .horizontal,
                                      spacing: 10)
        view.addSubview(labelsStackView)
        view.addSubview(editingButton)
        view.addSubview(collectionView)
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: idProfileCollectionViewCell)
        view.addSubview(targetLabel)
        view.addSubview(workoutsNowLabel)
        view.addSubview(workoutsTargetLabel)
        view.addSubview(targetView)
        
    }
// MARK: - setDelegate

    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc private func editingButtonTap() {
        let settingViewController = SettingViewController()
        settingViewController.modalPresentationStyle = .fullScreen
        present(settingViewController, animated: true)
    }
    
    private func setupUserParameters() {
        if userArray.count != 0 {
            userNameLabel.text = userArray[0].userFirstName + userArray[0].userSecondName
            userHeightLabel.text = "Height: \(userArray[0].userHeight)"
            userWeightLabel.text = "Weight: \(userArray[0].userWeight)"
            targetLabel.text = "TARGET: \(userArray[0].userTarget) workouts"
            workoutsTargetLabel.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage else {return}
            guard let image = UIImage(data: data) else {return}
            userPhotoImageView.image = image
        }
    }
    
    private func getWorkoutsName() -> [String] {

        var nameArray = [String]()
        workoutArray = localRealm.objects(WorkoutModel.self)
        
        for workoutModel in workoutArray {
            if !nameArray.contains(workoutModel.workoutName) {
                nameArray.append(workoutModel.workoutName)
            }
        }
        return nameArray
    }
    
    private func getWorkoutResults() {
        let nameArray = getWorkoutsName()
        
        for name in nameArray {
            let predicateName = NSPredicate(format: "workoutName = '\(name)'")
            workoutArray = localRealm.objects(WorkoutModel.self).filter(predicateName).sorted(byKeyPath: "workoutName")
            var result = 0
            var image: Data?
            
            workoutArray.forEach { model in
                result += model.workoutReps
                image = model.workoutImage
            }
            let resultModel = ResultWorkout(name: name, result: result, imageData: image)
            resultWorkout.append(resultModel)
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultWorkout.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idProfileCollectionViewCell, for: indexPath) as!
            ProfileCollectionViewCell
        let model = resultWorkout[indexPath.row]
        cell.cellConfigure(model: model)
        cell.backgroundColor = (indexPath.row % 4 == 0 || indexPath.row % 4 == 3 ? .specialGreen : .specialDarkYellow)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 2.07,
               height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
}

// MARK: - setCostraint
    
    extension ProfileViewController {
        
        private func setConstraint() {
            NSLayoutConstraint.activate([
                profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            NSLayoutConstraint.activate([
                userPhotoImageView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 15),
                userPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                userPhotoImageView.widthAnchor.constraint(equalToConstant: 100),
                userPhotoImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
            
            NSLayoutConstraint.activate([
                userPhotoView.topAnchor.constraint(equalTo: userPhotoImageView.topAnchor, constant: 50),
                userPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                userPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                userPhotoView.heightAnchor.constraint(equalToConstant: 110)
            ])
            
            NSLayoutConstraint.activate([
                userNameLabel.topAnchor.constraint(equalTo: userPhotoImageView.bottomAnchor, constant: 10),
                userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            NSLayoutConstraint.activate([
                labelsStackView.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 7),
                labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
            
            NSLayoutConstraint.activate([
                editingButton.topAnchor.constraint(equalTo: userPhotoView.bottomAnchor, constant: 7),
                editingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 30),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                collectionView.heightAnchor.constraint(equalToConstant: 250)
            ])
            
            NSLayoutConstraint.activate([
                targetLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30),
                targetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
            
            NSLayoutConstraint.activate([
                workoutsNowLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 15),
                workoutsNowLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
            ])
            
            NSLayoutConstraint.activate([
                workoutsTargetLabel.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 15),
                workoutsTargetLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
            ])
            
            NSLayoutConstraint.activate([
                targetView.topAnchor.constraint(equalTo: workoutsNowLabel.bottomAnchor, constant: 1),
                targetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                targetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                targetView.heightAnchor.constraint(equalToConstant: 25)
            ])
        }
    }
