package org.colorcoding.ibas.bobas.approval;

/**
 * 属性取值方式
 * 
 * @author Niuren.Zhu
 *
 */
public enum ValueMode {
	/**
	 * 属性取值
	 */
	Property,
	/**
	 * 数据库字段取值
	 */
	DBField,
	/**
	 * 输入值
	 */
	Input,
	/**
	 * sql脚本取值
	 */
	SQLScript
}
