package com.ocrabaseadmin.operation;

import ict.ocrabase.main.java.client.ccindex.sqlquery.SQLQuery;
import ict.ocrabase.main.java.client.webinterface.IndexAdmin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.hadoop.conf.Configuration;

import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.client.Delete;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.client.ccindex.ResultReader;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.hadoop.hbase.util.Bytes;

public class dataOperation {
	
	private boolean isFinished = false;
	private ResultScanner localRS = null;
	private ArrayList<String> queryResult = null;
	
	public void emptyTable(HMaster master, String tableName) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		
		HTable table = new HTable(conf, tableName);
		Scan s = new Scan();
		ResultScanner rs = table.getScanner(s);
		for(Result r : rs) {
			Delete delete = new Delete(r.getRow());
			table.delete(delete);
		}
		table.flushCommits();
	}
	
	public Result[] getData(HMaster master, String tableName, int nbRows) throws IOException {
		Configuration conf = master.getConfiguration();
		
		HTable table = new HTable(conf, tableName);
		Scan s = new Scan();
		localRS = table.getScanner(s);
		
		Result[] r = new Result[nbRows];
		
		Result tempR = null;
		
		for(int i = 0;i < nbRows;i++) {
			tempR = localRS.next();
			
			if(tempR == null) {
				break;
			}
			else {
				r[i] = tempR;
			}
		}
		
		return r;
	}
	
	public Result[] getData(int nbRows) throws IOException {
		Result[] r = new Result[nbRows];
		
		Result tempR = null;
		
		for(int i = 0;i < nbRows;i++) {
			tempR = localRS.next();
			
			if(tempR == null) {
				break;
			}
			else {
				r[i] = tempR;
			}
		}
		
		return r;
	}

	public void insertData(HMaster master, String tableName, String rowKey,
			List<HashMap<String, Object>> rows) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		
		HTable table = new HTable(conf, tableName);
		Put put = new Put(Bytes.toBytes(rowKey));
		
		for(HashMap<String,Object> hm : rows) {
			put.add(Bytes.toBytes((String)hm.get("familyName")), Bytes.toBytes((String)hm.get("qualifier")), Bytes.toBytes((String)hm.get("values")));
		}
		
		table.put(put);
		table.flushCommits();
	}

	public void deleteData(HMaster master, String tableName, String rowKey) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		HTable table = new HTable(conf, tableName);
		Get get = new Get(Bytes.toBytes(rowKey));
		
		Delete delete = new Delete(table.get(get).getRow());
		table.delete(delete);
		table.flushCommits();
	}
	
	public void setIsFinished(boolean finish) {
		isFinished = finish;
	}
	
	public boolean getIsFinished() {
		return isFinished;
	}
	
	public int getResultSize() {
		return queryResult.size();
	}
	
	public void createQuery(String query) throws IOException {
		setIsFinished(false);
		
		queryResult = new ArrayList<String>();
		
		SQLQuery sqlQuery = new SQLQuery(query);
		sqlQuery.initQuery();
		sqlQuery.startQuery();
		
		ArrayList<String>result = null;
		
		while((result = sqlQuery.next(1)) != null) {
			queryResult.add(result.get(0));
		}
		
		setIsFinished(true);
	}
	
	public ArrayList<String> getQueryResult(int start, int end) {
		if(getIsFinished() == false) {
			return null;
		}
		else {
			ArrayList<String> ret = new ArrayList<String>();
			
			if(start > queryResult.size()) {
				start = 0;
			}
			
			if(end >= queryResult.size()) {
				end = queryResult.size() - 1;
			}
			
			for(int i = start;i <= end;i++) {
				ret.add(queryResult.get(i));
			}
			
			return ret;
		}
	}

	public void queryData(HMaster master, String query) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		setIsFinished(false);
		
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		ResultReader queryResult = admin.sqlQuery(query);
		this.queryResult = new ArrayList<String>();
		
		Result result = null;
		String line = null;
		
		while((result = queryResult.next()) != null) {
			line = "key=" + Bytes.toString(result.getRow());
			List<KeyValue> list = result.list();
			for(KeyValue kv : list){
				line += ","+ Bytes.toString(kv.getFamily())+ ":"+ Bytes.toString(kv.getQualifier())+ "="
						+ Bytes.toString(kv.getValue());
			}
			this.queryResult.add(line);
		}
		
		setIsFinished(true);
	}
}
