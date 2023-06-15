//
//  ProfileViewModel.swift
//  FakeNFT
//

import Foundation

enum ProfileOption: Int {
    case myNFT, favoritesNFT, website
}

enum ProfileReceivingError: Error {
    case userNotAuthorized
}

final class ProfileViewModel {

    var nftsViewModel: NFTsViewModelProtocol?
    private let profileStore: ProfileStoreProtocol
    private let userIDStorage: UserIDStorageProtocol

    @Observable
    private(set) var name: String = ""
    @Observable
    private(set) var avatarURL: URL?
    @Observable
    private(set) var description: String = ""
    @Observable
    private(set) var website: String = ""
    @Observable
    private(set) var nfts: [Int] = []
    @Observable
    private(set) var likes: [Int] = []
    @Observable
    private var isProfileUpdatingNow: Bool = false
    @Observable
    private var profileReceivingError: String = ""

    private var profileOption: ProfileOption?

    private var avatarURLString: String {
        avatarURL?.absoluteString ?? ""
    }

    private lazy var viewModelCallback: (Result<ProfileModel, Error>) -> Void = { [weak self] result in
        self?.isProfileUpdatingNow = false
        switch result {
        case .success(let profile): self?.setProfileViewModel(from: profile)
        case .failure(let error): self?.handle(error)
        }
    }

    init(profileStore: ProfileStoreProtocol = ProfileStore(),
         userIDStorage: UserIDStorageProtocol = UserIDStorage()) {
        self.profileStore = profileStore
        self.userIDStorage = userIDStorage
    }

    private func setProfileViewModel(from profileModel: ProfileModel) {
        guard profileModel.id == userIDStorage.userID else {
            handle(ProfileReceivingError.userNotAuthorized)
            return
        }
        name = profileModel.name
        avatarURL = URL(string: profileModel.avatar)
        description = profileModel.description
        website = profileModel.website
        nfts = profileModel.nfts
        likes = profileModel.likes
        guard let nftsViewModel = nftsViewModel, let profileOption = profileOption else { return }
        nftsViewModel.nftsUpdated(newNFTs: profileOption == .myNFT ? nfts : likes)
    }

    private func handle(_ error: Error) {
        resetProfileViewModel()
        profileReceivingError = String(format: NSLocalizedString("profileReceivingError", comment: "Message when receiving error while profile data downloading"), error as CVarArg)
    }

    private func resetProfileViewModel() {
        name = ""
        description = ""
        website = ""
        avatarURL = nil
        nfts = []
        likes = []
    }
}

// MARK: - ProfileViewModelProtocol

extension ProfileViewModel: ProfileViewModelProtocol {

    var nameObservable: Observable<String> { $name }
    var avatarURLObservable: Observable<URL?> { $avatarURL }
    var descriptionObservable: Observable<String> { $description }
    var websiteObservable: Observable<String> { $website }
    var nftsObservable: Observable<[Int]> { $nfts }
    var likesObservable: Observable<[Int]> { $likes }
    var isProfileUpdatingNowObservable: Observable<Bool> { $isProfileUpdatingNow }
    var profileReceivingErrorObservable: Observable<String> { $profileReceivingError }

    func needUpdate() {
        isProfileUpdatingNow = true
        profileStore.fetchProfile(callback: viewModelCallback)
    }

    func didChangeProfile(name: String?,
                          description: String?,
                          website: String?,
                          avatar: String?,
                          likes: [Int]?,
                          viewCallback: @escaping () -> Void) {
        isProfileUpdatingNow = true
        let profileModel = ProfileModel(name: name ?? self.name,
                                        avatar: avatar ?? self.avatarURLString,
                                        description: description ?? self.description,
                                        website: website ?? self.website,
                                        nfts: self.nfts,
                                        likes: likes ?? self.likes,
                                        id: userIDStorage.userID)
        profileStore.updateProfile(profileModel, viewModelCallback, viewCallback)
    }

    func labelTextFor(_ profileOption: ProfileOption) -> String {
        switch profileOption {
        case .myNFT:
            let localizedFormatString = NSLocalizedString("myNFTsWithCount", comment: "")
            return String(format: localizedFormatString, nfts.count)
        case .favoritesNFT:
            let localizedFormatString = NSLocalizedString("favoritesNFTsWithCount", comment: "")
            return String(format: localizedFormatString, likes.count)
        case .website:
            return NSLocalizedString("aboutDeveloper", comment: "Label text for the third table row")
        }
    }

    func didSelect(_ profileOption: ProfileOption) -> ViewModelProtocol {
        self.profileOption = profileOption
        switch profileOption {
        case .myNFT:
            let viewModel = NFTsViewModel(for: nfts, profileViewModel: self)
            nftsViewModel = viewModel
            return viewModel
        case .favoritesNFT:
            let viewModel = NFTsViewModel(for: likes, profileViewModel: self)
            nftsViewModel = viewModel
            return viewModel
        case .website:
            return WebsiteViewModel(websiteURLString: website)
        }
    }
}
