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
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ocrabaseadmin.operation.authorityOperation;
import com.ocrabaseadmin.operation.indexOperation;
import com.ocrabaseadmin.struts.form.EditIndexForm;

/** 
 * MyEclipse Struts
 * Creation date: 08-19-2011
 * 
 * XDoclet definition:
 * @struts.action path="/editIndex" name="editIndexForm" input="/editIndex.jsp" scope="request" validate="true"
 */
public class EditIndexAction extends Action {
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
		EditIndexForm editIndexForm = (EditIndexForm) form;// TODO Auto-generated method stub
		
		HMaster master = (HMaster)getServlet().getServletContext().getAttribute(HMaster.MASTER);
		String tableName = (String)editIndexForm.getNewTableName();
		
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
						out.println("window.location=\"/viewTableDetail.do?tableName=" + tableName + "&type=viewDescriptor\";");
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
		
		List<HashMap<String,Object>> index = new LinkedList<HashMap<String,Object>>();
		
		for(int i = 1; ;i++) {
			if(editIndexForm.getColumnFamily("columnFamily_" + i) == null) {
				break;
			}
			else {
				HashMap<String,Object> hm = new HashMap<String,Object>();
				hm.put("columnFamily", editIndexForm.getColumnFamily("columnFamily_" + i));
				hm.put("qualifier", editIndexForm.getQualifier("qualifier_" + i));
				hm.put("indexType", editIndexForm.getIndexType("indexType_" + i));
				
				index.add(hm);
			}
		}
		
		indexOperation ino = new indexOperation();
		
		try {
			ino.addIndex(master,tableName,index);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return mapping.findForward("success");
		
	}
}