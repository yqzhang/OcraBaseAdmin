/*
 * Generated by MyEclipse Struts
 * Template path: templates/java/JavaClass.vtl
 */
package com.ocrabaseadmin.struts.form;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/** 
 * MyEclipse Struts
 * Creation date: 08-25-2011
 * 
 * XDoclet definition:
 * @struts.form name="testStatisticsQueryForm"
 */
public class TestStatisticsQueryForm extends ActionForm {
	/*
	 * Generated fields
	 */

	/** query property */
	private String query;

	/*
	 * Generated Methods
	 */

	/** 
	 * Method validate
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		// TODO Auto-generated method stub
		return null;
	}

	/** 
	 * Method reset
	 * @param mapping
	 * @param request
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		// TODO Auto-generated method stub
	}

	/** 
	 * Returns the query.
	 * @return String
	 */
	public String getQuery() {
		return query;
	}

	/** 
	 * Set the query.
	 * @param query The query to set
	 */
	public void setQuery(String query) {
		this.query = query;
	}
}