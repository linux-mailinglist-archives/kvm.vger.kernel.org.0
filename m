Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D7F1506EC
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgBCNUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728381AbgBCNUe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:34 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DI83v079836
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:33 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm9cr246-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:29 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DIGt4082424
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:25 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm9cr22b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:25 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DKFX7023655;
        Mon, 3 Feb 2020 13:20:23 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 2xw0y6d8j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:23 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DKLJN48562566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:21 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16EB428067;
        Mon,  3 Feb 2020 13:20:21 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 109F728066;
        Mon,  3 Feb 2020 13:20:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:15 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 31/37] KVM: s390: protvirt: UV calls diag308 0, 1
Date:   Mon,  3 Feb 2020 08:19:51 -0500
Message-Id: <20200203131957.383915-32-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

diag 308 subcode 0 and 1 require KVM and Ultravisor interaction, since
the cpus have to be set into multiple reset states.

* All cpus need to be stopped
* The "unshare all" UVC needs to be executed
* The "perform reset" UVC needs to be executed
* The cpus need to be reset via the "set cpu state" UVC
* The issuing cpu needs to set state 5 via "set cpu state"

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 25 +++++++++++++++++++++++++
 arch/s390/kvm/diag.c       |  1 +
 arch/s390/kvm/kvm-s390.c   | 28 ++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h   |  2 ++
 arch/s390/kvm/pv.c         | 19 +++++++++++++++++++
 include/uapi/linux/kvm.h   |  2 ++
 6 files changed, 77 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 315ec15efe44..584ad82740b6 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -36,6 +36,12 @@
 #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
 #define UVC_CMD_UNPACK_IMG		0x0301
 #define UVC_CMD_VERIFY_IMG		0x0302
+#define UVC_CMD_CPU_RESET		0x0310
+#define UVC_CMD_CPU_RESET_INITIAL	0x0311
+#define UVC_CMD_PERF_CONF_CLEAR_RESET	0x0320
+#define UVC_CMD_CPU_RESET_CLEAR		0x0321
+#define UVC_CMD_CPU_SET_STATE		0x0330
+#define UVC_CMD_SET_UNSHARED_ALL	0x0340
 #define UVC_CMD_PIN_PAGE_SHARED		0x0341
 #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
@@ -56,6 +62,12 @@ enum uv_cmds_inst {
 	BIT_UVC_CMD_SET_SEC_PARMS = 11,
 	BIT_UVC_CMD_UNPACK_IMG = 13,
 	BIT_UVC_CMD_VERIFY_IMG = 14,
+	BIT_UVC_CMD_CPU_RESET = 15,
+	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
+	BIT_UVC_CMD_CPU_SET_STATE = 17,
+	BIT_UVC_CMD_PREPARE_CLEAR_RESET = 18,
+	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
+	BIT_UVC_CMD_REMOVE_SHARED_ACCES = 20,
 	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
 	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 };
@@ -153,6 +165,19 @@ struct uv_cb_unp {
 	u64 reserved28[3];
 } __packed __aligned(8);
 
+#define PV_CPU_STATE_OPR	1
+#define PV_CPU_STATE_STP	2
+#define PV_CPU_STATE_CHKSTP	3
+
+struct uv_cb_cpu_set_state {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u8  reserved20[7];
+	u8  state;
+	u64 reserved28[5];
+};
+
 /*
  * A common UV call struct for the following calls:
  * Destroy cpu/config
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index b951dbdcb6a0..1c53eb7ba152 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -13,6 +13,7 @@
 #include <asm/pgalloc.h>
 #include <asm/gmap.h>
 #include <asm/virtio-ccw.h>
+#include <asm/uv.h>
 #include "kvm-s390.h"
 #include "trace.h"
 #include "trace-s390.h"
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d786b34be244..3ab5091ded6c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2272,6 +2272,34 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			 ret >> 16, ret & 0x0000ffff);
 		break;
 	}
+	case KVM_PV_VM_PERF_CLEAR_RESET: {
+		u32 ret;
+
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+				  UVC_CMD_PERF_CONF_CLEAR_RESET,
+				  &ret);
+		VM_EVENT(kvm, 3, "PROTVIRT PERF CLEAR: rc %x rrc %x",
+			 ret >> 16, ret & 0x0000ffff);
+		break;
+	}
+	case KVM_PV_VM_UNSHARE: {
+		u32 ret;
+
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm))
+			break;
+
+		r = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
+				  UVC_CMD_SET_UNSHARED_ALL,
+				  &ret);
+		VM_EVENT(kvm, 3, "PROTVIRT UNSHARE: %d rc %x rrc %x",
+			 r, ret >> 16, ret & 0x0000ffff);
+		break;
+	}
 	default:
 		return -ENOTTY;
 	}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index d77da15bebe5..d890a4336690 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -208,6 +208,7 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length);
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 		       unsigned long tweak);
 int kvm_s390_pv_verify(struct kvm *kvm);
+int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state);
 
 static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
@@ -236,6 +237,7 @@ static inline int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr,
 				     unsigned long size,  unsigned long tweak)
 { return 0; }
 static inline int kvm_s390_pv_verify(struct kvm *kvm) { return 0; }
+static inline int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state) { return 0; }
 static inline bool kvm_s390_pv_is_protected(struct kvm *kvm) { return 0; }
 static inline u64 kvm_s390_pv_handle(struct kvm *kvm) { return 0; }
 static inline u64 kvm_s390_pv_handle_cpu(struct kvm_vcpu *vcpu) { return 0; }
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 50e1dc68d972..dade21e10bcc 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -255,3 +255,22 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished rc %x", rc);
 	return rc;
 }
+
+int kvm_s390_pv_set_cpu_state(struct kvm_vcpu *vcpu, u8 state)
+{
+	int rc;
+	struct uv_cb_cpu_set_state uvcb = {
+		.header.cmd	= UVC_CMD_CPU_SET_STATE,
+		.header.len	= sizeof(uvcb),
+		.cpu_handle	= kvm_s390_pv_handle_cpu(vcpu),
+		.state		= state,
+	};
+
+	if (!kvm_s390_pv_handle_cpu(vcpu))
+		return -EINVAL;
+
+	rc = uv_call(0, (u64)&uvcb);
+	if (rc)
+		return -EINVAL;
+	return 0;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 20969ce12096..8b77e92a6422 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1502,6 +1502,8 @@ enum pv_cmd_id {
 	KVM_PV_VM_SET_SEC_PARMS,
 	KVM_PV_VM_UNPACK,
 	KVM_PV_VM_VERIFY,
+	KVM_PV_VM_PERF_CLEAR_RESET,
+	KVM_PV_VM_UNSHARE,
 	KVM_PV_VCPU_CREATE,
 	KVM_PV_VCPU_DESTROY,
 };
-- 
2.24.0

