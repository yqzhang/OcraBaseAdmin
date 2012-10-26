package com.ocrabaseadmin.operation;

import ict.ocrabase.main.java.client.webinterface.IndexAdmin;
import ict.ocrabase.main.java.client.webinterface.IndexConstants;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.hadoop.hbase.util.Bytes;

public class indexOperation {
	public List<HashMap<String,Object>> getTableIndex(HMaster master, String tableName) throws IOException {
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		if(admin.isIndexTable(Bytes.toBytes(tableName))) {
			List<HashMap<String,Object>> index = new LinkedList<HashMap<String,Object>>();
			for(Map.Entry<byte[], byte[]> entry : admin.getIndexes(Bytes.toBytes(tableName)).entrySet()) {
				HashMap<String,Object> hm = new HashMap<String,Object>();
				hm.put("columnFamily", Bytes.toString(entry.getKey()));
				hm.put("indexType", Bytes.toString(entry.getValue()));
				index.add(hm);
			}
			return index;
		}
		else {
			return null;
		}
	}

	public void addIndex(HMaster master, final String tableName,
			final List<HashMap<String, Object>> index) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		if(index.size() == 1) {
			for(HashMap<String, Object> hm : index) {
				if(((String)hm.get("indexType")).equals("CCIndex")) {
					try {
						byte[] indexColumn = KeyValue.makeColumn(Bytes.toBytes((String)hm.get("columnFamily")), Bytes.toBytes((String)hm.get("qualifier")));
						admin.addIndexAsync(Bytes.toBytes(tableName), indexColumn, IndexConstants.CCINDEX);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				else {
					try {
						byte[] indexColumn = KeyValue.makeColumn(Bytes.toBytes((String)hm.get("columnFamily")), Bytes.toBytes((String)hm.get("qualifier")));
						admin.addIndexAsync(Bytes.toBytes(tableName), indexColumn, IndexConstants.SECONDARYINDEX);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}
		else {
			TreeMap<byte[],byte[]> indexList = new TreeMap<byte[],byte[]>(Bytes.BYTES_COMPARATOR);
			
			for(HashMap<String, Object> hm : index) {
				if(((String)hm.get("indexType")).equals("CCIndex")) {
					indexList.put(KeyValue.makeColumn(Bytes.toBytes((String)hm.get("columnFamily")), Bytes.toBytes((String)hm.get("qualifier"))), IndexConstants.CCINDEX);
				}
				else {
					indexList.put(KeyValue.makeColumn(Bytes.toBytes((String)hm.get("columnFamily")), Bytes.toBytes((String)hm.get("qualifier"))), IndexConstants.SECONDARYINDEX);
				}
			}
			
			try {
				admin.addIndexesAsync(Bytes.toBytes(tableName), indexList);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void deleteIndex(HMaster master, final String tableName, final String columnName) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		try {
			admin.deleteIndexAsync(Bytes.toBytes(tableName), Bytes.toBytes(columnName));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
