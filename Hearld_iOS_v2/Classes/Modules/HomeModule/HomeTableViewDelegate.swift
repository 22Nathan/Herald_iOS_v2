//
//  HomeTableViewDelegate.swift
//  Hearld_iOS_v2
//
//  Created by Nathan on 07/11/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath[1] == 1 {
            return 80
        }else {
            return 160
        }
        
    }
 
}

extension HomeViewController: CarouselFigureCellProtocol {
    func navigationPush(to vc: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
}
