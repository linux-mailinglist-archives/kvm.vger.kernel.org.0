Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8C84EC42A
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344946AbiC3Mfb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244092AbiC3MfT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:35:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170F97DE14;
        Wed, 30 Mar 2022 05:20:59 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UB6pdG009916;
        Wed, 30 Mar 2022 12:20:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3mxydTDT9awHIfuf+G+HYjSfmRKWV1j7ewQUFAJnHT8=;
 b=MCDThUcS/k1t0BFu8m0IX+y9eM3q/y8hUohcNcEanTxTOTKVHzkum0fC7DfkHVQ6Hpp+
 5oVBHvIafj/1EQdLJQDXn0o9miUBPkiqr3XxfsDgI97PO2BF6IPSC0fWC5pSK+hUDE36
 71dDvjGhkD90ciDyzzScX5yEZ0A7GC5lYdQ3rOWToe5Odhokly1AfB0jOiaPbOgw68c3
 Lj+n6qIuiyKBEYU7tCzVgtqy7w5eMUbbAGf2LidihXi1OCUQlxzeW+VAUkoJvYVUyZW1
 7Qe8ai8UHW3wFkzEbyr5yc8sld6uqg4EW25VtwIiPcmWmGa+9vR/jJHttwL6i+rCpdla bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40t8w2ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:39 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UCH8m4020389;
        Wed, 30 Mar 2022 12:20:39 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40t8w2fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:39 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBwHJO015502;
        Wed, 30 Mar 2022 12:20:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3f1tf8y8jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCKXV551577288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:20:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1228E42045;
        Wed, 30 Mar 2022 12:20:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7614F4203F;
        Wed, 30 Mar 2022 12:20:32 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:20:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v3 3/9] KVM: s390: pv: Add query interface
Date:   Wed, 30 Mar 2022 12:19:46 +0000
Message-Id: <20220330121952.105725-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330121952.105725-1-frankja@linux.ibm.com>
References: <20220330121952.105725-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K8B6A25w5pfh88DH6wbMQAUERV7kXptO
X-Proofpoint-GUID: kJPNSdKaPf7PrPIcSmToe9OnAbBxpnka
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some of the query information is already available via sysfs but
having a IOCTL makes the information easier to retrieve.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 78 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 25 +++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c5a29cf9842b..26307adf6a1c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2224,6 +2224,44 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return r;
 }
 
+/*
+ * Here we provide user space with a direct interface to query UV
+ * related data like UV maxima and available features as well as
+ * feature specific data.
+ *
+ * To facilitate future extension of the data structures we'll try to
+ * write data up to the maximum requested length but we always require
+ * a minimum length which is the length of the first version of the
+ * data structure.
+ */
+static ssize_t kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
+{
+	ssize_t len_min;
+
+	switch (info->header.id) {
+	case KVM_PV_INFO_VM: {
+		len_min =  sizeof(info->header) + sizeof(info->vm);
+
+		if (info->header.len_max < len_min)
+			return -EINVAL;
+
+		memcpy(info->vm.inst_calls_list,
+		       uv_info.inst_calls_list,
+		       sizeof(uv_info.inst_calls_list));
+
+		/* It's max cpuidm not max cpus so it's off by one */
+		info->vm.max_cpus = uv_info.max_guest_cpu_id + 1;
+		info->vm.max_guests = uv_info.max_num_sec_conf;
+		info->vm.max_guest_addr = uv_info.max_sec_stor_addr;
+		info->vm.feature_indication = uv_info.uv_feature_indications;
+
+		return len_min;
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
 static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int r = 0;
@@ -2360,6 +2398,46 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			     cmd->rc, cmd->rrc);
 		break;
 	}
+	case KVM_PV_INFO: {
+		struct kvm_s390_pv_info info = {};
+		ssize_t data_len;
+
+		/*
+		 * No need to check the VM protection here.
+		 *
+		 * Maybe user space wants to query some of the data
+		 * when the VM is still unprotected. If we see the
+		 * need to fence a new data command we can still
+		 * return an error in the info handler.
+		 */
+
+		r = -EFAULT;
+		if (copy_from_user(&info, argp, sizeof(info.header)))
+			break;
+
+		r = -EINVAL;
+		if (info.header.len_max < sizeof(info.header))
+			break;
+
+		data_len = kvm_s390_handle_pv_info(&info);
+		if (data_len < 0) {
+			r = data_len;
+			break;
+		}
+		/*
+		 * If a data command struct is extended (multiple
+		 * times) this can be used to determine how much of it
+		 * is valid.
+		 */
+		info.header.len_written = data_len;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, &info, data_len))
+			break;
+
+		r = 0;
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a02bbf8fd0f6..21f19863c417 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1643,6 +1643,30 @@ struct kvm_s390_pv_unp {
 	__u64 tweak;
 };
 
+enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+};
+
+struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+};
+
+struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+};
+
+struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	struct kvm_s390_pv_info_vm vm;
+};
+
 enum pv_cmd_id {
 	KVM_PV_ENABLE,
 	KVM_PV_DISABLE,
@@ -1651,6 +1675,7 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
 };
 
 struct kvm_pv_cmd {
-- 
2.32.0

