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
import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ocrabaseadmin.operation.authorityOperation;
import com.ocrabaseadmin.operation.dataOperation;
import com.ocrabaseadmin.operation.indexOperation;
import com.ocrabaseadmin.operation.tableOperation;

/** 
 * MyEclipse Struts
 * Creation date: 08-13-2011
 * 
 * XDoclet definition:
 * @struts.action validate="true"
 * @struts.action-forward name="success" path="/viewTableDetail.jsp"
 */
public class ViewTableDetailAction extends Action {
	/*
	 * Generated Methods
	 */

	private final int RECORD_PER_PAGE = 30;
	
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
		String tableName = (String)request.getParameter("tableName");
		String type = (String)request.getParameter("type");
		
		HMaster master = (HMaster)getServlet().getServletContext().getAttribute(HMaster.MASTER);
		
		request.setAttribute("tableName", tableName);
		
		if(TaskManager.isActive(tableName)) {
			return mapping.findForward("notActive");
		}
		
		if(type.equals("viewDescriptor")) {
			//authority
			Configuration conf = master.getConfiguration();
			boolean security = conf.getBoolean("hbase.server.security",false);
			if(security) {

				String username = (String)request.getSession().getAttribute("username");
				String usertype = (String)request.getSession().getAttribute("usertype");
				
				if(usertype.equals("user")) {
					authorityOperation ao = new authorityOperation();
					try {
						if(!ao.validateUserOperation(master, tableName, ao.getUserTypeForTable(master, username, tableName), false)) {
							PrintWriter out = response.getWriter();
							out.println("<script>");
							out.println("alert(\"You Have No Access.\");");
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
			tableOperation to = new tableOperation();
			try {
				HTableDescriptor tableDesc = to.getTableDescriptor(master,tableName);
				List<HashMap<String,Object>> columnFamily = new LinkedList<HashMap<String,Object>>();
				HColumnDescriptor[] columnDescs = tableDesc.getColumnFamilies();
				
				for(HColumnDescriptor columnDesc : columnDescs) {
					HashMap<String,Object> hm = new HashMap<String,Object>();
					
					hm.put("familyName", columnDesc.getNameAsString());
					hm.put("versions", columnDesc.getMaxVersions());
					hm.put("compression", columnDesc.getCompressionType().toString());
					//hm.put("blockSize", columnDesc.getBlocksize());
					hm.put("ttl", columnDesc.getTimeToLive());
					hm.put("bloomFilter", columnDesc.getBloomFilterType().toString());
					
					columnFamily.add(hm);
				}
				
				request.setAttribute("tableDescriptor", columnFamily);
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			indexOperation ino = new indexOperation();
			List<HashMap<String,Object>> indexDescriptor = null;
			try {
				indexDescriptor = ino.getTableIndex(master, tableName);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			request.setAttribute("indexDescriptor", indexDescriptor);
			
			return mapping.findForward("viewDescriptor");
		}
		else if(type.equals("browseTable")) {
			//authority
			Configuration conf = master.getConfiguration();
			boolean security = conf.getBoolean("hbase.server.security",false);
			if(security) {

				String username = (String)request.getSession().getAttribute("username");
				String usertype = (String)request.getSession().getAttribute("usertype");
				
				if(usertype.equals("user")) {
					authorityOperation ao = new authorityOperation();
					try {
						if(!ao.validateUserOperation(master, tableName, ao.getUserTypeForTable(master, username, tableName), false)) {
							PrintWriter out = response.getWriter();
							out.println("<script>");
							out.println("alert(\"You Have No Access.\");");
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
			tableOperation to = new tableOperation();
			List<String> headers = new LinkedList<String>();
			HColumnDescriptor[] columnDescs = null;
			
			try {
				HTableDescriptor tableDesc = to.getTableDescriptor(master, tableName);
				columnDescs = tableDesc.getColumnFamilies();
				
				for(HColumnDescriptor columnDesc : columnDescs) {
					headers.add(columnDesc.getNameAsString());
				}
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			boolean ifNewOperation = false;
			
			dataOperation dao = (dataOperation)request.getSession().getAttribute("dataOperation");
			
			if(dao == null || request.getParameter("nextPage") == null) {
				dao = new dataOperation();
				ifNewOperation = true;
			}
			
			List<HashMap<String,List<String>>> records = new LinkedList<HashMap<String,List<String>>>();
			List<String> rowKey = new LinkedList<String>();
			
			try {
				Result[] r = null;
				
				if(ifNewOperation == true) {
					r = dao.getData(master, tableName, this.RECORD_PER_PAGE);
				}
				else {
					r = dao.getData(this.RECORD_PER_PAGE);
					
					request.setAttribute("nextPage", "true");
				}
				
				for(int i = 0;i < this.RECORD_PER_PAGE && r[i] != null;i++) {
					rowKey.add(new String(r[i].getRow()));
					
					HashMap<String,List<String>> hm = new HashMap<String,List<String>>();
					
					for(KeyValue kv : r[i].raw()) {
						
						for(HColumnDescriptor columnDesc : columnDescs) {
							if(kv.matchingFamily(columnDesc.getName())) {
								if(hm.get(columnDesc.getNameAsString()) == null) {
									List<String> s = new LinkedList<String>();
									
									s.add(new String(kv.getQualifier()) + "=" + new String(kv.getValue()));
									hm.put(columnDesc.getNameAsString(), s);
								}
								else {
									((List<String>)hm.get(columnDesc.getNameAsString())).add(new String(kv.getQualifier()) + "=" + new String(kv.getValue()));
								}
								break;
							}
						}
					}
					
					records.add(hm);
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			request.setAttribute("rowKey", rowKey);
			request.setAttribute("headers", headers);
			request.setAttribute("records", records);
			
			request.setAttribute("dataOperation", dao);
			
			return mapping.findForward("browseTable");
		}
		else if(type.equals("insertData")) {
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
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
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
			
			return mapping.findForward("insertData");
		}
		else if(type.equals("importData")){
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
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
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
			
			return mapping.findForward("importData");
		}
		else if(type.equals("queryData")){
			//authority
			Configuration conf = master.getConfiguration();
			boolean security = conf.getBoolean("hbase.server.security",false);
			if(security) {

				String username = (String)request.getSession().getAttribute("username");
				String usertype = (String)request.getSession().getAttribute("usertype");
				
				if(usertype.equals("user")) {
					authorityOperation ao = new authorityOperation();
					try {
						if(!ao.validateUserOperation(master, tableName, ao.getUserTypeForTable(master, username, tableName), false)) {
							PrintWriter out = response.getWriter();
							out.println("<script>");
							out.println("alert(\"You Have No Access.\");");
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
			request.setAttribute("tableName", tableName);
			
			return mapping.findForward("queryData");
		}
		else if(type.equals("emptyTable")) {
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
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
			dataOperation dao = new dataOperation();
			
			try {
				dao.emptyTable(master,tableName);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				request.setAttribute("emptyTableError", e);
			}
			
			request.setAttribute("tableName", tableName);
			
			return mapping.findForward("emptyTable");
		}
		else {
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
							out.println("window.location=\"/viewTableList.do\";");
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
			//authority
			
			tableOperation to = new tableOperation();
			
			try {
				to.dropTable(master,tableName);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				request.setAttribute("dropTableError", e);
			}
			
			return mapping.findForward("dropTable");
		}
	}
}