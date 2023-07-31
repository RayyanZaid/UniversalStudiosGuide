enum TabItem {
    case home
    case rides
    case map


    var imageName: String {
        switch self {
        case .home:
            return "house.fill"
        case .rides:
            return "car.fill"
        case .map:
            return "map.fill"
        }
    }
}
