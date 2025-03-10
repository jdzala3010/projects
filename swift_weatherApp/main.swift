import Foundation

let apiKey = "Your API_KEY"
let baseURL = "https://api.openweathermap.org/data/2.5/weather"

// Struct to store weather details
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description: String
}

// Function to fetch weather data
func fetchWeather(for city: String) async {
    let urlString = "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric"
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    print("Fetching weather for \(city)...")

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Print HTTP response status
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        // Print raw JSON response
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Raw JSON Response:\n\(jsonString)")
        }
        
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
        
        print("\nWeather in \(weatherData.name)")
        print("Temperature: \(weatherData.main.temp)°C")
        print("Humidity: \(weatherData.main.humidity)%")
        print("Condition: \(weatherData.weather.first?.description ?? "Unknown")")
    } catch {
        print("Error fetching weather: \(error.localizedDescription)")
    }
}

print("Enter a city name:")
if let city = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
    Task {
        await fetchWeather(for: city)
        exit(0)
    }
}

dispatchMain()
