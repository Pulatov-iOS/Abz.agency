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
    
    func fetchPositions(completion: @escaping (Result<[Position], Error>) -> Void) {
           let endpoint = "\(baseURL)/positions"
           
           AF.request(endpoint)
               .validate()
               .responseDecodable(of: PositionsResponse.self) { response in
                   switch response.result {
                   case .success(let positionsResponse):
                       if let positions = positionsResponse.positions {
                           completion(.success(positions))
                       } else {
                           completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No positions found."])))
                       }
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }

       func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
           let endpoint = "\(baseURL)/token"
           
           AF.request(endpoint)
               .validate()
               .responseDecodable(of: TokenResponse.self) { response in
                   switch response.result {
                   case .success(let tokenResponse):
                       completion(.success(tokenResponse.token))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }

    func submitUser(name: String, email: String, phone: String, positionId: Int, photo: UIImage, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ErrorCompression"])))
            return
        }

        fetchToken { result in
            switch result {
            case .success(let token):
                let headers: HTTPHeaders = ["Token": token]
                let endpoint = "\(self.baseURL)/users"

                AF.upload(multipartFormData: { formData in
                    formData.append(Data(name.utf8), withName: "name")
                    formData.append(Data(email.utf8), withName: "email")
                    formData.append(Data(phone.utf8), withName: "phone")
                    formData.append(Data(String(positionId).utf8), withName: "position_id")
                    formData.append(imageData, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                }, to: endpoint, headers: headers)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(SignUpResponse.self, from: data)
                            completion(.success(decoded))
                        } catch {
                            completion(.failure(error))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
