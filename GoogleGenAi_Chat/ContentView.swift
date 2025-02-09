//
//  ContentView.swift
//  GoogleGenAi_Chat
//
//  Created by mahesh lad on 12/12/2024.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    @State private var generatedText : LocalizedStringKey = ""
    @State private var prompt  = ""//"Explain how AI works"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text(generatedText)
                        
                    TextField(
                        "Enter a question",
                        text: $prompt
                    )
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(10)
                    .autocorrectionDisabled()
                    .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }
                    Button("Generate Text") {
                        Task {
                            do {
                                let config = GenerationConfig(
                                    temperature: 1,
                                    topP: 0.95,
                                    topK: 40,
                                    maxOutputTokens: 8192,
                                    responseMIMEType: "text/plain"
                                )
                                
                                // Don't check your API key into source control!
                                guard let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] else {
                                    fatalError("Add GEMINI_API_KEY as an Environment Variable in your app's scheme.")
                                }
                                // Replace "YOUR_API_KEY" with your actual API key
                                let model = GenerativeModel(
                                    name: "gemini-1.5-flash",
                                    apiKey: apiKey,
                                    generationConfig: config
                                )
                                
                                let chat = model.startChat(history: [
                                    
                                ])
                                
                                let message = prompt //"INSERT_INPUT_HERE"
                                let response = try await chat.sendMessage(
                                    message
                                )
                                
                                let resp = LocalizedStringKey(response.text ?? "No response received")
                              
                                generatedText = resp
                            } catch {
                                print("Error: \(error)")
                                generatedText = "Error occurred. Please try again."
                            }
                        }
                    }
                }
                .padding()
            }
            // .ignoresSafeArea()
            .navigationTitle("Gemini flash")
        }
      
       
    }
}

#Preview {
    ContentView()
}
