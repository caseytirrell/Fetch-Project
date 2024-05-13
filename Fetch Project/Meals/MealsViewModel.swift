//
//  MealsViewModel.swift
//  Fetch Project
//
//  Created by Casey tirrell on 5/13/24.
//

import Foundation

class MealsViewModel: ObservableObject {
    
    @Published var meals: [Meal] = []
    @Published var mealDetails: MealDetails?
    @Published var isLoading = false
    
    func fetchMeals() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let urlString = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert&apikey=1"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let mealsData = try decoder.decode(MealsResponse.self, from: data)
            DispatchQueue.main.async {
                self.meals = mealsData.meals.sorted(by: { $0.strMeal < $1.strMeal })
                self.isLoading = false
                print("Fetched \(self.meals.count) meals.")
            }
        } 
        catch {
            DispatchQueue.main.async {
                print("Failed to fetch meals: \(error)")
                self.isLoading = false
            }
        }
    }

    func fetchMealsDetails(id: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        let urlString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)&apikey=1"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let mealDetailsResponse = try decoder.decode(MealDetailsResponse.self, from: data)
            DispatchQueue.main.async {
                if let details = mealDetailsResponse.meals.first {
                    self.mealDetails = details
                    self.isLoading = false
                }
            }
        } 
        catch {
            DispatchQueue.main.async {
                print("Failed to fetch meal details: \(error)")
                self.isLoading = false
            }
        }
    }
}
