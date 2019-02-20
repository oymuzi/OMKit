//
//  OMCoreDataManager.swift
//  OMCoreData
//
//  Created by oymuzi on 2019/1/25.
//  Copyright © 2019年 oymuzi. All rights reserved.
//

import UIKit
import CoreData

/** 数据库存放配置*/
struct OMCoreDataManagerConfiguration {
    /** 存放数据库文件在本地的文件名*/
    public var dataFileName = "data"
    /** 默认存储的数据库文件将存在 ~/Documents/data/ 目录下, 可以更改此此目录，也可以是多级目录*/
    public var dataFileDirectory = "/data/"
}

/** 数据库操作完成回调*/
typealias OMCoreDataManagerCompeltion = (_ isSuccess: Bool, _ error: String?) -> Void

/** 数据库查询回调*/
typealias OMCoreDataManagerQueryCompletion<T> = (_ isSuccess: Bool, _ results: [T], _ error: String?) -> Void

/** 数据库管理者*/
class OMCoreDataManager: NSObject {
    
    /** 数据库的名字，由用户在创建工程的时候勾选了 use CoreData 则设置为你的工程名，不然则设置你自定义的数据库文件名*/
    private var databaseName = "OMCoreDataManager"
    
    /** 数据库的配置*/
    public var configuration: OMCoreDataManagerConfiguration = OMCoreDataManagerConfiguration()
    
    /** 私有-操作数据库的上下文*/
    private var _context: NSManagedObjectContext? = nil
    
    /** 操作数据库的上下文*/
    public var context: NSManagedObjectContext?{
        return _context
    }
    
    /** 私有化无参init方法*/
    private override init() {
        super.init()
    }
    
    /** 以数据库名创建数据库管理者, 数据库名即为为： *.xcdatamodeld 结尾的文件名 */
    public convenience init(databaseName: String){
        self.init()
        self.databaseName = databaseName
        self.initConfiuration()
        assert(self.context != nil, "OMCoreDataManager-初始化上下文失败")
    }
    
    /** 以数据库名和配置创建数据库管理者， 数据库名即为为： *.xcdatamodeld 结尾的文件名*/
    public convenience init(databaseName: String, configuration: OMCoreDataManagerConfiguration){
        self.init()
        self.databaseName = databaseName
        self.configuration = configuration
        assert(self.context != nil, "OMCoreDataManager-初始化上下文失败")
    }
    
    /** 配置数据库*/
    private func initConfiuration(){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        guard paths.count > 0 else {
            print("OMCoreDataManager-未能找到系统文件列表")
            return
        }
        let documentDir = paths[0]
        /** 数据存储位置*/
        let sqlExtensionPath = ".sqlite"
        let storeDirectory = documentDir+configuration.dataFileDirectory
        /** 创建指定的存放数据的文件*/
        do{
          try FileManager.default.createDirectory(atPath: storeDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch{
            print("OMCoreDataManager-未能创建数据存放文件夹- \(storeDirectory)")
            return
        }
        let storeURL = URL.init(fileURLWithPath: storeDirectory+configuration.dataFileName+sqlExtensionPath)
        print(storeURL.absoluteString)
        
        /** 数据迁移*/
        let options = [NSMigratePersistentStoresAutomaticallyOption : NSNumber(value: true),NSInferMappingModelAutomaticallyOption : NSNumber(value: true)]

        guard let modelURL = Bundle.main.url(forResource: databaseName, withExtension: "momd") else {
            print("OMCoreDataManager-未能找到 \(databaseName) 数据库文件")
            return
        }
        guard let manageObjectModel = NSManagedObjectModel.init(contentsOf: modelURL) else {
            print("OMCoreDataManager-创建托管对象失败")
            return
        }
        /** 创建数据库存储协调器，并使用SQL持久化保存*/
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: manageObjectModel)
        do{
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch{
            print("OMCoreDataManager-使用持久化存储失败")
        }
        
        let manageContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        manageContext.persistentStoreCoordinator = persistentStoreCoordinator
        self._context = manageContext
    }
    
    /// 创建一个指定表名为 entityName 数据托管模型，可用来增加、更新、删除操作
    ///
    /// - Parameter entityName: 表名
    /// - Returns: 数据托管对象
    public func createObject<T: NSManagedObject>(entityName: String) -> T{
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context!) as! T
        return entity
    }
    
    /// 删除指定的记录
    ///
    /// - Parameter object: 记录
    public func deleteObject<T: NSManagedObject>(object: T){
        self.context?.delete(object)
    }
    
    /// 查询数据
    ///
    /// - Parameters:
    ///   - entityName: 表名
    ///   - predicate: 查询条件
    ///   - sortDescriptor: 排序规则
    ///   - limit: 抓取数目限制
    ///   - completion: 回调
    public func query<T: NSManagedObject>(tableName: String, predicate: NSPredicate?, sortDescriptor: [NSSortDescriptor]?, limit: Int, completion: OMCoreDataManagerQueryCompletion<T>?){
        let request = NSFetchRequest<T>.init(entityName: tableName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptor
        request.fetchLimit = limit
        do{
            let results = try self.context!.fetch(request)
            var tempResults = [T]()
            for result in results{
                tempResults.append(result)
            }
            completion?(true, tempResults, nil)
        } catch{
            completion?(false, [], error.localizedDescription)
        }
    }
    
    /// 删除指定表名所有数据
    ///
    /// - Parameter tableName: 表名
    public func deleteAllObjects(tableName: String){
        self.query(tableName: tableName, predicate: nil, sortDescriptor: nil, limit: 0) { (isSuccess, results, error) in
            guard isSuccess else {
                return
            }
            for object in results {
                self.context?.delete(object)
            }
        }
        
    }
    
    
    /// 新增数据或保存修改
    ///
    /// - Parameter completion: 回调
    public func save(_ completion: OMCoreDataManagerCompeltion?) {
        do{
            try self.context?.save()
            completion?(true, nil)
        } catch{
            completion?(false, error.localizedDescription)
        }
    }

}
