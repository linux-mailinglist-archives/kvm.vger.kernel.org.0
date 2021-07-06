Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1243BD6A2
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhGFMld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241574AbhGFMUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:20:48 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166C3qHT177462;
        Tue, 6 Jul 2021 08:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=NqvVLXvaerytO7tB98ja2rofWL74nQ0xiLEA8QSjTsA=;
 b=bUrojBWDWceTIu/B3yfB5etT253pYjEDbB7/IFHoy20JoSWUBVKBNjkYmD0jSmeVKkO+
 9ATLJ5d0Y6pclAK8fIXRXvbFDMT+MKRXebVBNXWo7u3EA+2d/nrRpnxCoi7NOj3oCSlS
 YGYESynn1N1exwmP2lUVaqbSmm9Rt868k7gKW0R3OhFzC2FrKC5iGUbu0DHDvOHlso8j
 QQQ4bb2cp82Xd5jncQ1n5oj6goZpfEqk4jyy8KzVRmDDXf2PE+QRFu50ZUdntahYkS/2
 wjVrr2PBoEP5KR/VRqFvo+4mFJL4DGXF0pDp90FIIB42ZYdedvFLNbbd2fbCudjfa+zc Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mbdwh3ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166C4Hb5180078;
        Tue, 6 Jul 2021 08:18:09 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mbdwh3f1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C2TR7025098;
        Tue, 6 Jul 2021 12:18:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 39jfh88ns7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:18:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CI4sR31982062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:18:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E26F42056;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39ADF42057;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 3/5] lib: s390x: uv: Add offset comments to uv_query and extend it
Date:   Tue,  6 Jul 2021 12:17:55 +0000
Message-Id: <20210706121757.24070-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706121757.24070-1-frankja@linux.ibm.com>
References: <20210706121757.24070-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FZx9GzpYitTGPUGsWiRGMoROx4E6viGP
X-Proofpoint-ORIG-GUID: DBj_zMvRjIUcVQHmSC8RvhsciOcJ6b1N
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The struct is getting longer, let's add offset comments so we know
where we change things when we add struct members.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index dc3e02d..ec10d1c 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -84,22 +84,23 @@ struct uv_cb_init {
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_qui {
-	struct uv_cb_header header;
-	u64 reserved08;
-	u64 inst_calls_list[4];
-	u64 reserved30[2];
-	u64 uv_base_stor_len;
-	u64 reserved48;
-	u64 conf_base_phys_stor_len;
-	u64 conf_base_virt_stor_len;
-	u64 conf_virt_var_stor_len;
-	u64 cpu_stor_len;
-	u32 reserved70[3];
-	u32 max_num_sec_conf;
-	u64 max_guest_stor_addr;
-	u8  reserved88[158 - 136];
-	u16 max_guest_cpus;
-	u8  reserveda0[200 - 160];
+	struct uv_cb_header header;	/* 0x0000 */
+	u64 reserved08;			/* 0x0008 */
+	u64 inst_calls_list[4];		/* 0x0010 */
+	u64 reserved30[2];		/* 0x0030 */
+	u64 uv_base_stor_len;		/* 0x0040 */
+	u64 reserved48;			/* 0x0048 */
+	u64 conf_base_phys_stor_len;	/* 0x0050 */
+	u64 conf_base_virt_stor_len;	/* 0x0058 */
+	u64 conf_virt_var_stor_len;	/* 0x0060 */
+	u64 cpu_stor_len;		/* 0x0068 */
+	u32 reserved70[3];		/* 0x0070 */
+	u32 max_num_sec_conf;		/* 0x007c */
+	u64 max_guest_stor_addr;	/* 0x0080 */
+	u8  reserved88[158 - 136];	/* 0x0088 */
+	uint16_t max_guest_cpus;	/* 0x009e */
+	u64 uv_feature_indications;	/* 0x00a0 */
+	u8  reserveda8[200 - 168];	/* 0x00a8 */
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_cgc {
-- 
2.30.2

