//
//  NFTStoreProtocol.swift
//  FakeNFT
//

import Foundation

protocol NFTStoreProtocol {
    func getNFTs(using nftIDs: [Int], completion: @escaping (([Result<NFTModel, Error>]) -> Void))
}
