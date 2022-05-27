//
//  MainViewController.swift
//  CardUICompositionalLayoutDemo
//
//  Created by Justin Honda on 5/26/22.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    lazy var collectionView = makeCollectionView()
    lazy var diffableDataSource = makeDiffableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        var snapshot = NSDiffableDataSourceSnapshot<MedicationsSection, String>()
        
        snapshot.appendSections(MedicationsSection.allCases)
        snapshot.appendItems([""], toSection: .yourMedsList)
        snapshot.appendItems(["Justin"], toSection: .shareMedsList)
        snapshot.appendItems(walmartRxs, toSection: .walmartRxs)
        snapshot.appendItems(nonWalmartRxs, toSection: .nonWalmartRxs)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: - Collection View

extension MainViewController {
    
    enum SupplementaryViewKinds: String {
        case sectionHeader
    }
    
    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(YourMedsCollectionCell.self,
                                forCellWithReuseIdentifier: YourMedsCollectionCell.reuseIdentifier)
        collectionView.register(ShareMedListCollectionCell.self,
                                forCellWithReuseIdentifier: ShareMedListCollectionCell.reuseIdentifier)
        collectionView.register(MedicationCollectionCell.self,
                                forCellWithReuseIdentifier: MedicationCollectionCell.reuseIdentifier)
        
        // header views
        collectionView.register(PrescriptionTypeHeaderView.self,
                                forSupplementaryViewOfKind: SupplementaryViewKinds.sectionHeader.rawValue,
                                withReuseIdentifier: PrescriptionTypeHeaderView.reuseIdentifier)
        return collectionView
    }
    
}

// MARK: - Diffable Data Source

extension MainViewController {
    
    var walmartRxs: [String] { ["Tylenol", "Advil", "Allegra"] }
    var nonWalmartRxs: [String] { ["Tramadol", "Zoloft"] }
    
    func makeDiffableDataSource() -> UICollectionViewDiffableDataSource<MedicationsSection, String> {
        let dataSource = UICollectionViewDiffableDataSource<MedicationsSection, String>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            let section = MedicationsSection.allCases[indexPath.section]
            switch section {
                case .yourMedsList:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourMedsCollectionCell.reuseIdentifier, for: indexPath) as! YourMedsCollectionCell
                    cell.label.text = "Your medications list"
                    return cell
                case .shareMedsList:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareMedListCollectionCell.reuseIdentifier, for: indexPath) as! ShareMedListCollectionCell
                    cell.nameLabel.text = "Justin"
                    return cell
                case .walmartRxs:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicationCollectionCell.reuseIdentifier, for: indexPath) as! MedicationCollectionCell
                    cell.medicationNameLabel.text = self?.walmartRxs[indexPath.row]
                    return cell
                case .nonWalmartRxs:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicationCollectionCell.reuseIdentifier, for: indexPath) as! MedicationCollectionCell
                    cell.medicationNameLabel.text = self?.nonWalmartRxs[indexPath.row]
                    return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, supplementaryKind, indexPath in
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: supplementaryKind, withReuseIdentifier: PrescriptionTypeHeaderView.reuseIdentifier, for: indexPath) as! PrescriptionTypeHeaderView
            
            let section = MedicationsSection.allCases[indexPath.section]
            switch section {
                case .shareMedsList: break
                case .yourMedsList: break
                case .walmartRxs: cell.label.text = "Walmart Prescriptions"
                case .nonWalmartRxs: cell.label.text = "Non-Walmart Prescriptions"
            }
            
            return cell
        }
        
        return dataSource
    }
    
}

// MARK: - Collection View Layout

extension MainViewController {
    
    enum MedicationsSection: Hashable, CaseIterable {
        case yourMedsList
        case shareMedsList
        case walmartRxs
        case nonWalmartRxs
    }
    
    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            let section = MedicationsSection.allCases[sectionIndex]
            switch section {
                case .yourMedsList:  return self?.generateYourMedsListLayout()
                case .shareMedsList: return self?.generateShareMedsListLayout()
                case .walmartRxs:    return self?.generateWalmartRxsLayout()
                case .nonWalmartRxs: return self?.generateWalmartRxsLayout()
            }
        }
        
        return layout
    }
    
    func generateYourMedsListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let layoutSection = NSCollectionLayoutSection(group: group)
        return layoutSection
    }
    
    func generateShareMedsListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let layoutSection = NSCollectionLayoutSection(group: group)
        return layoutSection
    }
    
    func generateWalmartRxsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(20)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SupplementaryViewKinds.sectionHeader.rawValue,
            alignment: .top
        )
        
        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.boundarySupplementaryItems = [headerItem]
        
        return layoutSection
    }
    
}

class YourMedsCollectionCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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

class ShareMedListCollectionCell: UICollectionViewCell {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var shareMedsListButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let attrString = NSMutableAttributedString(string: "Share med list", attributes: attributes)
        button.setAttributedTitle(attrString, for: .normal)
        button.addTarget(self, action: #selector(testPrint), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        [nameLabel, SpacerView(), shareMedsListButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func testPrint() {
        print("Edit")
    }
    
}

class PrescriptionTypeHeaderView: UICollectionReusableView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.layer.opacity = 0.75
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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

class MedicationCollectionCell: UICollectionViewCell {
    
    lazy var medicationNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var medicationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(medicationNameStackView)
        [medicationNameLabel, SpacerView(), arrowImageView].forEach {
            medicationNameStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            medicationNameStackView.topAnchor.constraint(equalTo: topAnchor),
            medicationNameStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            medicationNameStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            medicationNameStackView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
}
