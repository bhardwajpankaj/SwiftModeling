


struct ComponentError: Codable {
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}

struct DataClass: Decodable {
    let accessToken: String?
    let userDetails: UserDetails?
    let tokenType: String?
    let mobileNumberExists: Bool?
    let profile: LoginProfile?
    
    enum CodingKeys: String, CodingKey {
        case userDetails = "userDetails"
        case accessToken = "accessToken"
        case tokenType = "tokenType"
        case profile = "profile"
        case mobileNumberExists = "mobileNumberExists"
    }
}


struct UserDetails:Decodable {
    let name : String?
}


struct Info: Codable {
}
//******************************************************************************************************************************************************************


enum ComponentDataType:String,Codable{
    case label
    case input_text
    case chipGroup
    case cta
    case subLabel
    case button
    case chipGroupHorizontal
    case modalSelect
    case selectionMulti
    case checkbox
    case singleSelection
    case dropDownSelector
    case floatInput
    case socialLogins
    case formNameInput
    case formEmailInput
    case formMobileInput
    case formPasswordInput
    case googleDrive
    case dropBox
    case phone
    case none
    case formNumberInput
    case multiSelectChipGroup
    case image
    case radioItem
    case float_text
}
enum ProfileCellType:String,Codable {
    
    case chipSelection
    case checkbox
    case floatInput
    case formDropDownSelector
    case formFloatInput
    case dropdownSelectWithChipGroup
    case skill
    case cvUpload
    case experience
    case toggleSingleSelection
    case password
    case socialLogins
    case formNameInput
    case formEmailInput
    case formMobileInput
    case formPasswordInput
    case formNumberInput
    case multiSelect
    case otherPage
    case radioGroup
    case none
}
enum DataType : String , Codable{
    case string
    case array
    case jsonArray
}

struct ScreensConfig:Decodable{
    let defaultFlow: [String]?
    let experimentId:String?
    let variationId:String?
    let firstScreenId:String?
    let screens:[String: Screen]?
}

class Screen:Decodable {
    let id:String?
    let name:String?
    let description:String?
    let header:ScreenHeader?
    let ctaText : String?
    let isSkippable : Bool?
    let defaultComponents : [String]?
    let componentIds : [String]?
    let components:[ScreenComponent]?
}

class ScreenComponent:Decodable {
    let id:String?
    let type:ProfileCellType?
    let description:String?
    let dependents:[String]?
    var data :[ComponentData]?
    var isFilled:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case description = "description"
        case dependents = "dependents"
        case data = "data"
    }
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try dataContainer.decodeIfPresent(String.self, forKey: .id)
        
        do {
            type = try dataContainer.decodeIfPresent(ProfileCellType.self, forKey: .type)
        } catch  {
            type = ProfileCellType.none
        }
//        type = try dataContainer.decodeIfPresent(ProfileCellType.self, forKey: .type)
        description = try dataContainer.decodeIfPresent(String.self, forKey: .description)
        dependents = try dataContainer.decodeIfPresent([String].self, forKey: .dependents)
        data = try dataContainer.decodeIfPresent([ComponentData].self, forKey: .data)
    }
    
}
class ComponentData: Decodable,Hashable{
    static func == (lhs: ComponentData, rhs: ComponentData) -> Bool {
        return lhs.jsonKey == rhs.jsonKey
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.jsonKey)
    }
    let id: String?
    let entity:String?
    let jsonKey:String?
    let type: ComponentDataType?
    let dataType: DataType?
    let value: Any?
    let additionalProperties: [String:String]?
    //local variable for handling
    var options :[Options]?
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case entity = "entity"
        case jsonKey = "jsonKey"
        case id = "id"
        case dataType = "dataType"
        case additionalProperties = "additionalProperties"
        case value = "value"
    }
    
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try dataContainer.decode(String?.self, forKey: .id)
        entity = try dataContainer.decode(String?.self, forKey: .entity)
        jsonKey = try dataContainer.decode(String?.self, forKey: .jsonKey)
        
        do {
            type = try dataContainer.decode(ComponentDataType?.self, forKey: .type)
        } catch  {
            type = ComponentDataType.none
        }
        
        do {
            dataType = try dataContainer.decode(DataType?.self, forKey: .dataType)
        } catch {
            dataType = DataType.string
        }
        
        additionalProperties = try dataContainer.decode([String:String]?.self, forKey: .additionalProperties)
        do {
            let type = try dataContainer.decode(DataType.self, forKey: .dataType)
            switch type {
            case .string:
                value = try dataContainer.decode(String.self, forKey: .value)
            case .array:
                value = try dataContainer.decode(Array<String>.self, forKey: .value)
            case .jsonArray:
                let newValue:String = try dataContainer.decode(String.self, forKey: .value)
                let jsonData = newValue.data(using: .utf8)!
                let decoder = JSONDecoder()
                value = try decoder.decode([Options].self, from: jsonData)
            }
        }catch {
            value = try dataContainer.decode(String.self, forKey: .value)
        }
    }
}



class ScreenHeader:Codable {
    let label:String?
    let progress:String?
    
    enum CodingKeys:String,CodingKey {
        case label = "label"
        case progress = "progress"
    }
}
class Options:Decodable{
    var id:String?
    var name : String?
    //local variable
    var isSelected:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

// Class is NSObject and properties are marked @objc because we are using KVC while saving posted dictionary to save in singleton object

class LoginProfile: NSObject,Decodable {
    @objc var id: String?
    @objc var userId: String?
    @objc var domainId: String?
    @objc var jobSearchStatus : String?
    @objc var specializationId: String?
    @objc var experienceYear: String?
    @objc var experienceMonth: String?
    @objc var cvPath: String?
    @objc var active: Bool = false
    @objc var isWorkingInManagementRole: Bool = false
    @objc var userRecommendationDimensions: [String]?
    @objc var skills: [Skills]?
    @objc var latestCompanyDetails: LatestCompanyDetails?
    @objc var latestEducationDetails: LatestEducationDetails?
    @objc var isUserProfileCompleted : Bool = false
    @objc var fileName:String?
    @objc var preferences:UserPreference?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "userId"
        case domainId = "domainId"
        case jobSearchStatus = "jobSearchStatus"
        case specializationId = "specializationId"
        case experienceYear = "experienceYear"
        case experienceMonth = "experienceMonth"
        case cvPath = "cvPath"
        case active = "active"
        case isWorkingInManagementRole = "isWorkingInManagementRole"
        case userRecommendationDimensions = "userRecommendationDimensions"
        case skills = "skills"
        case latestCompanyDetails = "latestCompanyDetails"
        case latestEducationDetails = "latestEducationDetails"
        case isUserProfileCompleted = "isUserProfileCompleted"
        case fileName = "fileName"
        case preferences = "preferences"
    }
    
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try dataContainer.decodeIfPresent(String.self, forKey: .id)
        userId = try dataContainer.decodeIfPresent(String.self, forKey: .userId)
        jobSearchStatus = try dataContainer.decodeIfPresent(String.self, forKey: .jobSearchStatus)
        domainId = try dataContainer.decodeIfPresent(String.self, forKey: .domainId)
        specializationId = try dataContainer.decodeIfPresent(String.self, forKey: .specializationId)
        do {
            if let experienceYearValue = try dataContainer.decodeIfPresent(Int.self, forKey: .experienceYear) {
                experienceYear = String(experienceYearValue)
            }
        }catch{
            experienceYear = try dataContainer.decodeIfPresent(String.self, forKey: .experienceYear)
        }
        
        do{
            if let experienceMonthValue = try dataContainer.decodeIfPresent(Int.self, forKey: .experienceMonth) {
                experienceMonth = String(experienceMonthValue)
            }
        }
        catch{
            experienceMonth = try dataContainer.decodeIfPresent(String.self, forKey: .experienceMonth)
        }
        cvPath = try dataContainer.decodeIfPresent(String.self, forKey: .cvPath)
        do{
            if let activeValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .active){
                active = activeValue
            }
        }
        catch{
            active = false
        }
        do{
            if let workingInManagementRoleValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .isWorkingInManagementRole){
                isWorkingInManagementRole = workingInManagementRoleValue
            }
        }catch{
            isWorkingInManagementRole = false
        }
        userRecommendationDimensions = try dataContainer.decodeIfPresent([String].self, forKey: .userRecommendationDimensions)
        skills = try dataContainer.decodeIfPresent([Skills].self, forKey: .skills)
        latestCompanyDetails = try dataContainer.decodeIfPresent(LatestCompanyDetails.self, forKey: .latestCompanyDetails)
        latestEducationDetails = try dataContainer.decodeIfPresent(LatestEducationDetails.self, forKey: .latestEducationDetails)
        do{
            if let isUserProfileCompletedValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .isUserProfileCompleted){
                isUserProfileCompleted = isUserProfileCompletedValue
            }
        }
        catch{
            isUserProfileCompleted = false
        }
        fileName = try dataContainer.decodeIfPresent(String.self, forKey: .fileName)
        preferences = try dataContainer.decodeIfPresent(UserPreference.self, forKey: .preferences)
    }
    
}
class ProfileBasicDetails:NSObject,Decodable{
    @objc var id:String?
    @objc var name:String?
    @objc var email:String?
    @objc var imageUrl :String?
    @objc var emailVerified:Bool = false
    @objc var phoneNumber:String?
    @objc var phoneVerified:Bool = false
    @objc var activeProfileId:String?
    @objc var active:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case imageUrl = "imageUrl"
        case emailVerified = "emailVerified"
        case phoneNumber = "phoneNumber"
        case phoneVerified = "phoneVerified"
        case activeProfileId = "activeProfileId"
        case active = "active"
    }
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try dataContainer.decodeIfPresent(String.self, forKey: .id)
        name = try dataContainer.decodeIfPresent(String.self, forKey: .name)
        email = try dataContainer.decodeIfPresent(String.self, forKey: .email)
        imageUrl = try dataContainer.decodeIfPresent(String.self, forKey: .imageUrl)
        do{
            if let emailVerifiedValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .emailVerified){
                emailVerified = emailVerifiedValue
            }
        }
        catch{
            emailVerified = false
        }
        phoneNumber = try dataContainer.decodeIfPresent(String.self, forKey: .phoneNumber)
        do{
            if let phoneVerifiedValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .phoneVerified){
                phoneVerified = phoneVerifiedValue
            }
        }
        catch{
            phoneVerified = false
        }
        activeProfileId = try dataContainer.decodeIfPresent(String.self, forKey: .activeProfileId)
        do{
            if let activeValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .active){
                active = activeValue
            }
        }
        catch{
            active = false
        }
    }
  
}

class Skills:NSObject,Codable{
    @objc var experienceMonth:String?
    @objc var experienceYear:String?
    @objc var name:String?
    @objc var skillId:String?
    enum CodingKeys: String, CodingKey {
        case experienceMonth = "experienceMonth"
        case experienceYear = "experienceYear"
        case name = "name"
        case skillId = "skillId"
    }
     required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            if let experienceYearValue = try dataContainer.decodeIfPresent(Int.self, forKey: .experienceYear){
                experienceYear = String(experienceYearValue)
            }
        } catch  {
            experienceYear = try dataContainer.decodeIfPresent(String.self, forKey: .experienceYear)
        }
        do {
            if let experienceMonthValue = try dataContainer.decodeIfPresent(Int.self, forKey: .experienceMonth){
                experienceMonth = String(experienceMonthValue)
            }
        } catch  {
            experienceMonth = try dataContainer.decodeIfPresent(String.self, forKey: .experienceMonth)
        }
        name = try dataContainer.decodeIfPresent(String.self, forKey: .name)
        skillId = try dataContainer.decodeIfPresent(String.self, forKey: .skillId)
    }
}


class LatestCompanyDetails: NSObject,Codable {
    @objc var company: EntityDTO?
    @objc var ctc : String?
    @objc var isCTCConfidential    :Bool = false
    @objc var endWorkingDate    :String?
    @objc var jobTitle    :EntityDTO?
    @objc var location    :EntityDTO?
    @objc var noticePeriodId    :String?
    @objc var startWorkingDate    :String?
    
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        company = try dataContainer.decodeIfPresent(EntityDTO.self, forKey: .company)
        do{
            if let ctcValue = try dataContainer.decodeIfPresent(Double.self, forKey: .ctc) {
                ctc = String(ctcValue)
            }
        }catch{
            ctc = try dataContainer.decodeIfPresent(String.self, forKey: .ctc)
        }
        
        do{
            if let ctcconfidentialValue = try dataContainer.decodeIfPresent(Bool.self, forKey: .isCTCConfidential){
                isCTCConfidential = ctcconfidentialValue
            }
        }catch{
            isCTCConfidential = false
        }
        endWorkingDate = try dataContainer.decodeIfPresent(String.self, forKey: .endWorkingDate)
        jobTitle = try dataContainer.decodeIfPresent(EntityDTO.self, forKey: .jobTitle)
        location = try dataContainer.decodeIfPresent(EntityDTO.self, forKey: .location)
        do{
            if let noticePeriodValue = try dataContainer.decodeIfPresent(Int.self, forKey: .noticePeriodId){
                noticePeriodId = String(noticePeriodValue)
            }
        }catch{
            noticePeriodId = try dataContainer.decodeIfPresent(String.self, forKey: .noticePeriodId)
        }
        
        startWorkingDate = try dataContainer.decodeIfPresent(String.self, forKey: .startWorkingDate)
    }
}
class LatestEducationDetails:NSObject,Codable{
    @objc var college     :EntityDTO?
    @objc var course     :EntityDTO?
    @objc var courseDepartment     :EntityDTO?
    @objc var yearOfPassing     :String?
}

class UserPreference : NSObject,Codable{
    @objc var benefits : [EntityDTO]?
    @objc var companyTypes : [EntityDTO]?
    @objc var expectedCTC:String?
    @objc var locations : [EntityDTO]?
    @objc var roleTypes : [EntityDTO]?
    @objc var profilePrivacy : String?
    @objc var profilePrivacyDescription:String?
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: CodingKeys.self)
        benefits = try dataContainer.decodeIfPresent([EntityDTO].self, forKey: .benefits)
        companyTypes = try dataContainer.decodeIfPresent([EntityDTO].self, forKey: .companyTypes)
        locations = try dataContainer.decodeIfPresent([EntityDTO].self, forKey: .locations)
        roleTypes = try dataContainer.decodeIfPresent([EntityDTO].self, forKey: .roleTypes)
        do{
            if let expectedCTCValue = try dataContainer.decodeIfPresent(Double.self, forKey: .expectedCTC) {
                expectedCTC = String(expectedCTCValue)
            }
        }catch{
            expectedCTC = try dataContainer.decodeIfPresent(String.self, forKey: .expectedCTC)
        }
        profilePrivacy = try dataContainer.decodeIfPresent(String.self, forKey: .profilePrivacy)
        profilePrivacyDescription = try dataContainer.decodeIfPresent(String.self, forKey: .profilePrivacyDescription)
    }
    

}

class EntityDTO :NSObject,Codable{
    @objc var id : String?
    @objc var name : String?
    
    init(id:String,name:String) {
        self.id = id
        self.name = name
        super.init()
    }
}
