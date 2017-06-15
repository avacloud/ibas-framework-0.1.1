package org.colorcoding.ibas.bobas.approval;

import org.colorcoding.ibas.bobas.core.IBORepository;

/**
 * 审批流程管理员
 * 
 * @author Niuren.Zhu
 *
 */
public interface IApprovalProcessManager {
	/**
	 * 检查并开启流程
	 * 
	 * @param bo
	 * @return 流程实例或null;
	 */
	IApprovalProcess checkProcess(IApprovalData data, IBORepository repository);
}
