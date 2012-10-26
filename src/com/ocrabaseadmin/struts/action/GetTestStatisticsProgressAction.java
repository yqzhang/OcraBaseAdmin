/*
 * Generated by MyEclipse Struts
 * Template path: templates/java/JavaClass.vtl
 */
package com.ocrabaseadmin.struts.action;

import ict.ocrabase.main.java.regionserver.statclient.SQLStatus;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 08-25-2011
 * 
 * XDoclet definition:
 * @struts.action validate="true"
 */
public class GetTestStatisticsProgressAction extends Action {
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
		
		Object queryobj = request.getSession().getAttribute("QUERYTD");
		
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if(queryobj == null) {
			out.println("<script>");
		  	out.println("alert('No SQL Running.');");
		  	out.println("</script>");
		}
		else {
			SQLStatus querytd=(SQLStatus)queryobj;
			float rate = querytd.getRate();
			
			System.out.println("ret fload:" + rate);
			System.out.println("If Finished:" + querytd.isIsfinished());
			
			int ret = (int) (rate * 100);
			
			out.println(ret);
			
			System.out.println("ret:" + ret);
			  	
			return null;
		}
		
		return null;
	}
}