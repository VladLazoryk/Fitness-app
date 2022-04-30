import Foundation
import UIKit

struct OnboardingStruct{
    let topLabel: String
    let bottomLabel: String
    let image: UIImage
}

class OnboardingViewController: UIViewController {
   
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = .robotoBold20()
        button.tintColor = .specialGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.isEnabled = false
        pageControl.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
  
    private let idOnboardingCell = "idOnboardingCell"
    
    private var onboardingArray = [OnboardingStruct]()
    
    private var collectionItem = 0
    
    
//MARK: - viewDidLoad

    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
        setConstraints()
    }
    
//MARK: - setupViews

    private func setupViews() {
        view.backgroundColor = .specialGreen
        
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        view.addSubview(collectionView)
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: idOnboardingCell)
        
        guard let imageFirst = UIImage(named: "onboardingFirst"),
        let imageSecond = UIImage(named: "onboardingSecond"),
        let imageThird = UIImage(named: "onboardingThird") else {
            return
        }
        
        let firstSreen = OnboardingStruct(topLabel: "Have a good health",
                                          bottomLabel: "Being healthy is all, no health is nothing. So why do not we",
                                          image: imageFirst)
        
        let secondScreen = OnboardingStruct(topLabel: "Be stronger",
                                            bottomLabel: "Take 30 minutes of bodybuilding every day to get physically fit and healthy.",
                                            image: imageSecond)
        
        let thirdScreen = OnboardingStruct(topLabel: "Have nice body",
                                           bottomLabel: "Bad body shape, poor sleep, lack of strength, weight gain, weak bones, easily traumatized body, depressed, stressed, poor metabolism, poor resistance",
                                           image: imageThird)
        
        onboardingArray = [firstSreen, secondScreen, thirdScreen]
    }
    
//MARK: - setDelegates

    private func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
   
    
    @objc private func nextButtonTapped() {
        if collectionItem == 1 {
            nextButton.setTitle("START", for: .normal)
        }
        
        if collectionItem == 2 {
            saveUserDefaults()
        } else {
            collectionItem += 1
            let index: IndexPath = [0 , collectionItem]
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = collectionItem
        }
    }
    
    private func saveUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "OnBoardingWasViewed")
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idOnboardingCell, for: indexPath) as! OnboardingCollectionViewCell
        let model = onboardingArray[indexPath.row]
        cell.cellConfigure(model: model)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectinViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
}

//MARK: - OnboardingViewController

extension OnboardingViewController {
   
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20)
        ])
    }
}
