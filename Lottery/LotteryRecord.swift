//
//  LotteryRecord.swift
//  Lottery
//
//  Created by 张俊安 on 2018/6/5.
//  Copyright © 2018年 Jon.Zhang. All rights reserved.
//

import Foundation

/// 每期中奖纪录
struct LotteryRecord {
    let period: Int
    let first: LotteryBet
    let second: Array<LotteryBet>
    let bets: [LotteryBet]
}

/// 每注彩票信息
struct LotteryBet: CustomStringConvertible {
    let period: Int
    let lotteryId: Int

    var description: String {
        return "\(lotteryId)"
    }
}

extension LotteryBet: Hashable {
    static func ==(lhs: LotteryBet, rhs: LotteryBet) -> Bool {
        return lhs.period == rhs.period && lhs.lotteryId == rhs.lotteryId
    }

    var hashValue: Int {
        return period ^ lotteryId
    }
}
