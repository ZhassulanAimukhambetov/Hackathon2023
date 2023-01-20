//
//  AdvertItem.swift
//  CompareModule
//
//  Created by Nikolai Salmin on 21.01.2023.
//


import Foundation
import UIKit

struct AdvertsSearchResult: Decodable {
    let items: [AdvertItem]
}

struct AdvertItem: Decodable {
    let type: AdListItemType
    let advertData: ListAdvert?
}

enum AdListItemType: String, Decodable {
    case advert
//    Необходим для корректного отображения списка, в случае если придет неизвестный энаму тип,
//    то мы просто подменим его на unexpectedValue, без этого кейса список отображаться не будет
    case unexpectedValue
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        
        if let type = AdListItemType(rawValue: stringValue) {
            self = type
        } else {
            self = .unexpectedValue
        }
    }
}

struct KaspiCreditInfoData: Decodable {
    let title: String
    let buttonText: String?
    let buttonUrl: String?
    let isGuideDesign: Bool
    let items: [KaspiItem]
    
    struct KaspiItem: Decodable {
        let number: Int
        let text: String
    }
}


@objcMembers final class ListAdvert: NSObject, Decodable, BasicAdvert {
    let advertIntId: Int
    let advertId: String
    let categoryIntId: Int
    let categoryId: String
    let sectionId: Int
    let storage: AdvertStorage
    let userId: Int

    let title: String
    let advertDescription: String?
    let descriptionExtra: String?
    let descriptionList: [String]

    let price: String?
    let creditMonthPay: String?
    
    let isNewAutoPro: Bool
    let isDealer: Bool
    let isNewAutoCondition: Bool
    let color: AdvertColor
    let badges: [String]
    let resaleLabels: ResaleTag?

    let region: String
    let addDate: String

    let viewsCount: Int
    let likesCount: Int
    let photosCount: Int
    let photoPlaceholderName: String
    let photo: AdvertPhoto?

    let emergencyLabel: String?
    let conditionLabel: String?
    let availabilityLabel: String?
    
    let isFavorite: Bool
    let regionAlias: String?
    let phones: [String]
    let isAvailableForCredit: Bool
    
    var storageId: String
    
    init(from decoder: Decoder) throws {
        let advertDecoder = try AdvertDecoder(decoder: decoder)
        advertIntId = advertDecoder.advertId
        advertId = String(advertIntId)
        categoryIntId = advertDecoder.categoryId
        categoryId = String(categoryIntId)
        sectionId = advertDecoder.sectionId
        storage = advertDecoder.storage
        userId = advertDecoder.userId
        
        title = advertDecoder.title
        advertDescription = advertDecoder.advertDescription
        descriptionExtra = advertDecoder.descriptionExtra
        descriptionList = advertDecoder.descriptionList
        
        price = advertDecoder.formattedPrice
        creditMonthPay = advertDecoder.creditMonthPay
        
        isNewAutoPro = advertDecoder.isNewAutoPro
        isDealer = advertDecoder.isDealer
        isNewAutoCondition = advertDecoder.isNewAutoCondition
        resaleLabels = advertDecoder.resaleLabels
        color = advertDecoder.hasPaidPackages ? advertDecoder.color : AdvertColor.white
        badges = advertDecoder.badges
        
        region = advertDecoder.region
        regionAlias = advertDecoder.regionAlias
        addDate = advertDecoder.addDate
        
        viewsCount = advertDecoder.viewsCount
        likesCount = advertDecoder.likesCount
        photosCount = advertDecoder.photosCount
        photoPlaceholderName = advertDecoder.photoPlaceholderName
        photo = advertDecoder.photo
        
        emergencyLabel = advertDecoder.emergencyLabel
        conditionLabel = advertDecoder.conditionLabel
        availabilityLabel = advertDecoder.availabilityLabel
        
        isFavorite = advertDecoder.isFavorite
        phones = advertDecoder.phones
        isAvailableForCredit = advertDecoder.isAvailableForCredit
        storageId = storage.rawValue
    }
}

enum AdvertStorage: String, Decodable {
    case live
    case archive
    case edit
    case temporary = "temp"
    case deleted = "delete"
    case unknown
}

@objc enum AdvertColor: Int, Decodable {
    case white = 0
    case yellow = 2
    case blue = 3
    
    var color: UIColor {
        switch self {
        case .yellow:
            return UIColor.yellow.withAlphaComponent(0.3)
        case .blue:
            return UIColor.blue.withAlphaComponent(0.3)
        default:
            return UIColor.white
        }
    }
}
@objcMembers final class ResaleTag: NSObject, Decodable {
    let name: String?
    let bonus: String?
}

@objcMembers final class AdvertPhoto: NSObject, Decodable {
    
    enum Errors: Error {
        case incorrectFormat
        case noData
    }
    
    private static let smallModerationPlaceholderURL =
        Bundle.main.url(forResource: "placeholder_on_moderation_small_png",
                        withExtension: "png")
    private static let largeModerationPlaceholderURL =
        Bundle.main.url(forResource: "placeholder_on_moderation_large_png",
                        withExtension: "png")
    
    private static let thumbnailImageSize: String = ThumbnailImageSize(scale: UIScreen.main.scale).size
    
    private let photoURLString: String?
    private let isModerated: Bool
    
    let photoURL: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isModerated = try container.decode(Bool.self, forKey: .isModerated)
        
        let photoURLString = try container.decodeIfPresent(String.self, forKey: .photoURLString)
        let photoURL = URL(string: photoURLString ?? "")
        self.photoURLString = photoURL != nil ? photoURLString : nil
        
        if isModerated {
            guard let photoURL = photoURL else {
                throw Errors.incorrectFormat
            }
            
            self.photoURL = photoURL
        } else if let placeholder = Self.smallModerationPlaceholderURL {
            self.photoURL = placeholder
        } else {
            assertionFailure("Нет изображения маленькой заглушки")
            throw Errors.noData
        }
    }
    
    lazy var thumbnailPhotoUrl: URL? = {
        guard isModerated else {
            if let placeholderURL = Self.smallModerationPlaceholderURL {
                return placeholderURL
            }
            
            assertionFailure("Нет изображения большой заглушки")
            return nil
        }
        
        return photoURL(forSize: Self.thumbnailImageSize, isModerationCheckNeeded: false)
    }()
    
    func photoURL(forSize size: String, isModerationCheckNeeded: Bool) -> URL? {
        if (isModerationCheckNeeded || photoURLString == nil) && !isModerated {
            return Self.largeModerationPlaceholderURL
        }
        
        guard let photoURL = photoURLString?.replacingOccurrences(of: "-full", with: size) else { return nil }
        
        return URL(string: photoURL)
    }
    
    private enum ThumbnailImageSize: Int {
        case scale1 = 1
        case scale2
        case scale3
        
        init(scale: CGFloat) {
            self = ThumbnailImageSize(rawValue: Int(scale)) ?? .scale1
        }
        
        var size: String {
            switch self {
            case .scale1:
                return "-336x252"
            case .scale2:
                return "-440x330"
            case .scale3:
                return "-672x504"
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case isModerated, photoURLString = "path"
    }
}

final class AdvertDecoder: NSObject {
    lazy var advertId = (try? container.decode(Int.self, forKey: .advertId)) ?? 0
    lazy var sectionId = (try? container.decode(Int.self, forKey: .sectionId)) ?? 0
    lazy var categoryId = (try? container.decode(Int.self, forKey: .categoryId)) ?? 0
    lazy var userId = (try? container.decode(Int.self, forKey: .userId)) ?? 0
    lazy var storage = (try? container.decode(AdvertStorage.self, forKey: .storage)) ?? .unknown

    lazy var title = (try? container.decode(String.self, forKey: .title)) ?? ""
    lazy var advertDescription = try? container.decode(String.self, forKey: .description)
    lazy var descriptionExtra = try? container.decode(String.self, forKey: .descriptionExtra)
    lazy var descriptionList = (try? container.decode([String].self, forKey: .descriptionList)) ?? []
    
    lazy var mark = try? container.decode(String.self, forKey: .mark)
    lazy var model = try? container.decode(String.self, forKey: .model)
    lazy var price = (try? container.decode(Int.self, forKey: .price)) ?? 0
    lazy var isNewAutoPro = (try? container.decode(Bool.self, forKey: .isNewAutoPro)) ?? false
    lazy var isDealer = (try? container.decode(Bool.self, forKey: .isDealer)) ?? false
    lazy var isNewAutoCondition = (try? container.decode(Bool.self, forKey: .isNewAutoCondition)) ?? false
    lazy var resaleLabels = (try? container.decode(ResaleTag.self, forKey: .resaleLabels))
    
    lazy var viewsCount = (try? container.decode(Int.self, forKey: .viewsCount)) ?? 0
    lazy var likesCount = (try? container.decode(Int.self, forKey: .likesCount)) ?? 0
    
    lazy var region = (try? container.decode(String.self, forKey: .region)) ?? ""
    lazy var regionAlias = (try? container.decode(String.self, forKey: .regionAlias)) ?? ""
    lazy var updatedDate = (try? container.decode(String.self, forKey: .updatedDate)) ?? ""
    
    lazy var hasPaidPackages = (try? container.decode(Bool.self, forKey: .hasPaidPackages)) ?? false
    lazy var isHot = (try? container.decode(Bool.self, forKey: .isHot)) ?? false
    lazy var isUp = (try? container.decode(Bool.self, forKey: .isUp)) ?? false
    lazy var isVip = (try? container.decode(Bool.self, forKey: .isVip)) ?? false
    lazy var isTurbo = (try? container.decode(Bool.self, forKey: .isTurbo)) ?? false
    lazy var isFast = (try? container.decode(Bool.self, forKey: .isFast)) ?? false
    
    lazy var emergencyLabel = try? container.decode(String.self, forKey: .emergencyLabel)
    lazy var conditionLabel = try? container.decode(String.self, forKey: .conditionLabel)
    lazy var availabilityLabel = try? container.decode(String.self, forKey: .availabilityLabel)

    lazy var badges = ((try? container.decode([String].self, forKey: .badges)) ?? []).map { "purchase_\($0)" }
    lazy var color: AdvertColor = (try? container.decode(AdvertColor.self, forKey: .color)) ?? .white
    
    lazy var photosCount = (try? container.decode(Int.self, forKey: .photosCount)) ?? 0
    lazy var photo: AdvertPhoto? = try? container.decode(AdvertPhoto.self, forKey: .photo)
    lazy var photos = try? container.decode([AdvertPhoto].self, forKey: .photos)
    lazy var photoPlaceholderName = "placeholder_section_\(sectionId)"
    
    lazy var formattedPrice: String? = {
        guard price > 0,
              let formattedPrice = NumberFormatter.currencyFormatter.string(from: NSNumber(value: price)) else {
            return nil
        }
        
        return formattedPrice + "T"
    }()
    
    lazy var creditMonthPay: String? = {
        guard let creditMonthPay = try? container.decode(Int.self, forKey: .creditMonthPay),
              let formattedPay = NumberFormatter.currencyFormatter.string(from: NSNumber(value: creditMonthPay)) else {
            return "nil"
        }
        
        return formattedPay + "AdView.Label.CreditMonthPay"
    }()
    
    lazy var addDate: String = {
        let dateString = try? container.decode(String.self, forKey: .addDateFormatted)
        
        return dateString ?? ""
    }()
    
    lazy var mileage: String? = {
        guard let mileage = (try? container.decode(Int.self, forKey: .mileage)) else { return nil }
        
        return String(mileage)
    }()
    
    lazy var year: String? = {
        guard let year = (try? container.decode(Int.self, forKey: .year)) else { return nil }
        
        return String(year)
    }()
    
    lazy var isFavorite: Bool = {
        guard let isFavorite = (try? container.decode(Bool.self, forKey: .isFavorite)) else { return false }
        
        return isFavorite
    }()
    
    lazy var phones = (try? container.decode([String].self, forKey: .phones)) ?? []
    
    lazy var isAvailableForCredit = (try? container.decode(Bool.self, forKey: .isAvailableForCredit)) ?? false
    
    private let container: KeyedDecodingContainer<CodingKeys>
    
    init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.container = container
    }
    
    private enum CodingKeys: String, CodingKey {
        case advertId = "id", sectionId, categoryId
        case storage, userId
        case title, description, descriptionExtra, descriptionList
        case price, creditMonthPay
        case color, hasPaidPackages, badges
        case addDateFormatted, updatedDate = "updatedAt"
        case region, regionAlias
        case photo, photos
        case isHot, isUp, isVip, isTurbo, isFast
        case emergencyLabel, conditionLabel
        case availabilityLabel = "forOrderLabel"
        case mark = "autoCarMark", model = "autoCarModel"
        case mileage = "advertRun", year = "carYear"
        case isNewAutoPro, isNewAutoCondition, isDealer
        case resaleLabels
        case photosCount = "photosAmount"
        case viewsCount = "viewsNumber"
        case likesCount = "favoritesCount"
        case isFavorite, phones, isAvailableForCredit
    }
}

@objc protocol BasicAdvert: NSObjectProtocol {
    var advertId: String { get }
    var storageId: String { get set }
    var categoryId: String { get }
    var regionAlias: String? { get }
}

extension BasicAdvert {
    /// Является ли объявление от дилера и от компании
    var isDealerFromCompany: Bool {
        false
    }
    
    /// ID - категория для объявления от компании. Всегда является постоянным значением.
    private var companyCategoryId: String {
        "55"
    }
}


extension NumberFormatter {
    public static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_Kz")
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = ""
        
        return formatter
    }()
    
    public static var doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        return formatter
    }()
}
