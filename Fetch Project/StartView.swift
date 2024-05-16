//
//  StartView.swift
//  Fetch Project
//
//  Created by Casey tirrell on 5/15/24.
//

import SwiftUI

struct StartView: View {
    @State private var isActive = false

    var body: some View {
        NavigationStack {
            ZStack {
                if isActive {
                    MealsView(viewModel: MealsViewModel())
                } 
                else {
                    LinearGradient(gradient: Gradient(colors: [Color("fetchYellow"), Color("fetchOrange")]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Image("fetchLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.bottom, 20)
                        Text("Fetch Desserts!")
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
                        
                        Spacer()
                        
                        Text("Tap anywhere to view desserts")
                            .foregroundColor(Color("fetchPurple"))
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.clear)
                        //.cornerRadius(10)
                        //.shadow(radius: 3)
                            .padding(.top, 20)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    StartView()
}
