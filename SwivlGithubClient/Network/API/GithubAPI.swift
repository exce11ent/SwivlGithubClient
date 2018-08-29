//
//  GithubAPI.swift
//  SwivlGithubClient
//
//  Created by Vitalii Krayovyi on 8/29/18.
//  Copyright © 2018 Vitalii Kraiovyi. All rights reserved.
//

import Moya

#if DEBUG
let webPlugins: [PluginType] = [NetworkLoggerPlugin(verbose: true)]
#else
let webPlugins: [PluginType] = []
#endif

let GithubAPIProvider = MoyaProvider<GithubAPI>(plugins: webPlugins)

enum GithubAPI {
    case users(since: Int)
    case usersSearch(descriptor: SearchDescriptor)
    case followers(userName: String)
}

extension GithubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    var path: String {
        switch self {
        case .users:
            return "users"
        case .followers(let userName):
            return "users/\(userName)/followers"
        case .usersSearch:
            return "search/users"
        }
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .usersSearch(let descriptor):
            return .requestParameters(parameters: descriptor.asParameters(),
                                      encoding: URLEncoding.default)
        case .users(let since):
            return .requestParameters(parameters: ["since" : since],
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return [:]
    }
}
