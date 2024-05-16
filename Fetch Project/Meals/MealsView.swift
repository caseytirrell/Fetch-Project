//
//  MealsView.swift
//  Fetch Project
//
//  Created by Casey tirrell on 5/13/24.
//

import SwiftUI
import WebKit

//Youtube player to play the youtube video URLs for the meal details
struct YoutubePlayer: UIViewRepresentable {
    var videoURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let video = URLRequest(url: videoURL)
        uiView.load(video)
    }
}

struct MealsView: View {
    @ObservedObject var viewModel: MealsViewModel
    
    @State private var selectedMealID: String?

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("fetchYellow"), Color("fetchOrange")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 10) {
                    
                    Image("fetchLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    Text("Fetch Desserts!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color("fetchPurple").opacity(1.0),
                                Color("fetchPurple").opacity(0.9),
                                Color("fetchPurple").opacity(0.8)
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .cornerRadius(10)
                        .shadow(color: Color("fetchPurple").opacity(0.5), radius: 10, x: 0, y: 4)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                    
                    List(viewModel.meals, id: \.id) { meal in
                        Button(action: {
                            selectedMealID = meal.idMeal
                            Task {
                                await viewModel.fetchMealsDetails(id: meal.idMeal)
                            }
                        }) {
                            HStack {
                                AsyncImage(url: meal.strMealThumb) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("fetchPurple"), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                                
                                Text(meal.strMeal)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 16))
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [
                                            Color("fetchPurple").opacity(1.0),
                                            Color("fetchPurple").opacity(0.9),
                                            Color("fetchPurple").opacity(0.8)
                                        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                        }
                        .listRowBackground(Color.clear)
                        .buttonStyle(PlainButtonStyle())
                        .background(
                            NavigationLink(destination: viewModel.mealDetails != nil && viewModel.mealDetails?.idMeal == selectedMealID ? MealDetailsView(mealDetails: viewModel.mealDetails!) : nil, tag: meal.idMeal, selection: $selectedMealID) {
                                EmptyView()
                            }
                                .hidden()
                        )
                    }
                    .listStyle(PlainListStyle())
                    .padding()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .center, spacing: 20) {
                Text("\(mealDetails.strMeal)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [
                            Color("fetchPurple").opacity(1.0),
                            Color("fetchPurple").opacity(0.9),
                            Color("fetchPurple").opacity(0.8)
                        ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        
                    )
                    .cornerRadius(10)
                    .shadow(color: Color("fetchPurple").opacity(0.5), radius: 10, x: 0, y: 4)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                    .padding(.top, 5)
            }
            
            ScrollView {
                
                AsyncImage(url: mealDetails.strMealThumb) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .aspectRatio(contentMode: .fill)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("fetchPurple"), lineWidth: 1)
                )
                .shadow(radius: 5)
                .padding(.bottom, 20)
                
                VStack(alignment: .center, spacing: 20) {
                    
                    Label("Category: \(mealDetails.strCategory)", systemImage: "tag")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color("fetchPurple").opacity(1.0),
                                Color("fetchPurple").opacity(0.9),
                                Color("fetchPurple").opacity(0.8)
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            
                        )
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    
                    Label("Area: \(mealDetails.strArea)", systemImage: "map")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color("fetchPurple").opacity(1.0),
                                Color("fetchPurple").opacity(0.9),
                                Color("fetchPurple").opacity(0.8)
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            
                        )
                        .cornerRadius(10)
                        .shadow(radius: 3)

                    Label("Tags: \(mealDetails.strTags ?? "No Tags")", systemImage: "tag.fill")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [
                                Color("fetchPurple").opacity(1.0),
                                Color("fetchPurple").opacity(0.9),
                                Color("fetchPurple").opacity(0.8)
                            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            
                        )
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .padding(.bottom , 5)
                    
                }
                
                Divider()
                    .font(.headline)
                    .foregroundColor(Color("fetchPurple"))
                    .frame(width: 1)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 20) {
                    Text("Instructions:")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("fetchPurple"))
                        .padding(.bottom, 5)
                        .padding(.top, 5)
                    HStack(spacing: 0) {
                        Text("\(mealDetails.strInstructions)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color("fetchPurple"))
                            .padding()
                    }
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Divider()
                        .font(.headline)
                        .foregroundColor(Color("fetchPurple"))
                        .frame(width: 1)
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 20) {
                    Text("Ingredients:")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("fetchPurple"))
                        .padding(.bottom, 5)
                    
                    HStack(spacing: 0) {
                        Spacer()
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(Array(mealDetails.ingredients.keys.sorted()), id: \.self) { key in
                                if let _ = mealDetails.ingredients[key], !mealDetails.ingredients[key]!.isEmpty {
                                    Text("\(key)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("fetchPurple"))
                                        .padding(.bottom, 5)
                                        .frame(width: 130, alignment: .leading)
                                }
                            }
                        }
                        
                        Rectangle()
                            .fill(Color("fetchPurple"))
                            .frame(width: 2)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            ForEach(Array(mealDetails.ingredients.keys.sorted()), id: \.self) { key in
                                if let value = mealDetails.ingredients[key], !value.isEmpty {
                                    Text("\(value)")
                                        .font(.caption)
                                        .foregroundColor(Color("fetchPurple"))
                                        .padding(.bottom, 5)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                }
                .padding(.horizontal, 10)
                
                if let youtubeURL = mealDetails.strYoutube {
                    YoutubePlayer(videoURL: youtubeURL)
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding(.vertical, 10)
                }
                if let source = mealDetails.strSource {
                    Link(destination: source) {
                        Text("Open Source Website")
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("fetchPurple"))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
                else {
                    Text("No Source Available.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color("fetchYellow"), Color("fetchOrange")]), startPoint: .top, endPoint: .bottom))
    }
}


