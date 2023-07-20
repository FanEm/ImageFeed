//
//  Constants.swift
//  ImageFeed
//

import Foundation

let AccessKey = "6LgR6HLvP4QhC-2fETz29HLGpxtdm-uMjDe1yDl7rvs"
let SecretKey = "FNAkBGyIjFSoripPyvY96Md8yW6qx3-sQo56MlXcKMQ"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
let AuthorizeBaseURL: URL = URL(string: "https://unsplash.com/")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authBaseURL: URL

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: URL,
        authBaseURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authBaseURL = authBaseURL
    }

    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AccessKey,
            secretKey: SecretKey,
            redirectURI: RedirectURI,
            accessScope: AccessScope,
            defaultBaseURL: DefaultBaseURL,
            authBaseURL: AuthorizeBaseURL
        )
    }
}
