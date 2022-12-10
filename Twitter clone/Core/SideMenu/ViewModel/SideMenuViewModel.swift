//
//  SideMenuViewModel.swift
//  Twitter clone
//
//  Created by lahiru on 2022-12-02.
//

import Foundation

enum SideMenuViewModel: Int, CaseIterable{
    case profile
    case lists
    case bookmars
    case logout
    
    var title: String{
        switch self{
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .bookmars: return "Bookmarks"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String{
        switch self{
        case .profile: return "person"
        case .lists: return "list.bullet"
        case .bookmars: return "bookmark"
        case .logout: return "arrow.left.square"
        }
    }
}
