//
//  NFTStore.swift
//  FakeNFT
//

import Foundation

final class NFTStore {

    var networkClient: NetworkClient?
    private var networkTasks: [NetworkTask?] = []

    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }

    private func cancelExistingNetworkTasks() {
        guard !networkTasks.isEmpty else { return }
        networkTasks.forEach { $0?.cancel() }
    }
}

// MARK: - NFTStoreProtocol

extension NFTStore: NFTStoreProtocol {
    func getNFTs(using nftIDs: [Int], callback: @escaping (Result<Nft, Error>) -> Void) {
        cancelExistingNetworkTasks()
        nftIDs.forEach { nftID in
//            let nftPathComponentString = String(format: Constants.nftPathComponentString, nftID)
//            let nftRequest = NFTRequest(endpoint: URL(string: Constants.endpointURLString + nftPathComponentString))
            let nftRequest = NftRequest(id: nftID)
            let networkTask = networkClient?.send(request: nftRequest, type: Nft.self) { result in
                DispatchQueue.main.async { callback(result) }
            }
            networkTasks.append(networkTask)
        }
    }
}
