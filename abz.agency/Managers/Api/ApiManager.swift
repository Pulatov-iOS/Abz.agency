//
//  ApiManager.swift
//  abz.agency
//
//  Created by Alexander on 11.06.25.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    private init() {}

    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"

    func fetchUsers(page: Int, count: Int, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        let endpoint = "\(baseURL)/users"
        let parameters: Parameters = [
            "page": page,
            "count": count
        ]

        AF.request(endpoint, parameters: parameters)
            .validate()
            .responseDecodable(of: UsersResponse.self) { response in
                switch response.result {
                case .success(let usersResponse):
                    completion(.success(usersResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
