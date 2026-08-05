//
//  NetworkManger.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//


import Foundation

final class NetworkManager {
    private  let session: URLSession
    private let mainPath : String
    private let header : [String:String]
    private let errorDecoder: (Data) -> Error?


    static let silentMoon = NetworkManager(
        session: URLSession.shared,
        mainPath: "https://api.silentmoon.app/api/v1",
        header: [
            "accept": "application/json",
            "content-type": "application/json",
            "Authorization" : ""
        ],
        errorDecoder: { data in
            try? JSONDecoder().decode(ApiErrorEnvelope.self, from: data)
        }
    )

    init(
        session : URLSession ,
        mainPath : String ,
        header: [ String:String],
        errorDecoder: @escaping (Data) -> Error? = { data in
            try? JSONDecoder().decode(ErrorModel.self, from: data)
        }
    ){
        self.session = session
        self.mainPath = mainPath
        self.header = header
        self.errorDecoder = errorDecoder
    }

    func request <T : Decodable>(
        endPoint : EndPoint ,
        completion: @escaping (Result<T,Error>) -> Void){
            let urlRequest = urlRequest(endPoint: endPoint)
            let callback : (Result<T,Error>) -> Void = {result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            switch urlRequest {
            case .success(let urlRequest):
                session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                    guard let self else { return }

                    if let appError = AppError.map(
                        data: data,
                        response: response,
                        error: error,
                        errorDecoder: self.errorDecoder
                    ) {
                        callback(.failure(appError))
                        return
                    }

                    guard let data else {
                        callback(.failure(AppError.noData))
                        return
                    }

                    if let result = try? JSONDecoder().decode(T.self, from: data) {
                        callback(.success(result))
                    } else {
                        callback(.failure(AppError.decodingFailed))
                    }

                }.resume()
            case .failure(let error):
                callback(.failure(error))
            }

        }
    func urlRequest(endPoint : EndPoint ) -> Result<URLRequest, Error>{
        let path = "\(mainPath)\(endPoint.path)"
        guard var url = URL(string: path) else {
            return  .failure(AppError.invalidURL)

        }
        url.append(queryItems: endPoint.queryItems)
        var urlReuqest = URLRequest(url: url)
        header.forEach({
            urlReuqest.setValue($1 , forHTTPHeaderField: $0)
        })
        if endPoint.requiresAuth, let accessToken = TokenStore.shared.accessToken {
            urlReuqest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        urlReuqest.httpMethod = endPoint.method.rawValue
        if let body = endPoint.requestBody {
            switch body {
            case .rawdata(let  data) :
                urlReuqest.httpBody = data
            case .encodable(let encodable) :
                do {
                    urlReuqest.httpBody = try JSONEncoder().encode(encodable)
                } catch {
                    return .failure(error)
                }
            case .dictionary(let dictionary) :
                do {
                    let data = try JSONSerialization.data( withJSONObject: dictionary )
                    urlReuqest.httpBody = data
                } catch {
                    return .failure(error)
                }
            }
        }
        return.success(urlReuqest)
    }

    func loadData(urlString : String , completion : @escaping (Result<Data, Error>)->Void){
        let callback : (Result<Data,Error>) -> Void = {result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        guard let url = URL(string: urlString) else {
            callback(.failure(AppError.invalidURL))
            return
        }
        session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let self else { return }

            if let appError = AppError.map(
                data: data,
                response: response,
                error: error,
                errorDecoder: self.errorDecoder
            ) {
                callback(.failure(appError))
                return
            }

            guard let data = data else {
                callback(.failure(AppError.noData))
                return
            }
            callback(.success(data))

        }).resume()
    }
}
