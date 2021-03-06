/*
 * Generated by MyEclipse Struts
 * Template path: templates/java/JavaClass.vtl
 */
package com.ocrabaseadmin.struts.action;

import ict.ocrabase.main.java.client.webinterface.TaskManager;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ocrabaseadmin.operation.authorityOperation;
import com.ocrabaseadmin.operation.dataOperation;
import com.ocrabaseadmin.operation.tableOperation;
import com.ocrabaseadmin.struts.form.InsertDataForm;

/** 
 * MyEclipse Struts
 * Creation date: 08-17-2011
 * 
 * XDoclet definition:
 * @struts.action path="/insertData" name="insertDataForm" input="/insertData.jsp" scope="request" validate="true"
 * @struts.action-forward name="fail" path="/insertData.jsp"
 * @struts.action-forward name="success" path="/insertData.jsp"
 */
public class InsertDataAction extends Action {
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
		InsertDataForm insertDataForm = (InsertDataForm) form;// TODO Auto-generated method stub
		
		HMaster master = (HMaster)getServlet().getServletContext().getAttribute(HMaster.MASTER);
		String tableName = insertDataForm.getTableName();
		String rowKey = insertDataForm.getRowKey();
		
		//authority
		Configuration conf = master.getConfiguration();
		boolean security = conf.getBoolean("hbase.server.security",false);
		if(security) {
			String username = (String)request.getSession().getAttribute("username");
			String usertype = (String)request.getSession().getAttribute("usertype");
			
			if(usertype.equals("user")) {
				authorityOperation ao = new authorityOperation();
				try {
					if(!ao.validateUserOperation(master, tableName, ao.getUserTypeForTable(master, username, tableName), true)) {
						PrintWriter out = response.getWriter();
						out.println("<script>");
						out.println("alert(\"You Have No Access.\");");
						out.println("window.location=\"/viewTableDetail.do?tableName=" + tableName + "&type=insertData\";");
						out.println("</script>");
						
						return null;
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
		}
		
		if(TaskManager.isActive(tableName)) {
			PrintWriter out;
			try {
				out = response.getWriter();
				
				out.println("<script>");
				out.println("alert(\"The Table is Locked.\");");
				out.println("window.location=\"/viewTableList.do\";");
				out.println("</script>");
				
				return null;
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		//authority
		
		dataOperation dao = new dataOperation();
		
		List<HashMap<String,Object>> rows = new LinkedList<HashMap<String,Object>>();
		
		for(int i = 1; ;i++) {
			if(insertDataForm.getFamilyName("familyName_" + i) == null) {
				break;
			}
			else {
				HashMap<String,Object> hm = new HashMap<String,Object>();
				hm.put("familyName", insertDataForm.getFamilyName("familyName_" + i));
				hm.put("qualifier", insertDataForm.getQualifier("qualifier_" + i));
				hm.put("values", insertDataForm.getValues("values_" + i));
				
				rows.add(hm);
			}
		}
		
		try {
			dao.insertData(master, tableName, rowKey, rows);
			request.setAttribute("err", "Insert Data Successfully.");
			
			tableOperation to = new tableOperation();
			try {
				HTableDescriptor tableDesc = to.getTableDescriptor(master,tableName);
				List<String> columnFamily = new LinkedList<String>();
				HColumnDescriptor[] columnDescs = tableDesc.getColumnFamilies();
				
				for(HColumnDescriptor columnDesc : columnDescs) {
					columnFamily.add(columnDesc.getNameAsString());
				}
				
				request.setAttribute("columnFamily", columnFamily);
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			request.setAttribute("tableName", tableName);
			
			return mapping.findForward("success");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			request.setAttribute("err", e);
			
			tableOperation to = new tableOperation();
			try {
				HTableDescriptor tableDesc = to.getTableDescriptor(master,tableName);
				List<String> columnFamily = new LinkedList<String>();
				HColumnDescriptor[] columnDescs = tableDesc.getColumnFamilies();
				
				for(HColumnDescriptor columnDesc : columnDescs) {
					columnFamily.add(columnDesc.getNameAsString());
				}
				
				request.setAttribute("columnFamily", columnFamily);
				
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			request.setAttribute("tableName", tableName);
			
			return mapping.findForward("fail");
		}
	}
}