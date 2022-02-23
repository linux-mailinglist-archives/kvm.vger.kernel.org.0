Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D24C0F0F
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239270AbiBWJVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239250AbiBWJU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:20:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D78302D;
        Wed, 23 Feb 2022 01:20:28 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N7kZjx016879;
        Wed, 23 Feb 2022 09:20:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2NRcDr1lIdzcfAh4kyjfMkjIFQWB7PuJ/fcUGHEp2k8=;
 b=OSfw/yKeboj6ZAQIQb52Q5iLVUNTqp1ZeseSzKC3XKsgfmLLyZhb8FJHwGA1DV64if18
 pS9sgMFn9HDmHh0S8XK/BYNfgdUzu4r/6N70V3o1IpUpgcWnul89I6p9+1ToSDACIDml
 ReFf2INC8K4TtDbz2Z9xLU6F1BLYWFAMKeXhDe0PjLYo/NtM3a6D0eDGyvu1zGcCuObY
 OshXVbhylhHkVx85Bk4f6j5Ib7bO/6M7/iANJxTkMxuVQORSoCzeyBtutVmRHbY9gbSi
 mrA/IaDuDGwYSZ+ck4+3DX5E8QUgapwbzh+20l68jH7dWXzrBC/UsdZ5qExr4fg7bWDz JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edd89wasx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:27 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N8uCHA006080;
        Wed, 23 Feb 2022 09:20:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edd89wasc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9BiYA020928;
        Wed, 23 Feb 2022 09:20:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear698jx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:20:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9KKBK55771452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:20:20 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14F3911C05E;
        Wed, 23 Feb 2022 09:20:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7878311C054;
        Wed, 23 Feb 2022 09:20:19 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:20:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH 3/9] KVM: s390: pv: Add query interface
Date:   Wed, 23 Feb 2022 09:20:01 +0000
Message-Id: <20220223092007.3163-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223092007.3163-1-frankja@linux.ibm.com>
References: <20220223092007.3163-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cf5CwEIrVVtV2aQyDq0VaWuRwpYMtvB0
X-Proofpoint-ORIG-GUID: hqPGxSnWfh8LRHQrGuyV58lDtVbAFkDt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202230049
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
 arch/s390/kvm/kvm-s390.c | 47 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h | 23 ++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index faa85397b6fb..837f898ad2ff 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2217,6 +2217,34 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return r;
 }
 
+static int kvm_s390_handle_pv_info(struct kvm_s390_pv_info *info)
+{
+	u32 len;
+
+	switch (info->header.id) {
+	case KVM_PV_INFO_VM: {
+		len =  sizeof(info->header) + sizeof(info->vm);
+
+		if (info->header.len < len)
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
+		return 0;
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
 static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int r = 0;
@@ -2353,6 +2381,25 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			     cmd->rc, cmd->rrc);
 		break;
 	}
+	case KVM_PV_INFO: {
+		struct kvm_s390_pv_info info = {};
+
+		if (copy_from_user(&info, argp, sizeof(info.header)))
+			return -EFAULT;
+
+		if (info.header.len < sizeof(info.header))
+			return -EINVAL;
+
+		r = kvm_s390_handle_pv_info(&info);
+		if (r)
+			return r;
+
+		r = copy_to_user(argp, &info, sizeof(info));
+
+		if (r)
+			return -EFAULT;
+		return 0;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dbc550bbd9fa..96fceb204a92 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1642,6 +1642,28 @@ struct kvm_s390_pv_unp {
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
+	__u32 len;
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
@@ -1650,6 +1672,7 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
 };
 
 struct kvm_pv_cmd {
-- 
2.32.0

