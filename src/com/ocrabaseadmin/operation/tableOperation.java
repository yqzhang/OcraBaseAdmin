package com.ocrabaseadmin.operation;

import ict.ocrabase.main.java.client.webinterface.IndexAdmin;
import ict.ocrabase.main.java.client.webinterface.TaskManager;
import ict.ocrabase.main.java.client.webinterface.TaskNotExistException;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.io.hfile.Compression;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.hadoop.hbase.regionserver.StoreFile;
import org.apache.hadoop.hbase.util.Bytes;

public class tableOperation {
	public tableOperation() {
		
	}
	
	public HTableDescriptor[] getAllTable(HMaster master) throws MasterNotRunningException, ZooKeeperConnectionException, IOException {
		Configuration conf = master.getConfiguration();
		HTableDescriptor[] tables = new IndexAdmin(conf).listTables();
		return tables;
	}

	public int createTable(HMaster master,
			String tableName,
			List<HashMap<String, Object>> columnFamily) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		if(admin.tableExists(Bytes.toBytes(tableName))) {
			return 1;
		}
		else {
			HTableDescriptor tableDesc = new HTableDescriptor(tableName);
			
			for(HashMap<String, Object> hm : columnFamily) {
				HColumnDescriptor columnDesc = new HColumnDescriptor((String)hm.get("familyName"));
				columnDesc.setMaxVersions(Integer.parseInt((String)hm.get("versions")));
				columnDesc.setCompressionType(Enum.valueOf(Compression.Algorithm.class, (String)hm.get("compression")));
				columnDesc.setInMemory((hm.get("inMemory") == null) ? false : true);
				columnDesc.setBlockCacheEnabled((hm.get("blockCache") == null) ? false : true);
				columnDesc.setTimeToLive(Integer.parseInt((String)hm.get("ttl")));
				columnDesc.setBloomFilterType(Enum.valueOf(StoreFile.BloomType.class, (String)hm.get("bloomFilter")));
				
				tableDesc.addFamily(columnDesc);
			}
			
			admin.createTable(tableDesc);
		}
		
		return 0;
	}

	public HTableDescriptor getTableDescriptor(HMaster master, String tableName) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		return admin.getTableDescriptor(tableName.getBytes());
	}

	public void dropTable(HMaster master, final String tableName) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		final IndexAdmin admin = new IndexAdmin(conf);
		
		Thread t = new Thread() {
			public void run() {
				try {
					if(admin.tableExists(Bytes.toBytes(tableName))){
						//String taskID = admin.disableIndexTable(Bytes.toBytes(tableName));
						String taskID = admin.disableTableAsync(Bytes.toBytes(tableName));
						
						while(TaskManager.isTaskFinished(taskID) == false){
							Thread.sleep(50);
						}
						
						//admin.deleteIndexTable(Bytes.toBytes(tableName));
						admin.deleteTableAsync(Bytes.toBytes(tableName));
					}
				} catch (TaskNotExistException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		};
		
		t.start();
	}

	public void addColumnFamily(HMaster master, String tableName,
			List<HashMap<String, Object>> columnFamily) throws IOException {
		// TODO Auto-generated method stub
		
		Configuration conf = master.getConfiguration();
		
		IndexAdmin admin = new IndexAdmin(conf);
		
		admin.disableTable(Bytes.toBytes(tableName));
		
		for(HashMap<String,Object> hm : columnFamily) {
			HColumnDescriptor columnDesc = new HColumnDescriptor((String)hm.get("familyName"));
			
			columnDesc.setMaxVersions(Integer.parseInt((String)hm.get("versions")));
			columnDesc.setCompressionType(Enum.valueOf(Compression.Algorithm.class, (String)hm.get("compression")));
			columnDesc.setInMemory((hm.get("inMemory") == null) ? false : true);
			columnDesc.setBlockCacheEnabled((hm.get("blockCache") == null) ? false : true);
			columnDesc.setTimeToLive(Integer.parseInt((String)hm.get("ttl")));
			columnDesc.setBloomFilterType(Enum.valueOf(StoreFile.BloomType.class, (String)hm.get("bloomFilter")));
			
			admin.addColumn(Bytes.toBytes(tableName), columnDesc);
		}
		
		admin.enableTable(Bytes.toBytes(tableName));
	}

	public void deleteFamily(HMaster master, String tableName, String familyName) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		
		IndexAdmin admin = new IndexAdmin(conf);
		
		admin.disableTable(Bytes.toBytes(tableName));
		
		admin.deleteColumn(Bytes.toBytes(tableName), Bytes.toBytes(familyName));
		
		admin.enableTable(Bytes.toBytes(tableName));
	}
}
