//
//  MealsView.swift
//  Fetch Project
//
//  Created by Casey tirrell on 5/13/24.
//

import SwiftUI

struct MealsView: View {
    @ObservedObject var viewModel: MealsViewModel
    @State private var selectedMealID: String?
    var body: some View {
        NavigationView {
            List(viewModel.meals, id: \.id) { meal in
                Button(meal.strMeal) {
                    selectedMealID = meal.idMeal
                    Task {
                        await viewModel.fetchMealsDetails(id: meal.idMeal)
                    }
                }
                .background(
                    NavigationLink(
                        destination: viewModel.mealDetails != nil && viewModel.mealDetails?.idMeal == selectedMealID ? MealDetailsView(mealDetails: viewModel.mealDetails!) : nil,
                        tag: meal.idMeal,
                        selection: $selectedMealID
                    ) {
                        EmptyView()
                    }.hidden()
                )
            }
            .navigationTitle("Desserts")
        }
        .onAppear {
            Task {
                await viewModel.fetchMeals()
            }
        }
    }
}


struct MealDetailsView: View {
    var mealDetails: MealDetails
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: mealDetails.strMealThumb) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                
                Text("Food Area: \(mealDetails.strArea)")
                Text("Instructions: \(mealDetails.strInstructions)")
                
                Text("Ingredients:").font(.headline)
                ForEach(Array(mealDetails.ingredients.keys.sorted()), id: \.self) { key in
                    if let value = mealDetails.ingredients[key], !value.isEmpty {
                        Text("\(key): \(value)")
                    }
                }
            }
            .padding()
        }
        .navigationTitle(mealDetails.strMeal)
    }
}

