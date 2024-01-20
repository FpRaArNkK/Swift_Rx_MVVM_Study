//
//  Network.swift
//  MVVM_Rx
//
//  Created by 박민서 on 2023/09/17.
//

import Foundation
import RxSwift
import RxAlamofire

class Network<T:Decodable> {
    
    private let endpoint: String
    private let queue: ConcurrentDispatchQueueScheduler
    
    init(_ endpoint: String) {
        self.endpoint = endpoint
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func getItemList(path: String) -> Observable<T> {
        let fullPath = "\(endpoint)\(path)?api_key=\(API_Key)&language=ko"
        return RxAlamofire.data(.get, fullPath) // RxAlamo 응답 값을 Observable<T>로 리턴
            .observe(on: queue) // 해당 queue에 현재 요청 등록해서 observe하기
            .debug() // req, res 과정이 터미널에 표시됨
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data) // 응답 값 T로 디코딩
            }
    }
}
