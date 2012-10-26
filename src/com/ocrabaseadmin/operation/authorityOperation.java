package com.ocrabaseadmin.operation;

import ict.ocrabase.main.java.client.webinterface.IndexAdmin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.security.ACLField;

public class authorityOperation {
	public void changeUserPassword(HMaster master, String username, String password) throws MasterNotRunningException, ZooKeeperConnectionException {
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		admin.modUserPasswdACL(Bytes.toBytes(username), Bytes.toBytes(password));
	}

	public void changeAdminPassword(HMaster master, String username,
			String newPassword) {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		
		conf.set("hbase.client.user", username);
		conf.set("hbase.client.passwd", newPassword);
	}

	public Map<byte[], ACLField> getAllTable(HMaster master) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		Map<byte[], ACLField> tables = admin.getTablePermissionMapACL();
		
		return tables;
	}

	public Map<byte[], ACLField> getUserTable(HMaster master, String username) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		Map<byte[], ACLField> tables = admin.getTablePermissionMapACL();
		
		Map<byte[], ACLField> userTables = new HashMap<byte[], ACLField>();
		
		for(Map.Entry<byte[], ACLField> entry : tables.entrySet()) {
			if(username.equals(Bytes.toString(entry.getValue().getUser()))) {
				userTables.put(entry.getKey(), entry.getValue());
			}
		}
		
		return userTables;
	}
	
	public Map<byte[], ACLField> getUserVisibleTable(HMaster master, String username) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		Map<byte[], ACLField> tables = admin.getTablePermissionMapACL();
		
		Map<byte[], ACLField> userTables = new HashMap<byte[], ACLField>();
		
		for(Map.Entry<byte[], ACLField> entry : tables.entrySet()) {
			if(this.validateUserOperation(master, Bytes.toString(entry.getKey()), this.getUserTypeForTable(master, username, Bytes.toString(entry.getKey())), false)) {
				userTables.put(entry.getKey(), entry.getValue());
			}
		}
		
		return userTables;
	}

	public Map<byte[], List<byte[]>> getAllUsers(HMaster master) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		return admin.getUserGroupMapACL();
	}

	public void changeAuthority(HMaster master, String tablename, String user, String group, String authority) throws IOException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		ACLField newACL = new ACLField(Integer.parseInt(authority),Bytes.toBytes(user),Bytes.toBytes(group));
		
		admin.modTablePermissionACL(Bytes.toBytes(tablename), newACL);
	}
	
	public void changeAuthority(HMaster master, String tablename, ACLField acl) throws IOException {
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		admin.modTablePermissionACL(Bytes.toBytes(tablename), acl);
	}

	public void addGroupToUser(HMaster master, String username, String group) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		admin.addUserGroupACL(Bytes.toBytes(username), Bytes.toBytes(group));
	}

	public void deleteGroupFromUser(HMaster master, String username,
			String group) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		System.out.println("Username:" + username);
		System.out.println("Group:" + group);
		
		admin.delUserGroupACL(Bytes.toBytes(username), Bytes.toBytes(group));
	}

	public boolean addUser(HMaster master, String username, String password) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		return admin.addUserToHbaseACL(Bytes.toBytes(username), Bytes.toBytes(password));
	}

	public boolean deleteUser(HMaster master, String username) throws MasterNotRunningException, ZooKeeperConnectionException {
		// TODO Auto-generated method stub
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		return admin.delUserFromHbaseACL(Bytes.toBytes(username));
	}
	
	public ACLField getTableACLField(HMaster master, String tableName) throws MasterNotRunningException, ZooKeeperConnectionException {
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		Map<byte[], ACLField> tables = admin.getTablePermissionMapACL();
		
		for(Map.Entry<byte[], ACLField> entry : tables.entrySet()) {
			if(tableName.equals(Bytes.toString(entry.getKey()))) {
				return entry.getValue();
			}
		}
		
		return null;
	}
	
	public List<byte[]> getUserGroup(HMaster master, String username) throws MasterNotRunningException, ZooKeeperConnectionException {
		Configuration conf = master.getConfiguration();
		IndexAdmin admin = new IndexAdmin(conf);
		
		Map<byte[],List<byte[]>> users = admin.getUserGroupMapACL();
		
		for(Map.Entry<byte[], List<byte[]>> entry : users.entrySet()) {
			if(username.equals(Bytes.toString(entry.getKey()))) {
				return entry.getValue();
			}
		}
		
		return null;
	}
	
	public boolean isInTableGroup(HMaster master, String username, String tableName) throws MasterNotRunningException, ZooKeeperConnectionException {
		List<byte[]> groups = this.getUserGroup(master, username);
		ACLField tableACLField = this.getTableACLField(master, tableName);
		
		for(byte[] b : groups) {
			if(b.equals(tableACLField.getGroup())) {
				return true;
			}
		}
		
		return false;
	}
	
	public int getUserTypeForTable(HMaster master, String username, String tableName) throws MasterNotRunningException, ZooKeeperConnectionException {
		
		int userType = 0;
		
		ACLField tableACLField = this.getTableACLField(master, tableName);
		
		if(username.equals(Bytes.toString(tableACLField.getUser()))) {
			userType = userType | 4;
			
			if(this.isInTableGroup(master, username, tableName)) {
				userType = userType | 2;
			}
		}
		else {
			if(this.isInTableGroup(master, username, tableName)) {
				userType = userType | 2;
			}
			else {
				userType = userType | 1;
			}
		}
		
		return userType;
	}
	
	public boolean validateUserOperation(HMaster master, String tableName, int userType, boolean ifWrite) throws MasterNotRunningException, ZooKeeperConnectionException {
		
		ACLField tableACLField = this.getTableACLField(master, tableName);
		
		boolean ifAccess = false;
		
		if((userType & 4) != 0) {
			if(!ifWrite) {
				ifAccess = (ifAccess | ((tableACLField.getMask() & 32) != 0));
			}
			else {
				ifAccess = (ifAccess | ((tableACLField.getMask() & 16) != 0));
			}
		}
		
		if((userType & 2) != 0) {
			if(!ifWrite) {
				ifAccess = (ifAccess | ((tableACLField.getMask() & 8) != 0));
			}
			else {
				ifAccess = (ifAccess | ((tableACLField.getMask() & 4) != 0));
			}
		}
		
		if((userType & 1) != 0) {
			if(!ifWrite) {
				ifAccess = (ifAccess | ((tableACLField.getMask() & 2) != 0));
			}
			else {
				ifAccess = (ifAccess | ((tableACLField.getMask() & 1) != 0));
			}
		}
		
		return ifAccess;
	}
}
