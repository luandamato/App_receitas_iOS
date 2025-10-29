//
//  ApiConfig.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

import Foundation
import Alamofire

enum APIConfig {
    static let baseURL = "https://sippjzdrkwsuhdqquvtx.supabase.co/"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNpcHBqemRya3dzdWhkcXF1dnR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NDIzNTYsImV4cCI6MjA3NzMxODM1Nn0.9mf6_R0WZikk4E_iz4CY3vyLrhgaBvWDtFSKOUMgDoE"
}

enum APIEndpoints {
    case register
    case updateUser
    case uploadPhoto(userId: String)
    case login
    case refreshToken
    case recoverPassword

    /// Caminho completo do endpoint
    var path: String {
        switch self {
        case .register:
            return "auth/v1/signup"
        case .updateUser:
            return "auth/v1/user"
        case .uploadPhoto(let userId):
            let now = Date()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let isoString = formatter.string(from: now)
            return "storage/v1/object/avatars/\(userId)/avatar\(isoString).png"
        case .login:
            return "auth/v1/token?grant_type=password"
        case .refreshToken:
            return "auth/v1/token?grant_type=refresh_token"
        case .recoverPassword:
            return "auth/v1/recover"
        }
    }
}

