//
//  LotteryPool.swift
//  Lottery
//
//  Created by 张俊安 on 2018/5/25.
//  Copyright © 2018年 Jon.Zhang. All rights reserved.
//

import Foundation

class LotteryViewModel {
    // 奖金
    private(set) var bonus = Bindable(Constant.initialBonus)
    // 往期中奖纪录
    private(set) var shotRecords: Bindable<[LotteryRecord]> = Bindable([])
    // time
    private(set) var time = Bindable(Constant.countDownTime)
    // 期号
    private var period = 0
    // 当前抽奖情况
    private var curBets = [LotteryBet]()
    // 常量
    private struct Constant {
        static let shotSecondNum = 10
        static let countDownTime = 10 // s 5 * 60
        static let oneCost: Double = 2
        static let initialBonus: Double = 100_0000
    }
    // lock
    private let lock = NSLock()

}

extension LotteryViewModel {
    // 下注
    @discardableResult
    func bet(_ RMB: Double) -> Set<LotteryBet> {
        var count = RMB / Constant.oneCost
        let lotteryId = getRandomLotteryId()
        var res = Set<LotteryBet>()
        lock.lock()
        while count != 0 && !res.contains(LotteryBet(period: period, lotteryId: lotteryId)) {
            let record = LotteryBet(period: period, lotteryId: lotteryId)
            res.insert(record)
            count -= 1
        }
        curBets.append(LotteryBet(period: period, lotteryId: lotteryId))
        bonus.value += RMB
        lock.unlock()
        return res
    }

    func start() {
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] (timer) in
            self.run()
        }
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }

    @discardableResult
    private func run() -> LotteryRecord? {
        if time.value == 0 { // 开奖时间

            let firstBet = shotFirstPrice()
            let shotSecond = shotSecondPrice()
            let record = LotteryRecord(period: period, first: firstBet, second: shotSecond, bets: curBets)
            shotRecords.value.append(record)

            bonus.value = bonus.value - (1 * 5000 + 10 * 500)

            time.value = Constant.countDownTime
            period += 1
            curBets.removeAll()

            return record
        } else {
            time.value -= 1
            return nil
        }
    }

}

extension LotteryViewModel {
    private func getRandomLotteryId() -> Int {
        return Int(arc4random_uniform(100_0000))
    }

    private func shotFirstPrice() -> LotteryBet {
        let i = Int(arc4random()) % curBets.count
        return curBets[i]
    }

    private func shotSecondPrice() -> Array<LotteryBet> {
        var res = Array<LotteryBet>()

        while res.count != Constant.shotSecondNum {
            let i = Int(arc4random()) % curBets.count
            let second = curBets[i]
            if !res.contains(second) {
                res.append(second)
            }
        }
        return res
    }
}





