//
//  File.swift
//  
//
//  Created by Abishek Robin on 14/10/23.
//

import Foundation

import SwiftUI

// MARK: - View Extensions
public extension View{
    /** align view on screen [horizontal, vertical]
      - Parameter alignment: view alignment
      */
     func alignView(_ alignment: Alignment) -> some View{
         self
             .alignHorizontally(alignment.horizontal)
             .alignVertically(alignment.vertical)
     }
     /** aligns view in horizontal orientation
      - Parameter alignment: view alignment horizontally
      */
     func alignHorizontally(_ alignment: HorizontalAlignment) -> some View{
         HStack(spacing: 0){
             if alignment != .leading{
                 Spacer()
             }
             self
             if alignment != .trailing{
                 Spacer()
             }
         }
         
     }
     /** aligns view in vertical orientation
      - Parameter alignment: view alignment vertically
      */
     func alignVertically(_ alignment: VerticalAlignment) -> some View{
         VStack(spacing: 0){
             if ![VerticalAlignment.top, .firstTextBaseline].contains(alignment){
                 Spacer()
             }
             self
             if ![VerticalAlignment.bottom, .lastTextBaseline].contains(alignment){
                 Spacer()
             }
         }
     }
}


//MARK: - Shimmering
extension View{
    @ViewBuilder
    func shimmeringList<ShimmeringView: View>(effectOn shimmering : Bool, shimmeringView: () ->  ShimmeringView) -> some View {
        if shimmering{
            shimmeringView()
        }else{
            self
        }
    }

}
