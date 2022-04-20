Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58A250870B
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 13:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378140AbiDTLeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 07:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378130AbiDTLeJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 07:34:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C882720BD7;
        Wed, 20 Apr 2022 04:31:23 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23K9OdaM019916;
        Wed, 20 Apr 2022 11:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ApmMDy8ihpxCIL28eXU5BE89h9eO+Z4bEH7aztRr22g=;
 b=UuLYXeOoqOaVYrbp+DVpjGTsp9QM4iozxYjNghH4I0E8qPo+LAA5CHzIaGV6s16fbW/e
 RUj4uPHdO9hcSRcemiM+25oDNwwsCubS8fHZmrVb+sCnqsLNBSn1KSXCDdWm02xaR6Jt
 h7sO0A/jTSNwQ4q6ExY36NTwrIB+GpqUfOI5nSQcpCB5IrbBTyQyEXexI89/AWoVYRhP
 cZb6i/dZYD6y7Nv402jBre7a3EadM+wffikRJrjnn/S/zUikAVoTzx3E3o8Xwi/wwwJ7
 9IUhHEzl549zEvyILMjlHWZo4qwdERi0IgpfgziK8LvxJHe81VNxFZ1GFT1K1rdHL4F5 mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7bu1q64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:23 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KBPJkc006880;
        Wed, 20 Apr 2022 11:31:23 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7bu1q4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:22 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KBRxuq030245;
        Wed, 20 Apr 2022 11:31:18 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ffne8vw9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 11:31:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KBVQM16095506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 11:31:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A18BF52051;
        Wed, 20 Apr 2022 11:31:15 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.58.217])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EBAF452050;
        Wed, 20 Apr 2022 11:31:14 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 2/2] s390x: KVM: resetting the Topology-Change-Report
Date:   Wed, 20 Apr 2022 13:34:30 +0200
Message-Id: <20220420113430.11876-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220420113430.11876-1-pmorel@linux.ibm.com>
References: <20220420113430.11876-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h-cR9XneowdfDXkRVEVEGE1bA1rWwrkU
X-Proofpoint-GUID: 5NGZjxA0aJLaeFOIvs_PcIRsbtXkA95s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_02,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During a subsystem reset the Topology-Change-Report is cleared.
Let's give userland the possibility to clear the MTCR in the case
of a subsystem reset.

To migrate the MTCR, let's give userland the possibility to
query the MTCR state.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/uapi/asm/kvm.h |   9 +++
 arch/s390/kvm/kvm-s390.c         | 103 +++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 7a6b14874d65..bb3df6d49f27 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_CPU_TOPOLOGY	5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,14 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for cpu topology */
+#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR	0
+#define KVM_S390_VM_CPU_TOPO_MTR_SET	1
+
+struct kvm_s390_cpu_topology {
+	__u16 mtcr;
+};
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 925ccc59f283..755f325c9e70 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1756,6 +1756,100 @@ static int kvm_s390_sca_set_mtcr(struct kvm *kvm)
 	return 0;
 }
 
+/**
+ * kvm_s390_sca_clear_mtcr
+ * @kvm: guest KVM description
+ *
+ * Is only relevant if the topology facility is present,
+ * the caller should check KVM facility 11
+ *
+ * Updates the Multiprocessor Topology-Change-Report to signal
+ * the guest with a topology change.
+ */
+static int kvm_s390_sca_clear_mtcr(struct kvm *kvm)
+{
+	struct bsca_block *sca = kvm->arch.sca;
+	struct kvm_vcpu *vcpu;
+	int val;
+
+	vcpu = kvm_s390_get_first_vcpu(kvm);
+	if (!vcpu)
+		return -ENODEV;
+
+	ipte_lock(vcpu);
+	val = READ_ONCE(sca->utility);
+	WRITE_ONCE(sca->utility, sca->utility & ~SCA_UTILITY_MTCR);
+	ipte_unlock(vcpu);
+
+	return 0;
+}
+
+/**
+ * kvm_s390_sca_get_mtcr
+ * @kvm: guest KVM description
+ *
+ * Is only relevant if the topology facility is present,
+ * the caller should check KVM facility 11
+ *
+ * reports to QEMU the Multiprocessor Topology-Change-Report.
+ */
+static int kvm_s390_sca_get_mtcr(struct kvm *kvm)
+{
+	struct bsca_block *sca = kvm->arch.sca;
+	struct kvm_vcpu *vcpu;
+	int val;
+
+	vcpu = kvm_s390_get_first_vcpu(kvm);
+	if (!vcpu)
+		return -ENODEV;
+
+	ipte_lock(vcpu);
+	val = READ_ONCE(sca->utility);
+	ipte_unlock(vcpu);
+
+	return val;
+}
+
+static int kvm_s390_set_topology(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	int ret = -EFAULT;
+
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	switch (attr->attr) {
+	case KVM_S390_VM_CPU_TOPO_MTR_SET:
+		ret = kvm_s390_sca_set_mtcr(kvm);
+		break;
+	case KVM_S390_VM_CPU_TOPO_MTR_CLEAR:
+		ret = kvm_s390_sca_clear_mtcr(kvm);
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_s390_get_topology(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	struct kvm_s390_cpu_topology *topology;
+	int ret = 0;
+
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	topology = kzalloc(sizeof(*topology), GFP_KERNEL);
+	if (!topology)
+		return -ENOMEM;
+
+	topology->mtcr =  kvm_s390_sca_get_mtcr(kvm);
+	if (copy_to_user((void __user *)attr->addr, topology,
+			 sizeof(struct kvm_s390_cpu_topology)))
+		ret = -EFAULT;
+
+	kfree(topology);
+	return ret;
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -1776,6 +1870,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_set_topology(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1801,6 +1898,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_get_topology(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1874,6 +1974,9 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = 0;
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = test_kvm_facility(kvm, 11) ? 0 : -ENXIO;
+		break;
 	default:
 		ret = -ENXIO;
 		break;
-- 
2.27.0

