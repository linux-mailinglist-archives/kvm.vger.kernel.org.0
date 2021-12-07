Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8E646C037
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbhLGQFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11844 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239394AbhLGQFk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FmNJ4001763;
        Tue, 7 Dec 2021 16:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=o/W6sOETm2SUTI+LANA65maZTUCEse/UzaC0nXJQgFU=;
 b=L6TiM5rogqOm1KCXk0SW4L8A6rfDXCBRkZ9NLwB50DMT141QIRG7mY6PNHgKeHY4SzCJ
 iN2GSLnCJFqh6gf0w82lWYYBGQs5U0v2xh/pVRc6J9mzli2rCbGROYKrOseA46TXrwej
 t1ylkum1hJhK7PujD1lrVKZs/k4TK3bWdJDhTSDfam0ZEeja5CDEOG7462sHr60N1srL
 +I5algIUgeuRQKkh2Unp+eSEoYm6e08Li77vBMN8B0nn17sEgnThESzrHxkAPP0kvt5R
 n1mqX8IrCHKFeKrEAp0IK6ts5mxDMr//y3LUEQvStnqDd5b7JUtCPNc+8Y+fvAEM69YU kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxg9dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:09 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7Fp48O006576;
        Tue, 7 Dec 2021 16:02:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajxg9cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FqhMp010876;
        Tue, 7 Dec 2021 16:02:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykj870j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7G23Vm34210282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 16:02:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D1714C046;
        Tue,  7 Dec 2021 16:02:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F02504C052;
        Tue,  7 Dec 2021 16:02:01 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:02:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 04/10] s390x: uv: Add more UV call functions
Date:   Tue,  7 Dec 2021 15:59:59 +0000
Message-Id: <20211207160005.1586-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207160005.1586-1-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XWijra1iDVQkHPL0P0CmrprIqcwbSelV
X-Proofpoint-GUID: GdwmlZfKSLhXMuAgb0u6nhpSvoMR6xKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=960 lowpriorityscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To manage protected guests we need a few more UV calls:
   * import / export
   * destroy page
   * set SE header
   * set cpu state

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

