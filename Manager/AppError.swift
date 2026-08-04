//
//  AppError.swift
//  SilentMoon
//
//  Created by Kerimov Qehreman on 05.08.26.
//



import Foundation

enum AppError: Error {
    case invalidURL
    case noInternetConnection
    case timeout
    case noData

    case badRequest              // 400
    case unauthorized            // 401
    case forbidden               // 403
    case notFound                // 404
    case serverError(statusCode: Int)  // 500...599

    case decodingFailed

    
    case backend(ApiErrorEnvelope)

    case unknown(Error)
}

extension AppError: LocalizedError {
   
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Daxili xəta baş verdi. Zəhmət olmasa yenidən cəhd edin."
        case .noInternetConnection:
            return "İnternet bağlantınız yoxdur. Zəhmət olmasa bağlantını yoxlayıb yenidən cəhd edin."
        case .timeout:
            return "Sorğu vaxtı bitdi. Zəhmət olmasa yenidən cəhd edin."
        case .noData:
            return "Serverdən cavab alına bilmədi."
        case .badRequest:
            return "Göndərilən məlumatda problem var."
        case .unauthorized:
            return "Sessiyanızın vaxtı bitib. Zəhmət olmasa yenidən daxil olun."
        case .forbidden:
            return "Bu əməliyyat üçün icazəniz yoxdur."
        case .notFound:
            return "Axtardığınız məlumat tapılmadı."
        case .serverError:
            return "Serverdə problem yarandı. Bir az sonra yenidən cəhd edin."
        case .decodingFailed:
            return "Məlumat oxuna bilmədi. Zəhmət olmasa tətbiqi yeniləyin."
        case .backend(let envelope):
            
            return envelope.error.message
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    /// Backend-in öz xəta kodu (məsələn "EMAIL_NOT_VERIFIED"). ViewModel-lər
    /// Backend xətası deyilsə, nil qaytarır.
    var backendCode: String? {
        if case .backend(let envelope) = self {
            return envelope.code
        }
        return nil
    }
}

extension AppError {
    /// URLSession-dan gələn xam (data, response, error) üçlüyünü AppError-a çevirir.
    /// Bütün status-kod → xəta uyğunlaşdırması BURDA cəmlənib — NetworkManager
    /// yalnız bu funksiyanı çağırır, özü heç bir status kodu bilmir.
    static func map(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        errorDecoder: (Data) -> Error?
    ) -> AppError? {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .unknown(urlError)
            }
        }
        if let error {
            return .unknown(error)
        }

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {

            
            if let data, let backendError = errorDecoder(data) as? ApiErrorEnvelope {
                return .backend(backendError)
            }

            switch httpResponse.statusCode {
            case 400: return .badRequest
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 500...599: return .serverError(statusCode: httpResponse.statusCode)
            default: return .unknown(
                NSError(domain: "AppError", code: httpResponse.statusCode)
            )
            }
        }

        if data == nil {
            return .noData
        }

        return nil
    }
}
