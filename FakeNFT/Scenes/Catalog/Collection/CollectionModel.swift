import Foundation

final class CollectionModel: CollectionModelProtocol {
    var networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getData<T: Decodable>(url: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url)
        else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1)))
            return
        }
        let request = AnyRequest(endpoint: url)
        networkClient.send(request: request, type: T.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleNFTItemInCart(id: Int, completion: @escaping (Result<Order, Error>) -> Void) {
        getData(url: "\(Config.baseUrl)/orders/1", type: NFTsInCart.self) { [weak self] result in
            switch result {
            case .success(let data):
                if data.nfts.filter({ $0 == id }).count == 0 {
                    var newOrderContent = data.nfts
                    newOrderContent.append(id)
                    let newOrder = Order(nfts: newOrderContent, id: "1")
                    self?.networkClient.send(request: UpdateOrderRequest(order: newOrder), type: Order.self) { result in
                        switch result {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    self?.networkClient.send(request: UpdateOrderRequest(order: Order(nfts: data.nfts.filter({ $0 != id }), id: "1")), type: Order.self) { result in
                        switch result {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleNFTLikeInProfile(id: Int, completion: @escaping (Result<Profile, Error>) -> Void) {
        getData(url: "\(Config.baseUrl)/profile/1", type: Profile.self) { [weak self] result in
            switch result {
            case .success(let data):
                if data.likes.filter({ $0 == id }).count == 0 {
                    var newProfileLikesContent = data.likes
                    newProfileLikesContent.append(id)
                    let newProfile = Profile(avatar: data.avatar, name: data.name, description: data.description, website: data.website, nfts: data.nfts, likes: newProfileLikesContent, id: data.id)
                    self?.networkClient.send(request: UpdateProfileRequest(profile: newProfile), type: Profile.self) { result in
                        switch result {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    let newProfile = Profile(avatar: data.avatar, name: data.name, description: data.description, website: data.website, nfts: data.nfts, likes: data.likes.filter({ $0 != id}), id: data.id)
                    self?.networkClient.send(request: UpdateProfileRequest(profile: newProfile), type: Profile.self) { result in
                        switch result {
                        case .success(let data):
                            completion(.success(data))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
