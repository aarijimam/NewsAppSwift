//
//  SettingsView.swift
//  NewsAPI
//
//  Created by Tunde on 17/02/2021.
//

import SwiftUI
import UIKit


struct SettingsView: View {
    
    @Binding var darkModeEnabled: Bool
    @Binding var systemThemeEnabled: Bool
    
    let themeManager: ThemeManager
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Display"),
                        footer: Text("System settings will override Dark Mode and use the current device theme")) {
                    Toggle(isOn: $darkModeEnabled,
                           label: {
                        Text("Dark mode")
                    })
                    .onChange(of: darkModeEnabled)
                    {
                        themeManager.handleTheme(darkMode: darkModeEnabled,
                                                 system: systemThemeEnabled)
                        
                    }
                    Toggle(isOn: $systemThemeEnabled,
                           label: {
                        Text("Use system settings")
                    })
                    .onChange(of: systemThemeEnabled)
                    {
                        themeManager.handleTheme(darkMode: darkModeEnabled,
                                                 system: systemThemeEnabled)
                        
                    }
                }
                
                Section(footer: Text("Made by Nawab Aarij Imam, Muhammad Ali, Abdullah Ihsan")){
                                    Link(destination: URL(string: "https://github.com/aarijimam")!, label: {
                                        Label("Follow me on github @aarijimam",
                                              systemImage: "link").font(.system(size:16,weight: .bold))
                                            .foregroundColor(Theme.textColor)
                                    })
                                    Label("DB Project",systemImage: "externaldrive.fill").font(.system(size:16,weight: .bold))
                        .foregroundColor(Theme.textColor)
                                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(darkModeEnabled: .constant(false),
                     systemThemeEnabled: .constant(false),
                     themeManager: ThemeManager())
    }
}

class ThemeManager {
    
    func handleTheme(darkMode: Bool, system: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            
            guard !system else {
                UIApplication.keyWindow?.overrideUserInterfaceStyle = .unspecified
                return
            }
            
            UIApplication.keyWindow?.overrideUserInterfaceStyle = darkMode ? .dark : .light
        }
    }
}


extension UIApplication {
    
    static var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
