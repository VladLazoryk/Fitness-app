import UIKit

protocol SelectCollectionViewItemProtocol: AnyObject {
    func selectItem(date: Date)
}

class CalendarView: UIView {
   
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colletionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colletionView.backgroundColor = .none
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        return colletionView
    }()
    
    private let idCalendarCell = "idCalendarCell"
    
    weak var cellCollectionViewDelegate: SelectCollectionViewItemProtocol?
  
//MARK: - override init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegates()
        
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: idCalendarCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - setupViews
    
    private func setupViews() {
        backgroundColor = .specialGreen
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)
    }
//MARK: - setDelegates

    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDataSource

extension CalendarView: UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCalendarCell, for: indexPath) as!
            CalendarCollectionViewCell
        let dateTimeZone = Date().localDate()
        let weekArray = dateTimeZone.getWeekArray()
        cell.cellConfigure(numberOfDay: weekArray[1][indexPath.item], dayOfWeek: weekArray[0][indexPath.item])
        
        if indexPath.item == 6 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension CalendarView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dateTimeZone = Date().localDate()

        switch indexPath.item {
        case 0:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 6))
        case 1:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 5))
        case 2:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 4))
        case 3:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 3))
        case 4:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 2))
        case 5:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 1))
        default:
            cellCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 0))
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 34, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
}

//MARK: - SetConstraint

extension CalendarView {
    
    private func setConstraints() {
       
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 105),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
    
