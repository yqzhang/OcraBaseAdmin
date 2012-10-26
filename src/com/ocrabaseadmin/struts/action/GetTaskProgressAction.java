/*
 * Generated by MyEclipse Struts
 * Template path: templates/java/JavaClass.vtl
 */
package com.ocrabaseadmin.struts.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import ict.ocrabase.main.java.client.webinterface.TaskDescription;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 08-28-2011
 * 
 * XDoclet definition:
 * @struts.action validate="true"
 */
public class GetTaskProgressAction extends Action {
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
	@SuppressWarnings("deprecation")
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub
		
		TaskDescription[] taskDesc = (TaskDescription[])request.getSession().getAttribute("TASKDESC");
		
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/xml; charset=UTF-8");
		
		out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		
		out.println("<tasklist>");
		for(int i = 0;i < taskDesc.length;i++) {
			out.println("<task>");
			
			out.println("<progress>");
			out.println(taskDesc[i].getProgress());
			out.println("</progress>");
			
			out.println("<endtime>");
			SimpleDateFormat sdf= new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
			Date dt = new Date(taskDesc[i].getEndTime());
			if(dt.getYear() < 100) {
				out.println("--");
			}
			else {
				out.println(sdf.format(dt));
			}
			out.println("</endtime>");
			
			out.println("<status>");
			out.println(taskDesc[i].getStatus());
			out.println("</status>");
			
			out.println("</task>");
		}
		out.println("</tasklist>");
		
		return null;
	}
}