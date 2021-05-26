Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94F8391AE1
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbhEZO5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:57:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235201AbhEZO51 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 10:57:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QEXvSD007037;
        Wed, 26 May 2021 10:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hvQqAKGdoxDaeuu751xv8sqOkuqJyaY3G8b4kN54aIg=;
 b=cw2K1KtCx6zzpYwjsLkSlyLc3JkAImE1eNSRohsVEBXse4B3Ks0eL0C+8NNlZXp5ZroH
 q3vT+4udgt2DMLpSZMawwVrFfsk4sAxtNz4+lPLrUPrIqOv+e2Qt5+ngCiF7797lDXyL
 rcw9SUv7yBtyz0cr0PWWssI+yDnVPqBIgoSHvLgJ7K9mclkoNR9KPBIl2qgezbQHxH5R
 /H9868RzeVJ8yMcyHSc9BYhtuyKxHc5+KEeT7LrvsvitSUksRcVj3rsyKivkGlLKTqov
 3EKjDnU6O7VOVfvo9LZgCp2o0eY65QAXdP+4Scc1ff2i9pqWxvzkC3+83r6cF13JTR9/ lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38spn7mdvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:56 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QEY3uv007917;
        Wed, 26 May 2021 10:55:55 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38spn7mdu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 10:55:55 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QErKxx023965;
        Wed, 26 May 2021 14:55:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 38s1ukgmc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 14:55:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QEtnS033620290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 14:55:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0752A40C9;
        Wed, 26 May 2021 14:55:49 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C729A40A6;
        Wed, 26 May 2021 14:55:49 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.174.11])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 14:55:49 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 2/9] s390x: Add more Ultravisor command structure definitions
Date:   Wed, 26 May 2021 16:55:32 +0200
Message-Id: <20210526145539.52008-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210526145539.52008-1-frankja@linux.ibm.com>
References: <20210526145539.52008-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BV92m_j1F6fkYcQXYdKaG5MgLB-Rqwbs
X-Proofpoint-ORIG-GUID: gTr_mOmc-OrNkbEJya5ROvroVddKtuqt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_09:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

They are needed in the new UV tests.

As we now extend the size of the query struct, we need to set the
length in the UV guest query test to a constant instead of using
sizeof.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/uv.h | 148 ++++++++++++++++++++++++++++++++++++++++++++-
 s390x/uv-guest.c   |   3 +-
 2 files changed, 149 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 9c491844..11f70a9f 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -17,16 +17,54 @@
 #define UVC_RC_INV_STATE	0x0003
 #define UVC_RC_INV_LEN		0x0005
 #define UVC_RC_NO_RESUME	0x0007
+#define UVC_RC_INV_GHANDLE	0x0020
+#define UVC_RC_INV_CHANDLE	0x0021
 
 #define UVC_CMD_QUI			0x0001
+#define UVC_CMD_INIT_UV			0x000f
+#define UVC_CMD_CREATE_SEC_CONF		0x0100
+#define UVC_CMD_DESTROY_SEC_CONF	0x0101
+#define UVC_CMD_CREATE_SEC_CPU		0x0120
+#define UVC_CMD_DESTROY_SEC_CPU		0x0121
+#define UVC_CMD_CONV_TO_SEC_STOR	0x0200
+#define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
+#define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
+#define UVC_CMD_UNPACK_IMG		0x0301
+#define UVC_CMD_VERIFY_IMG		0x0302
+#define UVC_CMD_CPU_RESET		0x0310
+#define UVC_CMD_CPU_RESET_INITIAL	0x0311
+#define UVC_CMD_PERF_CONF_CLEAR_RESET	0x0320
+#define UVC_CMD_CPU_RESET_CLEAR		0x0321
+#define UVC_CMD_CPU_SET_STATE		0x0330
+#define UVC_CMD_SET_UNSHARED_ALL	0x0340
+#define UVC_CMD_PIN_PAGE_SHARED		0x0341
+#define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
 	BIT_UVC_CMD_QUI = 0,
+	BIT_UVC_CMD_INIT_UV = 1,
+	BIT_UVC_CMD_CREATE_SEC_CONF = 2,
+	BIT_UVC_CMD_DESTROY_SEC_CONF = 3,
+	BIT_UVC_CMD_CREATE_SEC_CPU = 4,
+	BIT_UVC_CMD_DESTROY_SEC_CPU = 5,
+	BIT_UVC_CMD_CONV_TO_SEC_STOR = 6,
+	BIT_UVC_CMD_CONV_FROM_SEC_STOR = 7,
 	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
 	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
+	BIT_UVC_CMD_SET_SEC_PARMS = 11,
+	BIT_UVC_CMD_UNPACK_IMG = 13,
+	BIT_UVC_CMD_VERIFY_IMG = 14,
+	BIT_UVC_CMD_CPU_RESET = 15,
+	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
+	BIT_UVC_CMD_CPU_SET_STATE = 17,
+	BIT_UVC_CMD_PREPARE_CLEAR_RESET = 18,
+	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
+	BIT_UVC_CMD_UNSHARE_ALL = 20,
+	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
+	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 };
 
 struct uv_cb_header {
@@ -36,13 +74,81 @@ struct uv_cb_header {
 	u16 rrc;	/* Return Reason Code */
 } __attribute__((packed))  __attribute__((aligned(8)));
 
+struct uv_cb_init {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 stor_origin;
+	u64 stor_len;
+	u64 reserved28[4];
+
+} __attribute__((packed))  __attribute__((aligned(8)));
+
 struct uv_cb_qui {
 	struct uv_cb_header header;
 	u64 reserved08;
 	u64 inst_calls_list[4];
-	u64 reserved30[15];
+	u64 reserved30[2];
+	u64 uv_base_stor_len;
+	u64 reserved48;
+	u64 conf_base_phys_stor_len;
+	u64 conf_base_virt_stor_len;
+	u64 conf_virt_var_stor_len;
+	u64 cpu_stor_len;
+	u32 reserved70[3];
+	u32 max_num_sec_conf;
+	u64 max_guest_stor_addr;
+	u8  reserved88[158 - 136];
+	u16 max_guest_cpus;
+	u8  reserveda0[200 - 160];
+}  __attribute__((packed))  __attribute__((aligned(8)));
+
+struct uv_cb_cgc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 conf_base_stor_origin;
+	u64 conf_var_stor_origin;
+	u64 reserved30;
+	u64 guest_stor_origin;
+	u64 guest_stor_len;
+	u64 guest_sca;
+	u64 guest_asce;
+	u64 reserved60[5];
 } __attribute__((packed))  __attribute__((aligned(8)));
 
+struct uv_cb_csc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u64 guest_handle;
+	u64 stor_origin;
+	u8  reserved30[6];
+	u16 num;
+	u64 state_origin;
+	u64 reserved[4];
+} __attribute__((packed))  __attribute__((aligned(8)));
+
+struct uv_cb_unp {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 gaddr;
+	u64 tweak[2];
+	u64 reserved38[3];
+} __attribute__((packed))  __attribute__((aligned(8)));
+
+/*
+ * A common UV call struct for the following calls:
+ * Destroy cpu/config
+ * Verify
+ */
+struct uv_cb_nodata {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 handle;
+	u64 reserved20[4];
+}  __attribute__((packed))  __attribute__((aligned(8)));
+
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
@@ -50,6 +156,32 @@ struct uv_cb_share {
 	u64 reserved28;
 } __attribute__((packed))  __attribute__((aligned(8)));
 
+/* Convert to Secure */
+struct uv_cb_cts {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 gaddr;
+}  __attribute__((packed))  __attribute__((aligned(8)));
+
+/* Convert from Secure / Pin Page Shared */
+struct uv_cb_cfs {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 paddr;
+}  __attribute__((packed))  __attribute__((aligned(8)));
+
+/* Set Secure Config Parameter */
+struct uv_cb_ssc {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 sec_header_origin;
+	u32 sec_header_len;
+	u32 reserved2c;
+	u64 reserved30[4];
+} __attribute__((packed))  __attribute__((aligned(8)));
+
 static inline int uv_call_once(unsigned long r1, unsigned long r2)
 {
 	int cc;
@@ -118,4 +250,18 @@ static inline int uv_remove_shared(unsigned long addr)
 	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
 }
 
+struct uv_cb_cpu_set_state {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 cpu_handle;
+	u8  reserved20[7];
+	u8  state;
+	u64 reserved28[5];
+};
+
+#define PV_CPU_STATE_OPR	1
+#define PV_CPU_STATE_STP	2
+#define PV_CPU_STATE_CHKSTP	3
+#define PV_CPU_STATE_OPR_LOAD	5
+
 #endif
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index a13669ab..393d7f5c 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -59,7 +59,8 @@ static void test_query(void)
 {
 	struct uv_cb_qui uvcb = {
 		.header.cmd = UVC_CMD_QUI,
-		.header.len = sizeof(uvcb) - 8,
+		/* A dword below the minimum length */
+		.header.len = 0xa0,
 	};
 	int cc;
 
-- 
2.31.1

