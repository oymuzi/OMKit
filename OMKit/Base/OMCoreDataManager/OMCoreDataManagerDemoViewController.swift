//
//  OMCoreDataManagerDemoViewController.swift
//  OMKit
//
//  Created by oymuzi on 2019/2/20.
//  Copyright © 2019年 幸福的小木子. All rights reserved.
//

import UIKit


class OMProfile: NSObject, NSCoding {
    var name: String?
    var ctime: Int?
    
    override init() {
        super.init()
        self.name = ""
        self.ctime = 0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.ctime, forKey: "ctime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.ctime = aDecoder.decodeObject(forKey: "ctime") as? Int
    }
    
    override var description: String{
        return "name: \(name ?? "") ctime: \(ctime ?? 0)"
    }
}

class OMCoreDataManagerDemoViewController: UIViewController {

    deinit{
        print("I AM FREE BY RIGHT WAY！❤️")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       /** 简单创建*/
        let manager = OMCoreDataManager.init(databaseName: "OMCoreData")
        let obj:OMChargeType = manager.createObject(entityName: "OMChargeType")
        obj.ctime = 201314
        obj.icon = nil
        obj.name = "simple type"
        obj.type = 110
        manager.save { (isSuccess, error) in
            print("创建成功？：\(isSuccess), error：\(error ?? "")")
        }
        
        /** 附加自定义类profile*/
        let customeizeRecord: OMChargeRecord = manager.createObject(entityName: "OMChargeRecord")
        let profile = OMProfile.init()
        profile.ctime = 201314
        profile.name = "i love u"
        
        customeizeRecord.profile = profile
        customeizeRecord.amount = 34.33
        customeizeRecord.arc = true
        customeizeRecord.desc = "this is a customize record"
        customeizeRecord.isUpload = false
        customeizeRecord.time = 20190214
        customeizeRecord.type = 3
        manager.save { (isSuccess, error) in
            print("创建成功？：\(isSuccess), error：\(error ?? "")")
        }
        
        /** 查询*/
        var records = [OMChargeRecord]()
        manager.query(tableName: "OMChargeRecord", predicate: nil, sortDescriptor: nil, limit: 0) { (isSuccess, results, error) in
            let res: Array<OMChargeRecord> = results as! Array<OMChargeRecord>
            print("查询成功？:\(isSuccess), error: \(error ?? "")")
            for object in res{
                records.append(object)
            }
        }
        for object in records {
            print("ctime: \(object.time)  amount: \(object.amount)  desc: \(object.desc ?? "")  type: \(object.type) profile: \((object.profile as? OMProfile)?.description ?? "") isUpload: \(object.isUpload), arc: \(object.arc)")
        }
        
        /** 删除*/
        manager.query(tableName: "OMChargeType", predicate: nil, sortDescriptor: nil, limit: 0) { (isSuccess, results, error) in
            let res: Array<OMChargeType> = results as! Array<OMChargeType>
            print("删除成功？:\(isSuccess), error: \(error ?? "")")
            var types = [OMChargeType]()
            for object in res{
                types.append(object)
            }
            if !types.isEmpty{
                manager.deleteObject(object: types[0])
            }
        }
        
        /** 修改*/
        var fixRecords = [OMChargeRecord]()
        manager.query(tableName: "OMChargeRecord", predicate: nil, sortDescriptor: nil, limit: 0) { (isSuccess, results, error) in
            let res: Array<OMChargeRecord> = results as! Array<OMChargeRecord>
            print("修改成功？:\(isSuccess), error: \(error ?? "")")
            for object in res{
                fixRecords.append(object)
            }
            if !fixRecords.isEmpty {
                fixRecords[0].amount = 9999.99
            }
            manager.save(nil);
        }
    }
    

}
