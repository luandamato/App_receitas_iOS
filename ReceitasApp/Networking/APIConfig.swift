//
//  ApiConfig.swift
//  Recipes
//
//  Created by Luan Damato on 28/10/25.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://hluguqkgmobliiswdocz.supabase.co/"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhsdWd1cWtnbW9ibGlpc3dkb2N6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1Njg5ODAsImV4cCI6MjA3NjE0NDk4MH0.54zmToEHBr3u3RFTDJNHFwFSClPi9elIvWoBXemVnDk"
}

enum APIEndpoints: String {
    case login = "auth/v1/token?grant_type=password"
}
