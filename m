Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F27145A07B
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhKWKnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234482AbhKWKnY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:24 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN9Gl77029049;
        Tue, 23 Nov 2021 10:40:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yIOpEs9GQwN8+t6fGFwSF0O9XsL3T/Rq5ELP/NEKRZE=;
 b=BVSKRIXT4cmpzXBMlcLVMqpK1W6P8HCiYWBHxnh1C2Cx338t5ZwnXgif4ReViVbrFuWL
 yckp+RZbG82JNzliCPIJRZj9GwhANKZWAIWMFsWm82jqX437lyTYrPs021PTg7zBDFuq
 SRR54Q+4MW3Bvn4Q1cYr+KwEe1Ai9W8m8aflf8anJB0GsOJZurOzXcomgL6QnUN8S0qi
 WTx9WTEPDGfhmRz8Zkd3111TdJuUFCJ219mnSh2hgNSg808fU10/2X707+CjFIDMkRrg
 i1PNr5Jn01sqGd0FPkNhtaUGH98fRp2TQk2KY2LYlw23GhlpSH5JtFZoGtySwC6v3Z/c HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgwhe9guq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:16 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANAMsKj014815;
        Tue, 23 Nov 2021 10:40:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgwhe9gtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:15 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAcC1I007094;
        Tue, 23 Nov 2021 10:40:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3cern9nkmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAWwgD33227052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:32:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03C31A406E;
        Tue, 23 Nov 2021 10:40:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE3E6A406F;
        Tue, 23 Nov 2021 10:40:08 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/8] s390x: uv: Add more UV call functions
Date:   Tue, 23 Nov 2021 10:39:52 +0000
Message-Id: <20211123103956.2170-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IXTY3ZzR5-cfY0zDKR3BYmzEAppXTTBt
X-Proofpoint-ORIG-GUID: mQHGDlGqKZak_Kxj0tBUCJ2djeoYmt7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=964 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To manage protected guests we need a few more UV calls:
   * import / export
   * destroy page
   * set SE header
   * set cpu state

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 85 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 8baf896f..6e331211 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -33,6 +33,7 @@
 #define UVC_CMD_DESTROY_SEC_CPU		0x0121
 #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
 #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
+#define UVC_CMD_DESTR_SEC_STOR		0x0202
 #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
 #define UVC_CMD_UNPACK_IMG		0x0301
 #define UVC_CMD_VERIFY_IMG		0x0302
@@ -256,6 +257,63 @@ static inline int uv_remove_shared(unsigned long addr)
 	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
 }
 
+static inline int uv_cmd_nodata(uint64_t handle, uint16_t cmd, uint16_t *rc, uint16_t *rrc)
+{
+	struct uv_cb_nodata uvcb = {
+		.header.cmd = cmd,
+		.header.len = sizeof(uvcb),
+		.handle = handle,
+	};
+	int cc;
+
+	assert(handle);
+	cc = uv_call(0, (uint64_t)&uvcb);
+	*rc = uvcb.header.rc;
+	*rrc = uvcb.header.rrc;
+	return cc;
+}
+
+static inline int uv_import(uint64_t handle, unsigned long gaddr)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = handle,
+		.gaddr = gaddr,
+	};
+
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
+static inline int uv_export(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.paddr = paddr
+	};
+
+	return uv_call(0, (u64)&uvcb);
+}
+
+/*
+ * Requests the Ultravisor to destroy a guest page and make it
+ * accessible to the host. The destroy clears the page instead of
+ * exporting.
+ *
+ * @paddr: Absolute host address of page to be destroyed
+ */
+static inline int uv_destroy_page(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.paddr = paddr
+	};
+
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
 struct uv_cb_cpu_set_state {
 	struct uv_cb_header header;
 	u64 reserved08[2];
@@ -270,4 +328,31 @@ struct uv_cb_cpu_set_state {
 #define PV_CPU_STATE_CHKSTP	3
 #define PV_CPU_STATE_OPR_LOAD	5
 
+static inline int uv_set_cpu_state(uint64_t handle, uint8_t state)
+{
+	struct uv_cb_cpu_set_state uvcb = {
+		.header.cmd = UVC_CMD_CPU_SET_STATE,
+		.header.len = sizeof(uvcb),
+		.cpu_handle = handle,
+		.state = state,
+	};
+
+	assert(handle);
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
+static inline int uv_set_se_hdr(uint64_t handle, void *hdr, size_t len)
+{
+	struct uv_cb_ssc uvcb = {
+		.header.cmd = UVC_CMD_SET_SEC_CONF_PARAMS,
+		.header.len = sizeof(uvcb),
+		.sec_header_origin = (uint64_t)hdr,
+		.sec_header_len = len,
+		.guest_handle = handle,
+	};
+
+	assert(handle);
+	return uv_call(0, (uint64_t)&uvcb);
+}
+
 #endif
-- 
2.32.0

