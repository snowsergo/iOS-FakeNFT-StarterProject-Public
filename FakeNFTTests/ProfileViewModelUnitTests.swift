//
//  ProfileUnitTests.swift
//  FakeNFTTests
//

import Foundation

import XCTest
@testable import FakeNFT

final class MockProfileStore: ProfileStoreProtocol {

    let fakeProfile = ProfileModel(name: "Joaquin Phoenix",
                                   avatar: "https://wallpapers-fenix.eu/miniatura/160908/074553914.jpg",
                                   description: "Observable",
                                   website: "https://swiftblog.org",
                                   nfts: [68, 69, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81],
                                   likes: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                                   id: "1")

    func fetchProfile(completion: @escaping ((Result<FakeNFT.ProfileModel, Error>) -> Void)) {
        completion(.success(fakeProfile))
    }

    func updateProfile(_ profileModel: FakeNFT.ProfileModel, _ viewModelCompletion: @escaping (Result<FakeNFT.ProfileModel, Error>) -> Void, _ childViewModelCompletion: @escaping (() -> Void), _ viewCompletion: @escaping (() -> Void)) {   }
}

final class ProfileViewModelUnitTests: XCTestCase {

    func testSetupViewModel() {
        // Given
        let mockProfileStore = MockProfileStore()
        let profileViewModel = ProfileViewModel(profileStore: mockProfileStore, userIDStorage: UserIDStorage())

        // When
        profileViewModel.needUpdate()

        // Then
        XCTAssertEqual(mockProfileStore.fakeProfile.name, profileViewModel.name)
        XCTAssertEqual(mockProfileStore.fakeProfile.avatar, profileViewModel.mainAvatarURL?.description)
        XCTAssertEqual(mockProfileStore.fakeProfile.description, profileViewModel.description)
        XCTAssertEqual(mockProfileStore.fakeProfile.website, profileViewModel.website)
        XCTAssertEqual(mockProfileStore.fakeProfile.nfts, profileViewModel.nfts)
        XCTAssertEqual(mockProfileStore.fakeProfile.likes, profileViewModel.likes)
    }
}
