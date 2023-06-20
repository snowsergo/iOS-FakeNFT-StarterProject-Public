import Foundation

final class CollectionViewModel: CollectionViewModelProtocol {
    var onNFTCollectionInfoUpdate: (() -> Void)?
    var onNFTAuthorUpdate: (() -> Void)?
    var onNFTItemsUpdate: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var onNFTChanged: (() -> Void)?
    
    var errorMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    var updateLoadingStatus: (() -> Void)?
    var isLoading: Bool {
        didSet {
            updateLoadingStatus?()
        }
    }
    private(set) var allNFTItems: [NFTItem]? {
        didSet {
            generateNFTdata()
        }
    }
    private(set) var nftsLiked: NFTLiked? {
        didSet {
            generateNFTdata()
        }
    }
    private(set) var nftsInCart: NFTsInCart? {
        didSet {
            generateNFTdata()
        }
    }
    
    var model: CollectionModelProtocol
    var nftCollectionId: Int
    var converter: CryptoConverterProtocol
    private(set) var nftCollection: NFTCollection?
    private(set) var nftCollectionAuthor: NFTCollectionAuthor?
    private(set) var nftCollectionItems: [NFTCollectionNFTItem]?
    private(set) var nftCollectionItemsCount: Int?
    
    init(model: CollectionModelProtocol, nftCollectionId: Int, converter: CryptoConverterProtocol) {
        self.model = model
        self.nftCollectionId = nftCollectionId
        self.converter = converter
        isLoading = false
    }
    
    func getNFTCollectionInfo() {
        isLoading = true
        model.getData(url: "\(Config.baseUrl)/collections/\(nftCollectionId)", type: NFTCollection.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.nftCollection = data
                self?.onNFTCollectionInfoUpdate?()
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getNFTCollectionAuthor(id: Int) {
        model.getData(url: "\(Config.baseUrl)/users/\(id)", type: NFTCollectionAuthor.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.nftCollectionAuthor = data
                self?.onNFTAuthorUpdate?()
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getNFTCollectionItems() {
        allNFTItems = nil
        nftsLiked = nil
        nftsInCart = nil
        
        getAllNFTs { [weak self] result in
            switch result {
            case .success(let data):
                self?.allNFTItems = data
            case .failure(let error):
                self?.isLoading = false
                self?.errorMessage = error.localizedDescription
            }
        }
        
        getLikedNFTs { [weak self] result in
            switch result {
            case .success(let data):
                self?.nftsLiked = data
            case .failure(let error):
                self?.isLoading = false
                self?.errorMessage = error.localizedDescription
            }
        }
        
        getNFTsInCart { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let data):
                self?.nftsInCart = data
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getAllNFTs(completion: @escaping (Result<[NFTItem], Error>) -> Void) {
        model.getData(url: "\(Config.baseUrl)/nft", type: [NFTItem].self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getLikedNFTs(completion: @escaping (Result<NFTLiked, Error>) -> Void) {
        model.getData(url: "\(Config.baseUrl)/profile/1", type: NFTLiked.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getNFTsInCart(completion: @escaping (Result<NFTsInCart, Error>) -> Void) {
        model.getData(url: "\(Config.baseUrl)/orders/1", type: NFTsInCart.self) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleCart(id: Int) {
        isLoading = true
        model.toggleNFTItemInCart(id: id) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let data):
                self?.nftsInCart = NFTsInCart(nfts: data.nfts)
                self?.onNFTItemsUpdate?()
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func toggleLike(id: Int) {
        isLoading = true
        model.toggleNFTLikeInProfile(id: id) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let data):
                self?.nftsLiked = NFTLiked(likes: data.likes)
                self?.onNFTItemsUpdate?()
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func generateNFTdata() {
        guard let allNFTItems = allNFTItems,
              let nftsLiked = nftsLiked,
              let nftsInCart = nftsInCart,
              let nfts = nftCollection?.nfts
        else { return }
        var result: [NFTCollectionNFTItem] = []
        
        nfts.forEach {
            let id = $0.self
            guard let nft = allNFTItems.first(where: { $0.id == "\(id)" }),
                  let image = nft.images.first
            else { return }
            
            let liked = nftsLiked.likes.filter { $0 == id }.count > 0 ? true : false
            let inCart = nftsInCart.nfts.filter { $0 == id }.count > 0 ? true : false
            
            result.append( NFTCollectionNFTItem(id: id, image: image, rating: nft.rating, name: nft.name, price: converter.convertUSD(to: .ETH, amount: nft.price), liked: liked, inCart: inCart) )
        }
        
        nftCollectionItems = result
        nftCollectionItemsCount = result.count
        onNFTItemsUpdate?()
    }
}
