//
//  ViewController.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/17.
//

import UIKit
import SnapKit
import RxSwift

// 레이아웃을 기준으로 Section Case를 정의 -> CollectionView의 UI 분리 기준 
enum Section: Hashable {
    case double // 하나의 행 두개의 셀 // TV에 들어가는 섹션
    case banner // Movie의 상단 섹션
    case horizontal(String) // Movie의 중간 섹션 // String은 헤더 용
    case vertical(String) // Moview의 마지막 섹션
}

// 셀을 기준으로 Item case를 정의해주면 됩니다. -> 각각의 case들이 각각의 셀에 들어감
enum Item: Hashable {
    case normal(Content) // TV와 Movie 두개의 타입을 같이 써야하는 셀임.. //해당 케이스의 경우 하나의 타입으로 처리하는 경우가 많다.
    case bigImage(Movie)
    case list(Movie)
}

class ViewController: UIViewController {
    
    // UI
    let buttonView = ButtonView()
    lazy var collectionView : UICollectionView = {  // 클래스내 변수 선언에서 self 참조 시엔 lazy가 필요합니다.
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.register(NormalCollectionViewCell.self, forCellWithReuseIdentifier: NormalCollectionViewCell.id)
        collectionView.register(BigImageCollectionViewCell.self, forCellWithReuseIdentifier: BigImageCollectionViewCell.id)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.id)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.id) // 헤더뷰와 같은 UICollectionReusableView의 경우, forSupplementaryViewOfKind에서 해당 종류를 명시해야함
        return collectionView
    }()
    private var dataSource: UICollectionViewDiffableDataSource<Section,Item>?
    
    // viewModel
    let viewModel = ViewModel()
    
    //Subject는 이벤트 emit과 observable형도 가능
    let tvTrigger = PublishSubject<Void>()
    let movieTrigger = PublishSubject<Void>()
    
    // DisposeBag -> Subscribe, Bind 해제
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
        setDataSource()
        bindViewModel()
        bindView()
        tvTrigger.onNext(Void()) //tvTrigger에 event emit
    }
    
    private func setUI() {

        [
            buttonView,
            collectionView
        ].forEach { self.view.addSubview($0)}
        
//        collectionView.backgroundColor = .blue
//        buttonView.backgroundColor = .gray
        
        buttonView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(buttonView.snp.bottom)
        }
        
        
    }
    
    private func bindViewModel() {
        
        let input = ViewModel.Input(tvTrigger: tvTrigger.asObservable(), movieTrigger: movieTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.tvList.bind { [weak self] tvList in // subscribe가 맞지 않나? -> dataSource.apply(snapshot이 UI업데이트임)
            print(tvList)
            
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            let items = tvList.map { tv in
                return Item.normal(Content(tv: tv))
            }
            let section = Section.double
            snapshot.appendSections([section])
            snapshot.appendItems(items, toSection: section)
            self?.dataSource?.apply(snapshot)
            
        }.disposed(by: disposeBag) // will be disposed when ViewController is freed from memory
        
        output.movieResult.bind { [weak self] movieResult in
            print(movieResult)
            
            var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
            
            let bigImageList = movieResult.nowPlaying.results.map { Item.bigImage($0)}
            let bannerSection = Section.banner
            snapshot.appendSections([bannerSection])
            snapshot.appendItems(bigImageList, toSection: bannerSection)
            
            let normalList = movieResult.popular.results.map { Item.normal(Content(movie: $0)) }
            let horizontalSection = Section.horizontal("Popular Movies")
            snapshot.appendSections([horizontalSection])
            snapshot.appendItems(normalList, toSection: horizontalSection)
            
            let itemList = movieResult.upcoming.results.map { return Item.list($0) }
            let verticalSection = Section.vertical("Upcoming Movies")
            snapshot.appendSections([verticalSection])
            snapshot.appendItems(itemList, toSection: verticalSection)
            
            self?.dataSource?.apply(snapshot)
            
        }.disposed(by: disposeBag)
        
    }
    
    /*
     1. tvButton tap 했을 때 tvTrigger에서 이벤트 발생(emit)
     2. viewModel의 tvTrigger에서 bind된 코드 - print() 실행
     */
    private func bindView() {
        // bind는 @escaping 클로저이기 때문에 [weak self]를 넣어준다. -> 순환 참조 방지
        buttonView.tvButton.rx.tap.bind { [weak self] in
            self?.tvTrigger.onNext(Void())
        }.disposed(by: disposeBag)
        
        buttonView.movieButton.rx.tap.bind { [weak self] in
            self?.movieTrigger.onNext(Void())
        }.disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 14 // Section 간 margin
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIndex) // 해당 section을 리턴 받을 수 있음
            switch section {
            case .banner:
                return self?.createBannerSection()
            case .horizontal:
                return self?.createHorizontalSection()
            case .vertical:
                return self?.createVerticalSection()
            default:
                return self?.createDoubleSection()
            }
        }, configuration: config)
        
    }
    
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 8, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(640))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging // 해당 섹션에서 페이징 구현
        return section
    }
    
    private func createHorizontalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // header 삽입
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createVerticalSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3) // count 명시할 때만 쓰네
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // header 삽입
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .normal(let contentData) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalCollectionViewCell.id, for: indexPath) as? NormalCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(title: contentData.title, review: contentData.vote, desc: contentData.overview, imageURL: contentData.posterURL)
                return cell
            case .bigImage(let movieData) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigImageCollectionViewCell.id, for: indexPath) as? BigImageCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(title: movieData.title, review: movieData.overview, desc: movieData.vote, imageURL: movieData.posterURL)
                return cell
            case .list(let movieData):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.id, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(title: movieData.title, releaseDate: movieData.releaseDate, imageURL: movieData.posterURL)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath) as? HeaderView else { return UICollectionReusableView() }
            //            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            //            (header as? HeaderView)?.configure(title: <#T##String#>) // 이렇게도 타입캐스팅해서 접근 가능함
            let section = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .horizontal(let title) :
                header.configure(title: title)
            case .vertical(let title) :
                header.configure(title: title)
            default :
                print("none")
            }
            
            return header


        }
    }


}

