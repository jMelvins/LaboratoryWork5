//
//  Func.swift
//  [laba 5] ios
//
//  Created by Vladislav Shilov on 05.06.17.
//  Copyright © 2017 Vladislav Shilov. All rights reserved.
//

import Foundation

func quicksort<T: Comparable>(_ a: [T]) -> [T] {
    
    guard a.count > 1 else { return a }
    
    let pivot = a[a.count/2]
    let less = a.filter { $0 < pivot }
    let equal = a.filter { $0 == pivot }
    let greater = a.filter { $0 > pivot }
    
    // Uncomment this following line to see in detail what the
    // pivot is in each step and how the subarrays are partitioned.
    //print(pivot, less, equal, greater)  return quicksort(less) + equal + quicksort(greater)
    return quicksort(less) + equal + quicksort(greater)
    
}
