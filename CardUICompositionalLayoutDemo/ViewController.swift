//
//  ViewController.swift
//  CardUICompositionalLayoutDemo
//
//  Created by Justin Honda on 5/25/22.
//

import UIKit

enum Section: String, CaseIterable, Hashable {
    case first = "First Group"
    case second = "Second Group"
}

enum MedicationsSection: CaseIterable, Hashable {
    case yourMedsList
    case shareMedList
    case walmartRx
    case nonWalmartRx
}

class ViewController: UIViewController {
    
    let stateAbbreviations: [String] = ["HI", "WA", "FL", "NCF", "SCF", "TNF", "SDF"]
    
    lazy var collectionView = makeCollectionView()
    lazy var dataSource = makeDiffableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        
        var snapshot = NSDiffableDataSourceSnapshot<MedicationsSection, String>()
        
        snapshot.appendSections(MedicationsSection.allCases)

        snapshot.appendItems(["Your medications list"], toSection: .yourMedsList)
        snapshot.appendItems(["Emilia"], toSection: .shareMedList)
        snapshot.appendItems(["Tylenol", "Advil", "Allegra"], toSection: .walmartRx)
        snapshot.appendItems(["Foo", "Bar"], toSection: .nonWalmartRx)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ViewController {
    
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(StateAbbreviationSectionHeaderView.self,
//                                forSupplementaryViewOfKind: "\(StateAbbreviationSectionHeaderView.self)",
//                                withReuseIdentifier: "\(StateAbbreviationSectionHeaderView.self)")
        collectionView.register(SimpleHeaderView.self,
                                forSupplementaryViewOfKind: "\(SimpleHeaderView.self)",
                                withReuseIdentifier: "\(SimpleHeaderView.self)")
        collectionView.register(SectionBackgroundDecorationView.self, forCellWithReuseIdentifier: "\(SectionBackgroundDecorationView.self)")
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }
    
    func makeCollectionViewLayout_iOS14() -> UICollectionViewCompositionalLayout {
        let listLayoutConfig = UICollectionLayoutListConfiguration.init(appearance: .insetGrouped)
 
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnv in
            let sectionLayout = NSCollectionLayoutSection.list(using: listLayoutConfig,
                                                               layoutEnvironment: layoutEnv)

            let suppSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let suppItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: suppSize, elementKind: "\(StateAbbreviationSectionHeaderView.self)", alignment: .top)
            sectionLayout.boundarySupplementaryItems = [suppItem]

            return sectionLayout
        }

        return layout
    }
    
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return createLayout() as! UICollectionViewCompositionalLayout
//        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
//            let sectionLayoutKind = MedicationsSection.allCases[sectionIndex]
//            switch sectionLayoutKind {
//                case .yourMedsList: return self?.createLayout()// return self?.generateYourMedsListLayout()
//                case .shareMedList: return self?.generateShareMedListLayout()
//                case .walmartRx: return self?.generateWalmartRxLayout()
//                case .nonWalmartRx: return self?.generateNonWalmartRxLayout()
//            }
//        }
//        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                                heightDimension: .fractionalHeight(1))
//
//        let layoutAnchor = NSCollectionLayoutAnchor(edges: .all)
//        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "\(SectionBackgroundDecorationView.self)")
//        let boundaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSize, elementKind: "\(SectionBackgroundDecorationView.self)", containerAnchor: layoutAnchor)
//
//        layout.configuration.boundarySupplementaryItems = [boundaryItem]
//        layout.configuration.contentInsetsReference = .safeArea
//
//        return layout
    }
    
    func generateYourMedsListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let layoutSection = NSCollectionLayoutSection(group: group)
        
        return layoutSection
    }
    
    func generateShareMedListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let layoutSection = NSCollectionLayoutSection(group: group)
        return layoutSection
    }
    
    // Can be refactored with the layout method below
    func generateWalmartRxLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let layoutSection = NSCollectionLayoutSection(group: group)
        return layoutSection
    }
    
    // Can be refactored with the layout method above
    func generateNonWalmartRxLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let layoutSection = NSCollectionLayoutSection(group: group)
        return layoutSection
    }
    
    func createLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])
            group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(0), top: nil, trailing: nil, bottom: nil)

            let background = NSCollectionLayoutDecorationItem.background(elementKind: "\(SectionBackgroundDecorationView.self)")
            background.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let section = NSCollectionLayoutSection(group: group)
            section.decorationItems = [background]
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

            let layout = UICollectionViewCompositionalLayout(section: section)
            layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: "\(SectionBackgroundDecorationView.self)")

            return layout
        }
    
    func makeDiffableDataSource() -> UICollectionViewDiffableDataSource<MedicationsSection, String> {
        let dataSource = UICollectionViewDiffableDataSource<MedicationsSection, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .clear
            let label = UILabel()
            label.backgroundColor = .clear
            label.translatesAutoresizingMaskIntoConstraints = false
            let section = MedicationsSection.allCases[indexPath.section]
            
            switch section {
                case .yourMedsList:
                    label.text = "Your medications list"
                case .shareMedList:
                    label.text = "Emilia"
                case .walmartRx:
                    label.text = "A Walmart RX"
                case .nonWalmartRx:
                    label.text = "A Non-Walmart Rx"
            }
            
            cell.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16)
            ])
            return cell
        }
        
//        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            let headerView = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: "\(StateAbbreviationSectionHeaderView.self)",
//                for: indexPath
//            ) as! StateAbbreviationSectionHeaderView
//
//            headerView.sectionLabel.text = Section.allCases[indexPath.section].rawValue
//
//            return headerView
//        }
        
        return dataSource
    }
    
}

class SimpleHeaderView: UICollectionReusableView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class StateAbbreviationSectionHeaderView: UICollectionReusableView {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sectionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "State Abbreviations"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var shareMedListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let attrString = NSMutableAttributedString(string: "Share med list", attributes: attributes)
        button.setAttributedTitle(attrString, for: .normal)
        button.addTarget(self, action: #selector(printSomething), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        [sectionLabel, UIView(), shareMedListButton].forEach {
            stackView.addArrangedSubview($0)
        }
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func printSomething() {
        print("Hello")
    }
    
}

class SectionBackgroundDecorationView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 4
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
