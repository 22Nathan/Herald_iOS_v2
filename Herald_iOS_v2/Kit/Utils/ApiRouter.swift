//
//  ApiRouter.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 23/10/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import Moya
import Realm
import RealmSwift

struct ApiHelper {
    
    static let auth_url = "auth"
    static let api_root = "api/"
    
    static let appid = "9f9ce5c3605178daadc2d85ce9f8e064"
    
    static func api(_ subPath: String) -> String {
        return ApiHelper.api_root + subPath
    }
    
    // 更改url为HTTPS请求
    static func changeHTTPtoHTTPS(url: String) -> String {
        print(url)
        var index = url.index(url.startIndex, offsetBy: 5)
        if url[index] != "s" {
            var newURL = url
            index = newURL.index(url.startIndex, offsetBy: 4)
            newURL.insert("s", at: index)
            return newURL
        }
        return url
    }
}

enum UserAPI {
    case Login(userID: String, password: String)  // 登录API
    case Info()                                   // 检查uuid并获取用户详细信息API
}

enum SubscribeAPI {
    case ActivityDefault()                        // 默认获取第1页的活动API
    case Activity(pageNumber: String)             // 获取下一页的活动API
    case CarouselFigure()                         // 获取轮播图API
}

enum QueryAPI {
    case CardRecord(date: String)                 // 查询一卡通
    case PE()                                     // 查询跑操与体侧
    case GPA()                                    // 查询成绩API
    case SRTP()                                   // 查询SRTP
    case Lecture()                                // 查询人文讲座
    case Notice()                                 // 查询通知
    case Term()                                   // 查询学期
    case Curriculum(term: String)                             // 查询课程表
}

// MARK: - UserAPI
extension UserAPI: TargetType {
    
    var baseURL: URL { return URL(string: "https://myseu.cn/ws3/")! }
    
    var path: String{
        switch self {
        case .Login(_,_):
            return ApiHelper.auth_url
        case .Info():
            return ApiHelper.api("user")
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .Login:
            return .post
        case .Info:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .Login, .Info:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .Login(let userID, _):
            return "{\"UserID\": \(userID)}".utf8Encoded
        case .Info():
            return "info".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .Login(let userID, let password):
            return .requestParameters(parameters: ["cardnum": userID, "password": password, "platform": "ios"], encoding: JSONEncoding.default)
        case .Info():
            return Task.requestPlain
        }
    }
    var headers: [String: String]? {
        switch self {
        case .Login(_,_):
            return ["Content-type": "application/json"]
        case .Info():
            return ["token": HeraldUserDefault.uuid!]
        }
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}

// MARK: - SubscribeAPI
extension SubscribeAPI: TargetType{
    
    var baseURL: URL {
        switch self {
        case .Activity(_), .ActivityDefault():
            return URL(string: "https://www.heraldstudio.com/")!
        case .CarouselFigure():
            return URL(string: "https://app.heraldstudio.com/")!
        }
    }
    
    var path: String{
        switch self {
        case .ActivityDefault():
            return "herald/" + ApiHelper.api("v1/huodong/get")
        case .Activity(_):
            return "herald/" + ApiHelper.api("v1/huodong/get")
        case .CarouselFigure():
            return "checkversion"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .ActivityDefault(), .Activity(_):
            return .get
        case .CarouselFigure():
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .ActivityDefault(), .Activity(_), .CarouselFigure():
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .ActivityDefault(), .Activity(_), .CarouselFigure():
            return "Activity".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .ActivityDefault():
            return .requestPlain
        case .Activity(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        case .CarouselFigure():
            let realm = try! Realm()
            let shchoolNum = realm.objects(User.self).filter("uuid == '\(HeraldUserDefault.uuid!)'").first?.shchoolNum
            return .requestParameters(parameters: ["uuid": HeraldUserDefault.uuid!,
                                                   "schoolnum": shchoolNum!,
                                                   "versiontype": "iOS"], encoding: JSONEncoding.default)
        }
    }
    var headers: [String: String]? {
        switch self {
        case .ActivityDefault(), .Activity(_):
            return ["Content-type": "application/x-www-form-urlencoded"]
        case .CarouselFigure():
            return ["Content-type": "application/json"]
        }
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}

// MARK: - QueryAPI
extension QueryAPI: TargetType{
    var baseURL: URL {
        switch self {
        case .PE(), .Lecture(), .SRTP(), .GPA(), .Notice(), .CardRecord(_), .Term(), .Curriculum(_):
            return URL(string: "https://myseu.cn/ws3/")!
        }
    }
    
    var path: String {
        switch self {
        case .GPA():
            return ApiHelper.api("gpa")
        case .SRTP():
            return ApiHelper.api("srtp")
        case .Lecture():
            return ApiHelper.api("lecture")
        case .Notice():
            return ApiHelper.api("notice")
        case .CardRecord(_):
            return ApiHelper.api("card")
        case .PE():
            return ApiHelper.api("pe")
        case .Term():
            return ApiHelper.api("term")
        case .Curriculum(_):
            return ApiHelper.api("curriculum")
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Lecture(), .GPA(), .SRTP(), .Notice() ,.CardRecord(_), .PE(), .Term(), .Curriculum(_):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .PE(), .Lecture(), .GPA(), .SRTP(), .Notice(), .CardRecord(_), .Term() ,.Curriculum(_):
            return "Query".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .GPA(),.Lecture(), .SRTP(), .Notice(), .PE(), .Term():
            return .requestPlain
        case .CardRecord(let date):
            return .requestParameters(parameters: ["date" : date], encoding: URLEncoding.queryString)
        case .Curriculum(let term):
            return .requestParameters(parameters: ["term" : term], encoding: URLEncoding.queryString)
        }
    }
    

    var headers: [String: String]? {
        switch self {
        case .SRTP(), .Lecture(), .GPA(), .Notice(), .CardRecord(_), .PE(), .Term(), .Curriculum(_):
            return ["Content-type": "application/json","token": HeraldUserDefault.uuid!]
        }
    }
}
