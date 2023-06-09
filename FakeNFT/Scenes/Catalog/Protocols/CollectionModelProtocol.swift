import Foundation

protocol CollectionModelProtocol {
    var networkClient: NetworkClient { get }
    func getData<T: Decodable>(url: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func toggleNFTItemInCart(id: Int, completion: @escaping (Result<Order, Error>) -> Void)
    func toggleNFTLikeInProfile(id: Int, completion: @escaping (Result<Profile, Error>) -> Void)
}
