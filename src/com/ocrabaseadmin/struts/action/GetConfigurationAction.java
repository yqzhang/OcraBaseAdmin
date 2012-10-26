/*
 * Generated by MyEclipse Struts
 * Template path: templates/java/JavaClass.vtl
 */
package com.ocrabaseadmin.struts.action;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.util.FSUtils;
import org.apache.hadoop.hbase.master.HMaster;

/** 
 * MyEclipse Struts
 * Creation date: 08-12-2011
 * 
 * XDoclet definition:
 * @struts.action validate="true"
 * @struts.action-forward name="success" path="/home.jsp"
 */
public class GetConfigurationAction extends Action {
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
		int interval = conf.getInt("hbase.regionserver.msginterval", 1000)/1000;
		if (interval == 0) {
			interval = 1;
		}
		boolean showFragmentation = conf.getBoolean("hbase.master.ui.fragmentation.enabled", false);
		Map<String, Integer> frags = null;
		if (showFragmentation) {
			try {
				frags = FSUtils.getTableFragmentation(master);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		request.setAttribute("master", master);
		request.setAttribute("showFragmentation", showFragmentation);
		request.setAttribute("frags", frags);
		
		return mapping.findForward("success");
	}
}