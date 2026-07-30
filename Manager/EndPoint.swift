//
//  EndPoint.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 29.07.26.
//

import Foundation

protocol EndPoint {
    var path: String { get }
    var method : HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var requestBody: RequestBody? { get }
    var requiresAuth: Bool { get }
}

extension EndPoint {
    var requiresAuth: Bool { false }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum RequestBody {
    case rawdata(Data)
    case encodable(Encodable)
    case dictionary([String: Encodable])
}

struct ErrorModel : Decodable  ,Error {
   private(set) var statuscode: Int?
    let statusmessage: String?
    let success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case statuscode = "status_code"
        case statusmessage = "status_message"
        case success = "success"
        
    }
    mutating func setStatusCode(statusCode: Int) {
        if self.statuscode == nil {
            self.statuscode = statusCode
        }
    }
    var localizedDescription: String {
        if let statusmessage = statusmessage {
            return statusmessage
        }else if let statuscode = statuscode {
           return  "Error with status code : \(statuscode)"
            
        }
        return " Unknown Error"
        
    }
}


struct ApiErrorEnvelope: Decodable, Error {
    struct ErrorDetail: Decodable {
        let field: String
        let issue: String
    }
    struct ErrorBody: Decodable {
        let code: String
        let message: String
        let details: [ErrorDetail]?
        let requestId: String?
    }
    let error: ErrorBody

    var code: String { error.code }
}
