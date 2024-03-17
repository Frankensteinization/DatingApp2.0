//
//  GroupListView.swift
//  DatingApp
//
//  Created by Frank on 3/13/24.
//

import SwiftUI

struct GroupListView: View {
    
    let groups: [Group]
    
    var body: some View {
        List(groups){ group in
            NavigationLink{
                GroupDetialView(group: group)
            }label: {
                HStack{
                    Image(systemName: "person.2")
                    Text(group.subject)
                }
            }
            
        }
    }
}

#Preview {
    GroupListView(groups: [])
}
