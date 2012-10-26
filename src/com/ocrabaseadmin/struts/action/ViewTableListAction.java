/*
 * Generated by MyEclipse Struts
 * Template path: templates/java/JavaClass.vtl
 */
package com.ocrabaseadmin.struts.action;

import ict.ocrabase.main.java.client.webinterface.TaskManager;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.hadoop.hbase.HServerAddress;
import org.apache.hadoop.hbase.HRegionInfo;
import org.apache.hadoop.security.ACLField;

import com.ocrabaseadmin.operation.authorityOperation;
import com.ocrabaseadmin.operation.tableOperation;

/** 
 * MyEclipse Struts
 * Creation date: 08-13-2011
 * 
 * XDoclet definition:
 * @struts.action validate="true"
 * @struts.action-forward name="success" path="viewTableList.jsp"
 */
public class ViewTableListAction extends Action {
	/*
	 * Generated Methods
	 */

	/** 
	 * Method execute
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return ActionForward
	 */
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub
		HMaster master = (HMaster)getServlet().getServletContext().getAttribute(HMaster.MASTER);
		Configuration conf = master.getConfiguration();
		tableOperation to = new tableOperation();
		HTableDescriptor[] tables = null;
		List<String> tableList = new ArrayList<String>();
		
		authorityOperation ao = new authorityOperation();
		Map<byte[], ACLField> accessTables = null;
		
		Map<HRegionInfo, HServerAddress> regions = null;
		
		boolean security = conf.getBoolean("hbase.server.security",false);
		
		if(security) {
		
			String username = (String)request.getSession().getAttribute("username");
			String usertype = (String)request.getSession().getAttribute("usertype");
			
			try {
				if(usertype.equals("admin")) {
					tables = to.getAllTable(master);
					for(HTableDescriptor tableDesc: tables){
						HTable table = new HTable(conf, tableDesc.getNameAsString());
						regions = table.getRegionsInfo();
						int regionCount = regions.size();
						tableList.add(tableDesc.getNameAsString() + "," + regionCount + "," + TaskManager.isActive(tableDesc.getNameAsString()));
					}
				}
				else {
					accessTables = ao.getUserVisibleTable(master, username);
					tables = to.getAllTable(master);
					
					for(HTableDescriptor tableDesc: tables){
						for(Map.Entry<byte[], ACLField> entry : accessTables.entrySet()) {
							if(tableDesc.getNameAsString().equals(Bytes.toString(entry.getKey()))) {
								HTable table = new HTable(conf, tableDesc.getNameAsString());
								regions = table.getRegionsInfo();
								int regionCount = regions.size();
								tableList.add(tableDesc.getNameAsString() + "," + regionCount + "," + TaskManager.isActive(tableDesc.getNameAsString()));
							}
						}
					}
				}
			} catch (MasterNotRunningException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ZooKeeperConnectionException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else {
			try {
				tables = to.getAllTable(master);
				
				for(HTableDescriptor tableDesc: tables){
					HTable table = new HTable(conf, tableDesc.getNameAsString());
					regions = table.getRegionsInfo();
					int regionCount = regions.size();
					tableList.add(tableDesc.getNameAsString() + "," + regionCount + "," + TaskManager.isActive(tableDesc.getNameAsString()));
				}
			} catch (MasterNotRunningException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ZooKeeperConnectionException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
			
		request.setAttribute("tableList", tableList);
		
		return mapping.findForward("success");
	}
}