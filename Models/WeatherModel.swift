import Foundation
import UIKit

struct WeatherModel: Decodable {
    let currently: Currently
}

struct Currently: Decodable {
    let temperature: Double
    let icon: String?

    var temperatureCelsius: Int {
        return (Int(temperature) - 32) * 5 / 9
    }
    
    var iconLocal: String {
        switch icon {
        case "clear-day": return "Ясно"
        case "clear-night": return "Світла ніч"
        case "rain": return "Дощ"
        case "snow": return "Сніг"
        case "sleet": return "Мокрий сніг"
        case "wind": return "Вітряно"
        case "fog": return "Туман"
        case "cloudy": return "Хмарно"
        case "partly-cloudy-day": return "Хмурий день"
        case "partly-cloudy-night": return "Хмарна ніч"
        default: return "No data"
        }
    }
    
    var description: String {
        switch icon {
        case "clear-day": return "Гарна погода для тренувань💪"
        case "clear-night": return "Можна і на дворі потренуватися🏃"
        case "rain": return "Сьогодні вдома🏠"
        case "snow": return "Сьогодні вдома🏠"
        case "sleet": return "Сьогодні вдома🏠"
        case "wind": return "Сьогодні вдома🏠"
        case "fog": return "Сьогодні вдома🏠"
        case "cloudy": return "Сьогодні вдома🏠"
        case "partly-cloudy-day": return "Сьогодні вдома🏠"
        case "partly-cloudy-night": return "Може бути дощ🤷"
        default: return "No data"
        }
    }
    
  
}
