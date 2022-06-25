//
//  CommunityRepository.swift
//  Archive
//
//  Created by hanwe on 2022/06/25.
//

import RxSwift

protocol CommunityRepository {
    func getPublicArchives(sortBy: PublicArchiveSortBy, emotion: Emotion?, lastSeenArchiveDateMilli: Int?, lastSeenArchiveId: Int?) -> Observable<Result<[PublicArchive], ArchiveError>>
}

enum PublicArchiveSortBy: String {
    case createdAt = "CREATED_AT"
    case watchedOn = "WATCHED_ON"
}

struct PublicArchive: CodableWrapper {
    typealias selfType = PublicArchive
    
    let authorId: Int
    let mainImage: String
    let authorProfileImage: String
    let archiveName: String
    let isLiked: Bool
    let archiveId: Int
    let authorNickname: String
    let emotion: Emotion
    let watchedOn: String
    let dateMilli: Int
    let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case authorId
        case mainImage
        case authorProfileImage
        case archiveName = "name"
        case isLiked
        case archiveId
        case authorNickname
        case emotion
        case watchedOn
        case dateMilli
        case likeCount
    }
    
}