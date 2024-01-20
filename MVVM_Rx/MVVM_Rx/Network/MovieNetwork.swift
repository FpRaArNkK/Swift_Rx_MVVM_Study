//
//  MovieNetwork.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/17.
//

import Foundation
import RxSwift

final class MovieNetwork {
    private let network: Network<MovieListModel>
    
    init(network: Network<MovieListModel>) {
        self.network = network
    }
    
    func getNowPlayingList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/now_playing")
    }
    
    func getPopularList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/popular")
    }
    
    func getUpComingList() -> Observable<MovieListModel> {
        return network.getItemList(path: "/movie/upcoming")
    }
}
