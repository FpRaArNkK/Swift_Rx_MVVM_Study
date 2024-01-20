//
//  ViewModel.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/17.
//

import Foundation
import RxSwift

class ViewModel {
    let disposeBag = DisposeBag()
    
    private let tvNetwork: TVNetwork
    private let movieNetwork: MovieNetwork
    
    init() {
        let provider = NetworkProvider()
        tvNetwork = provider.makeTVNetwork()
        movieNetwork = provider.makeMovieNetwork()
    }
    
    
    struct Input {
        // Observable 객체에서 받는 데이터값이 있으면 해당<Type> 필요
        let tvTrigger: Observable<Void> // 이벤트 발생했다만 중요해서 타입x -> 타입 필요없으면 Void  // Observable<PublishSubject<Void>>
        let movieTrigger: Observable<Void>
    }
    
    struct Output {
        let tvList: Observable<[TV]>
        let movieResult: Observable<MovieResult>
    }
    
    func transform(input: Input) -> Output {
        
        // trigger -> network -> Observable<T> -> VC전달 -> VC에서 구독
        
//        input.tvTrigger.bind {
//            print("tvTrigger")
//        }.disposed(by: disposeBag)
        
        // tvTrigger -> Observable<Void> -> Observable<[TV]>으로 변경
        // [weak self]를 쓰면 self가 optional, [unowned self]를 쓰면 self가 optional이 아님
        let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<[TV]> in
            return self.tvNetwork.getTopRatedList().map { $0.results } //Observable<TVListModel> -> Observable<[TV]>
        }
        
        
        
//        input.movieTrigger.bind {
//            print("movieTrigger")
//        }.disposed(by: disposeBag)
        
        let movieResult = input.movieTrigger.flatMapLatest { [unowned self] _ -> Observable<MovieResult> in
            
            //combineLatest -> Observable 소스가 여러개일 때, 데이터를 묶어서 하나의 Observable 객체 생성, 리턴
            // 3 개의 결과값이 Observable로 모두 반환되었을 때 실행되어 return 된다.
            return Observable.combineLatest(self.movieNetwork.getUpComingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()) { upcoming, popular, nowPlaying -> MovieResult in
                return MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowPlaying)
            }
            
        }
        
        return Output(tvList: tvList, movieResult: movieResult)
    }
}
