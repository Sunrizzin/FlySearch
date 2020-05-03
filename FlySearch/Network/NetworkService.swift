//
//  NetworkService.swift
//  FlySearch
//
//  Created by Aleksey Usanov on 03.05.2020.
//  Copyright © 2020 Aleksey Usanov. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class NetworkService {
    static var instance = NetworkService()
    
    private init() {}
    private let queue = OperationQueue()
    
    func searchFly(searchText: String, completion:@escaping (_ success: Bool, _ message: String, _ directions: [Directions]?, _ origin: Origin?) -> Void) {
        let request =  AF.request("https://map.aviasales.ru/supported_directions.json?origin_iata=\(searchText)&one_way=true&locale=ru")
        let op = GetSearchOperation(request: request)
        op.completionBlock = {
            switch op.data {
            case .failure(let error):
                completion(false, error.localizedDescription, nil, nil)
            case .success(let data):
                if let directions = data.directions {
                    let result = directions.filter( { $0.direct == true })
                    let sorted = result.sorted(by: { $0.country_name!.lowercased() < $1.country_name!.lowercased() })
                    completion(true, "", sorted, data.origin)
                } else {
                    completion(false, "Ничего не удалось найти,\nпожалуйста, попробуйте ввести другой IATA", nil, nil)
                }
            case .none:
                completion(false, "Неизвестная ошибка", nil, nil)
            }
        }
        queue.addOperation(op)
        
    }
    
    
    func getDetails(iata: String, dest: String, completion:@escaping (_ success: Bool, _ message: String, _ direction: DirectionDetail?) -> Void) {
        let request =  AF.request("https://map.aviasales.ru/prices.json?origin_iata=\(iata)&locale=ru")
        let op = GetDetailsOperation(request: request)
        op.completionBlock = {
            switch op.data {
            case .failure(let error):
                completion(false, error.localizedDescription, nil)
            case .success(let data):
                let res = data.filter({ $0.destination == dest }).filter( { $0.actual == true})
                if res.count > 0 {
                    completion(true, "", res[0])
                } else {
                    completion(false, "Нет актуальных перелётов", nil)
                }
            case .none:
                completion(false, "Неизвестная ошибка", nil)
            }
        }
        queue.addOperation(op)
        
    }
    
}

class GetSearchOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Result<AllDirections, AFError>?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
    
    
    override func main() {
        DispatchQueue.global().async {
            self.request.responseObject { (response:AFDataResponse<AllDirections>) in
                self.data = response.result
                self.state = .finished
            }
        }
    }
}

class GetDetailsOperation: AsyncOperation {
    
    private var request: DataRequest
    var data: Result<[DirectionDetail], AFError>?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        DispatchQueue.global().async {
            self.request.responseArray { (response:AFDataResponse<[DirectionDetail]>) in
                self.data = response.result
                self.state = .finished
            }
        }
    }
}

