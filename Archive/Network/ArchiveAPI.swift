//
//  ArchiveAPI.swift
//  Archive
//
//  Created by hanwe on 2021/11/22.
//

import Moya

enum ArchiveAPI {
    case uploadImage(_ image: UIImage)
    case registArchive(_ info: RecordData)
    case registEmail(_ param: RequestEmailParam)
    case loginEmail(_ param: LoginEmailParam)
    case loginWithKakao(kakaoAccessToken: String)
    case isDuplicatedEmail(_ eMail: String)
    case deleteArchive(archiveId: String)
    case getArchives
    case getDetailArchive(archiveId: String)
    case getCurrentUserInfo
    case withdrawal
    case getKakaoUserInfo(kakaoAccessToken: String)

}

extension ArchiveAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .uploadImage:
            return URL(string: CommonDefine.apiServer)!
        case .registArchive:
            return URL(string: CommonDefine.apiServer)!
        case .registEmail:
            return URL(string: CommonDefine.apiServer)!
        case .loginEmail:
            return URL(string: CommonDefine.apiServer)!
        case .loginWithKakao:
            return URL(string: CommonDefine.apiServer)!
        case .isDuplicatedEmail:
            return URL(string: CommonDefine.apiServer)!
        case .deleteArchive:
            return URL(string: CommonDefine.apiServer)!
        case .getArchives:
            return URL(string: CommonDefine.apiServer)!
        case .getDetailArchive:
            return URL(string: CommonDefine.apiServer)!
        case .getCurrentUserInfo:
            return URL(string: CommonDefine.apiServer)!
        case .withdrawal:
            return URL(string: CommonDefine.apiServer)!
        case .getKakaoUserInfo:
            return URL(string: CommonDefine.kakaoAPIServer)!
        }
    }
    
    var path: String {
        switch self {
        case .uploadImage:
            return "/api/v1/archive/image/upload"
        case .registArchive:
            return "/api/v1/archive"
        case .registEmail:
            return "/api/v1/auth/register"
        case .loginEmail:
            return "/api/v1/auth/login"
        case .loginWithKakao:
            return "/api/v1/auth/social?provider=kakao"
        case .isDuplicatedEmail(let eMail):
            return "/api/v1/auth/email/" + eMail
        case .deleteArchive(let archiveId):
            return "/api/v1/archive/" + archiveId
        case .getArchives:
            return "/api/v1/archive"
        case .getDetailArchive(let archiveId):
            return "/api/v1/archive/" + archiveId
        case .getCurrentUserInfo:
            return "/api/v1/auth/info"
        case .withdrawal:
            return "/api/v1/auth/unregister"
        case .getKakaoUserInfo:
            return "/v2/user/me"
        }
    }
    
    var method: Method {
        switch self {
        case .uploadImage:
            return .post
        case .registArchive:
            return .post
        case .registEmail:
            return .post
        case .loginEmail:
            return .post
        case .loginWithKakao:
            return .post
        case .isDuplicatedEmail:
            return .get
        case .deleteArchive:
            return .delete
        case .getArchives:
            return .get
        case .getDetailArchive:
            return .get
        case .getCurrentUserInfo:
            return .get
        case .withdrawal:
            return .delete
        case .getKakaoUserInfo:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .uploadImage:
            return Data()
        case .registArchive:
            return Data()
        case .registEmail:
            return Data()
        case .loginEmail:
            return Data()
        case .loginWithKakao:
            return Data()
        case .isDuplicatedEmail:
            return Data()
        case .deleteArchive:
            return Data()
        case .getArchives:
            return Data()
        case .getDetailArchive:
            return Data()
        case .getCurrentUserInfo:
            return Data()
        case .withdrawal:
            return Data()
        case .getKakaoUserInfo:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .uploadImage(let image):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            let data: MultipartFormData = MultipartFormData(provider: .data(image.pngData()!), name: "image", fileName: "\(dateFormatter.string(from: Date())).jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([data])
        case .registArchive(let infoData):
            return .requestJSONEncodable(infoData)
        case .registEmail(let param):
            return .requestJSONEncodable(param)
        case .loginEmail(let param):
            return .requestJSONEncodable(param)
        case .loginWithKakao(let kakaoAccessToken):
            return .requestParameters(parameters: ["providerAccessToken": kakaoAccessToken], encoding: JSONEncoding.default)
        case .isDuplicatedEmail:
            return .requestPlain
        case .deleteArchive:
            return .requestPlain
        case .getArchives:
            return .requestPlain
        case .getDetailArchive:
            return .requestPlain
        case .getCurrentUserInfo:
            return .requestPlain
        case .withdrawal:
            return .requestPlain
        case .getKakaoUserInfo:
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        switch self {
        case .isDuplicatedEmail:
            return nil
        case .loginEmail:
            return nil
        case .loginWithKakao:
            return nil
        case .registArchive:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .registEmail:
            return nil
        case .uploadImage:
            return nil
        case .deleteArchive:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .getArchives:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .getDetailArchive:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .getCurrentUserInfo:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .withdrawal:
            return ["Authorization": UserDefaultManager.shared.getInfo(.loginToken)]
        case .getKakaoUserInfo(let kakaoAccessToken):
            return ["Authorization": "Bearer \(kakaoAccessToken)"]
        }
    }
    
}


