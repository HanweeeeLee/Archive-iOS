//
//  CommunityReactor.swift
//  Archive
//
//  Created by hanwe on 2022/05/14.
//

import RxSwift
import RxRelay
import RxFlow
import ReactorKit

class CommunityReactor: Reactor, Stepper, MainTabStepperProtocol {
    
    // MARK: private property
    
    private let usecase: CommunityUsecase
    private var publicArchiveSortBy: PublicArchiveSortBy = .createdAt
    
    // MARK: internal property
    
    let steps = PublishRelay<Step>()
    let initialState = State()
    var err: PublishSubject<ArchiveError> = .init()
    
    // MARK: lifeCycle
    
    init(repository: CommunityRepository) {
        self.usecase = CommunityUsecase(repository: repository)
    }
    
    enum Action {
        case endFlow
        case getPublicArchives(sortBy: PublicArchiveSortBy, emotion: Emotion?)
        case like(archiveId: Int, index: Int)
        case unlike(archiveId: Int, index: Int)
    }
    
    enum Mutation {
        case empty
        case setIsLoading(Bool)
        case setIsShimmerLoading(Bool)
        case setArchives([PublicArchive])
    }
    
    struct State {
        var isLoading: Bool = false
        var isShimmerLoading: Bool = false
        var archives: [PublicArchive] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .endFlow:
            self.steps.accept(ArchiveStep.communityIsComplete)
            return .empty()
        case .getPublicArchives(sortBy: let sortBy, emotion: let emotion):
            return Observable.concat([
                Observable.just(Mutation.setIsShimmerLoading(true)),
                getPublicArchives(sortBy: sortBy, emotion: emotion)
                    .map { [weak self] result in
                        switch result {
                        case .success(let archiveInfo):
                            self?.usecase.setLastInfo(lastSeenArchiveDateMilli: archiveInfo.last?.dateMilli ?? 0,
                                                      lastSeenArchiveId: archiveInfo.last?.archiveId ?? 0)
                            return .setArchives(archiveInfo)
                        case .failure(let err):
                            self?.err.onNext(err)
                            return .empty
                        }
                    },
                Observable.just(Mutation.setIsShimmerLoading(false))
            ])
        case .like(archiveId: let archiveId, let index): // 인덱스 지울지도..
            print("좋아요!")
            return .empty()
        case .unlike(archiveId: let archiveId, let index):
            print("좋아요취소!")
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .empty:
            break
        case .setIsLoading(let isLoading):
            newState.isLoading = isLoading
        case .setIsShimmerLoading(let isLoading):
            newState.isShimmerLoading = isLoading
        case .setArchives(let archives):
            newState.archives = archives
        }
        return newState
    }
    
    // MARK: private function
    
    private func getPublicArchives(sortBy: PublicArchiveSortBy, emotion: Emotion?) -> Observable<Result<[PublicArchive], ArchiveError>> {
        return self.usecase.getPublicArchives(sortBy: sortBy, emotion: emotion)
    }
    
    // MARK: internal function
    
    func runReturnEndFlow() {
        self.action.onNext(.endFlow)
    }
    
}
