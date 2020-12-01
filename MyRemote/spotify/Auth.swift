//
//  Auth.swift
//  MyRemote
//
//  Created by Alex DeMeo on 10/29/20.
//  Copyright © 2020 Alex DeMeo. All rights reserved.
//

import SwiftUI

let SPOTIFY_URL_AUTH = "https://accounts.spotify.com"
let SPOTIFY_URL_API = "https://api.spotify.com"
let REDIRECT_URI = "remotey://"

struct ApiTokenJsonResponse: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let refreshToken: String
    let scope: String
}

struct AccessTokenJsonResponse: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}

class SpotifyAuth {
    let clientId: String
    let clientSecret: String
    var accessToken: String? = nil
    
    static var instance: SpotifyAuth? = nil
    static var shared: SpotifyAuth {
        if instance == nil {
            instance = SpotifyAuth()
        }
        return instance!
    }
    
    
    init() {
        self.clientId = ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_ID"]!
        self.clientSecret = ProcessInfo.processInfo.environment["SPOTIFY_CLIENT_SECRET"]!
        print("spotify auth init clientId=\(self.clientId), clientSecret=\(self.clientSecret)")
        if AppDelegate.settings.refreshToken != nil {
            self.refreshCredentials()
//            self.authorize()
        } else {
            self.authorize()
        }
    }
    
    func refreshCredentials() {
        let body: [String: String] = [
            "grant_type" : "refresh_token",
            "refresh_token": AppDelegate.settings.refreshToken!,
            "client_id": self.clientId,
            "client_secret": self.clientSecret,
        ]
        let context = self
        AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_AUTH)/api/token", method: "POST", header: nil, body: body) { data, response, error in
            context.onReceiveAcessToken(data: data, response: response, error: error)
        }
    }
    
    func onReceiveAcessToken(data: Data?,  response: HTTPURLResponse?, error: Error?) {
        if let error = error {
            print("Error: onReceiveAPIToken(\(error.localizedDescription))")
        }
        if response != nil {
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let body: AccessTokenJsonResponse = try? decoder.decode(AccessTokenJsonResponse.self, from: data) {
//                    print("set access_token=\(body.accessToken)")
                    self.accessToken = body.accessToken
                } else {
                    let s = String(data: data, encoding: .utf8)
                    print("~~\(s ?? "wtf")")
                }
            }
        }
    }
    
    func authorize() {
        let header = [
            "client_id": self.clientId,
            "response_type": "code",
            "redirect_uri": REDIRECT_URI,
            "scope": "user-modify-playback-state",
            "show_dialog": "false",
        ];
        let url = "\(SPOTIFY_URL_AUTH)/authorize"
        var components = URLComponents()
        components.queryItems = header.map {
            URLQueryItem(name: $0, value: $1)
        }
        let newURL = components.url(relativeTo: URL(string: url))
        guard let urlStr = newURL?.absoluteURL else {
            print("Error: URL nil")
            return
        }
        NSWorkspace.shared.open(urlStr)
    }
    
    func onReceiveAuthorizeResponse(urls: [URL]) {
        print("onReceiveAuthorizeResponse(\(urls))")
        if urls.count != 0 {
            let url = urls[0].absoluteURL
            guard let code = url["code"] else {
                print("Error: onReceiveAuthorizeResponse() no code in response url")
                return
            }
            let body: [String: String] = [
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": REDIRECT_URI,
                "client_id": self.clientId,
                "client_secret": self.clientSecret
            ]
            let context = self
            AppDelegate.instance.netAsync(url: "\(SPOTIFY_URL_AUTH)/api/token", method: "POST", header: nil, body: body, callback: context.onReceiveAPIToken(data:response:error:))
        }
    }
    
    func onReceiveAPIToken(data: Data?,  response: HTTPURLResponse?, error: Error?) {
        if let error = error {
            print("Error: onReceiveAPIToken(\(error.localizedDescription))")
        }
        if let data = data {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let body: ApiTokenJsonResponse = try? decoder.decode(ApiTokenJsonResponse.self, from: data) {
                AppDelegate.settings.refreshToken = body.refreshToken
            } else {
                let s = String(data: data, encoding: .utf8)
                print(s ?? "wtf")
            }
        }
    }
}
