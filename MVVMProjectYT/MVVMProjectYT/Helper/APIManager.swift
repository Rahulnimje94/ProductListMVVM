//
//  APIManager.swift
//  MVVMProjectYT
//
//  Created by Rahul Nimje on 04/02/23.
//

import UIKit

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

typealias handler = (Result<[Product], DataError>) -> Void

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    func fetchProducts(completion: @escaping handler) {
        guard let url = URL(string: Constatnt.API.productAPI) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // JSONDecoder() is converting data into model
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
                
            } catch {
                completion(.failure(.network(error)))
            }
        }.resume()
    }
    
}
