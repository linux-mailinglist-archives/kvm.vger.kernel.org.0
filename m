Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97010490D19
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241767AbiAQRAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18994 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241463AbiAQQ76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 11:59:58 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HFT5X2029911
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=HNPJ0cEXEKQQ2Yy8+LJfAs/CmkeI/X44h6StSg7urEc=;
 b=Odbx8RVqYgdutLWzdndUg+rnAqVc8mJNEeINcEE8oUP+RcmJs1QkoK5oVQckgNMh8Qqh
 9Rs/5J1Pws8WCHXgokfqnnhEbeSKK4b47Ejdf5Uy0j2ILW5nTl0GkxBSEoSqRiLHq20C
 gsti59P/61/pYtIlOw5X4oMUb1um4IXrj0Vx+YccS/q4wCg/xJLx8sP5XwpnqiAskFq/
 Rc6QI5z45Kn0iERq4p+uszaLWnOyOD0oYKQYQdfFuY5ddCmMVAGLTE/fmMRt5KOd+nzf
 DmTjOb0Hm9KyNlTEGtySC3yLtix/p01HAACjAqK6m9UZsvkNJg44ZsD4GtK7NP38Zuca gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnb4t2emm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:57 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGnlI1018076
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnb4t2em0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGkuO5019623;
        Mon, 17 Jan 2022 16:59:56 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw956y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxqJP37880224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F333A4062;
        Mon, 17 Jan 2022 16:59:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 506A6A405C;
        Mon, 17 Jan 2022 16:59:52 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:52 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 05/13] s390x: uv: Add more UV call functions
Date:   Mon, 17 Jan 2022 17:59:41 +0100
Message-Id: <20220117165949.75964-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zCYbc41kobIKJzqBy1PM35LfSd2DRL31
X-Proofpoint-ORIG-GUID: _D9i8jwWDg1cqp1sh_VO5dwNL3j_YFz6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

To manage protected guests we need a few more UV calls:
   * import / export
   * destroy page
   * set SE header
   * set cpu state

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.31.1

