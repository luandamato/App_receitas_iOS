//
//  APIClient.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

import Foundation
import Alamofire

// MARK: - APIClient
struct AnyCodable: Codable {}

class APIClient {
    static let shared = APIClient()
    
    private var defaultHeaders: HTTPHeaders {
        [
            "apiKey": APIConfig.anonKey,
            "Authorization": "Bearer \(UserSessionManager.shared.getUser()?.accessToken ?? "")"
        ]
    }
    
    // Função genérica para requisições
    func request<T: Codable, U: Decodable>(
            baseURL: String? = nil,
            endPoint: APIEndpoints,
            method: HTTPMethod = .get,
            body: T? = AnyCodable(),
            headers: [String: String]? = nil,
            queryItems: [String: String]? = nil,
            onSuccess: @escaping (U) -> Void,
            onError: @escaping (_ errorMessage: String, _ statusCode: Int?) -> Void)
    {
            
        var urlString = (baseURL ?? APIConfig.baseURL) + endPoint.path
        
        if let queryItems = queryItems, !queryItems.isEmpty {
            let query = queryItems
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            urlString += "?\(query)"
        }
        
        // Monta os headers finais
        var allHeaders = defaultHeaders
        headers?.forEach { key, value in
            allHeaders.add(name: key, value: value)
        }
        allHeaders["Content-Type"] = "application/json"
        
        // Monta o encoding e os parâmetros
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        
        var parameters: Parameters?
        if let body = body {
            do {
                let data = try JSONEncoder().encode(body)
                parameters = try JSONSerialization.jsonObject(with: data) as? Parameters
            } catch {
                onError("Erro ao codificar o body", nil)
                return
            }
        }
        
        print("======================================================")
        print("\(method.rawValue) -> \(urlString)")
        print("------------ HEADERS ------------")
        print(allHeaders)
        print("------------ BODY ------------")
        print(parameters ?? "")
        print("======================================================")
        
        AF.request(
            urlString,
            method: HTTPMethod(rawValue: method.rawValue),
            parameters: parameters,
            encoding: encoding,
            headers: allHeaders
        )
        .validate()
        .responseData { response in
            print(endPoint)
            if let data = response.data {
                self.printJSONResponse(data)
            }
            switch response.result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(U.self, from: data)
                    onSuccess(decoded)
                } catch {
                    onError("Erro ao decodificar resposta", response.response?.statusCode)
                }
            case .failure(let error):
                let statusCode = response.response?.statusCode
                var message = error.localizedDescription

                // Tenta decodificar o corpo do erro para pegar a mensagem da API
                if let data = response.data {
                    if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        message = apiError.msg
                    }
                }

                onError(message, statusCode)
            }
        }
    }
    
    func uploadImage<T: Decodable>(
        baseURL: String? = nil,
        endPoint: APIEndpoints,
        imageData: Data,
        onSuccess: @escaping (T) -> Void,
        onError: @escaping (_ errorMessage: String, _ statusCode: Int?) -> Void
    ) {
        let urlString = (baseURL ?? APIConfig.baseURL) + endPoint.path

        // Cria headers corretamente tipados
        var allHeaders = defaultHeaders
        allHeaders.add(name: "Content-Type", value: "image/png")

        print("======================================================")
        print("POST -> \(urlString)")
        print("------------ HEADERS ------------")
        print(allHeaders)
        print("------------ BODY ------------")
        print("Image data size: \(imageData.count) bytes")
        print("======================================================")

        AF.upload(imageData, to: urlString, method: .post, headers: allHeaders)
            .validate()
            .responseData { (response: AFDataResponse<Data>) in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        onSuccess(decoded)
                    } catch {
                        onError("Erro ao decodificar resposta", response.response?.statusCode)
                    }
                case .failure(let error):
                    let statusCode = response.response?.statusCode
                    var message = error.localizedDescription

                    if let data = response.data,
                       let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        message = apiError.msg
                    }
                    onError(message, statusCode)
                }
            }
    }

    
    private func printJSONResponse(_ data: Data) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print("===== RESPONSE JSON =====")
            print(prettyString)
            print("========================")
        } else if let string = String(data: data, encoding: .utf8) {
            print("===== RESPONSE STRING =====")
            print(string)
            print("==========================")
        } else {
            print("Não foi possível converter a resposta para JSON ou String.")
        }
    }
}
