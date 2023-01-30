//
//  APICaller.swift
//  NASA
//
//  Created by Nuntapat Hirunnattee on 23/1/2566 BE.
//

import Foundation

enum NetworkError: Error{
    case invalidURL
    case invalidData
    case invalidSession
    case invalidDecodeData
    
    var errorDescription: String{
        switch self {
        case .invalidURL:
            return self.localizedDescription
        case .invalidData:
            return self.localizedDescription
        case .invalidSession:
            return self.localizedDescription
        case .invalidDecodeData:
            return self.localizedDescription
        }
    }
    
}

class APICaller{
    
    static let shared = APICaller()
    private init(){ }
    
    func request<T: Codable>(urlString: String, expecting: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.invalidSession))
            } else {
                guard let data = data else {
                    completion(.failure(.invalidData))
                    return }
                do {
                    let result = try JSONDecoder().decode(expecting, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.invalidDecodeData))
                }
            }
        }
        task.resume()
    }
    
    func request<T: Codable>(urlString: String, expecting: [T].Type, completion: @escaping (Result<[T], NetworkError>) -> Void){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.invalidSession))
            } else {
                guard let jsonData = data else {
                    completion(.failure(.invalidData))
                    return }
                do {
                    let result = try JSONDecoder().decode(expecting, from: jsonData)
                    completion(.success(result))
                } catch let error{
                    print("\(error): \(error.localizedDescription)")
                    completion(.failure(.invalidDecodeData))
                }
            }
        }
        task.resume()
    }
}
