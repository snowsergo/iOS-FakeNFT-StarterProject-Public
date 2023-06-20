import Foundation

protocol CatalogModelProtocol {
    var networkClient: NetworkClient { get }
    func getData<T: Decodable>(url: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}
