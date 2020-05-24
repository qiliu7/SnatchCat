//
//  DispatchToMain.swift
//  SnatchCat
//
//  Created by Kappa on 2020-05-24.
//  Copyright © 2020 qi. All rights reserved.
//

import Foundation

func dispatchToMain(_ task: @escaping () -> Void) {
  DispatchQueue.main.async {
    task()
  }
}
