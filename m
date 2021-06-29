Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA103B7346
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhF2NgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:36:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233665AbhF2NgE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:36:04 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TDS02f108833;
        Tue, 29 Jun 2021 09:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zds/YcGHqVI0AhqjqpwtXYC++z3UOiyRG/5rKyl14jE=;
 b=loE41f0R5ecAJ1w+haIGXRKn5XlDZDqWdFWSqKyxpDxm2Ei0xjNQhAo/VeB5sdKktsqo
 tcBzxWHDlHP/JA8DbVj4rLWRmPKFkJMf1cLucSoS1W41fHPkxVTjNKgHe4KMXcT7I6Lc
 W2mTuoJwg0FIX1d3KE4EYCoFleBHT0A30DerbIlv58sv5cuZvsWVNTtzTS7+A7bXK6eq
 GQlzJQtUofoWeB65kgJwUSHHbQ7csY+KI//MvKgEkBquXk7UrCWzdDt4JIXpzfABT3Sr
 /sDivFanp97iRbnYPr+PiOQax5mMAA80vrjlzwKYAfB/AG92DcGl8A2FIyd5gqHYrg3x BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g4e7r68t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TDTlCU116621;
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g4e7r67k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDT8to027659;
        Tue, 29 Jun 2021 13:33:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 39duv89acs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:33:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDVtZu31850960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:31:55 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1E64A40E5;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EBE6A40E9;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 3/5] lib: s390x: uv: Int type cleanup
Date:   Tue, 29 Jun 2021 13:33:20 +0000
Message-Id: <20210629133322.19193-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629133322.19193-1-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jCjssoXk6bYMXlAAbEB3i8eUlQdMmyHD
X-Proofpoint-ORIG-GUID: 74gReYoJPhI0MqJcTGY2vIX-UL0D-j8B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 spamscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These structs have largely been copied from the kernel so they still
have the old uint short types which we want to avoid in favor of the
uint*_t ones.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 142 +++++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 70 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index dc3e02d..96a2a7e 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -12,6 +12,8 @@
 #ifndef _ASMS390X_UV_H_
 #define _ASMS390X_UV_H_
 
+#include <stdint.h>
+
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
 #define UVC_RC_INV_STATE	0x0003
@@ -68,73 +70,73 @@ enum uv_cmds_inst {
 };
 
 struct uv_cb_header {
-	u16 len;
-	u16 cmd;	/* Command Code */
-	u16 rc;		/* Response Code */
-	u16 rrc;	/* Return Reason Code */
+	uint16_t len;
+	uint16_t cmd;	/* Command Code */
+	uint16_t rc;	/* Response Code */
+	uint16_t rrc;	/* Return Reason Code */
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_init {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 stor_origin;
-	u64 stor_len;
-	u64 reserved28[4];
+	uint64_t reserved08[2];
+	uint64_t stor_origin;
+	uint64_t stor_len;
+	uint64_t reserved28[4];
 
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_qui {
 	struct uv_cb_header header;
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
+	uint64_t reserved08;
+	uint64_t inst_calls_list[4];
+	uint64_t reserved30[2];
+	uint64_t uv_base_stor_len;
+	uint64_t reserved48;
+	uint64_t conf_base_phys_stor_len;
+	uint64_t conf_base_virt_stor_len;
+	uint64_t conf_virt_var_stor_len;
+	uint64_t cpu_stor_len;
+	uint32_t reserved70[3];
+	uint32_t max_num_sec_conf;
+	uint64_t max_guest_stor_addr;
+	uint8_t  reserved88[158 - 136];
+	uint16_t max_guest_cpus;
+	uint8_t  reserveda0[200 - 160];
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_cgc {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 guest_handle;
-	u64 conf_base_stor_origin;
-	u64 conf_var_stor_origin;
-	u64 reserved30;
-	u64 guest_stor_origin;
-	u64 guest_stor_len;
-	u64 guest_sca;
-	u64 guest_asce;
-	u64 reserved60[5];
+	uint64_t reserved08[2];
+	uint64_t guest_handle;
+	uint64_t conf_base_stor_origin;
+	uint64_t conf_var_stor_origin;
+	uint64_t reserved30;
+	uint64_t guest_stor_origin;
+	uint64_t guest_stor_len;
+	uint64_t guest_sca;
+	uint64_t guest_asce;
+	uint64_t reserved60[5];
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_csc {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 cpu_handle;
-	u64 guest_handle;
-	u64 stor_origin;
-	u8  reserved30[6];
-	u16 num;
-	u64 state_origin;
-	u64 reserved[4];
+	uint64_t reserved08[2];
+	uint64_t cpu_handle;
+	uint64_t guest_handle;
+	uint64_t stor_origin;
+	uint8_t  reserved30[6];
+	uint16_t num;
+	uint64_t state_origin;
+	uint64_t reserved[4];
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_unp {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 guest_handle;
-	u64 gaddr;
-	u64 tweak[2];
-	u64 reserved38[3];
+	uint64_t reserved08[2];
+	uint64_t guest_handle;
+	uint64_t gaddr;
+	uint64_t tweak[2];
+	uint64_t reserved38[3];
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 /*
@@ -144,42 +146,42 @@ struct uv_cb_unp {
  */
 struct uv_cb_nodata {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 handle;
-	u64 reserved20[4];
+	uint64_t reserved08[2];
+	uint64_t handle;
+	uint64_t reserved20[4];
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_share {
 	struct uv_cb_header header;
-	u64 reserved08[3];
-	u64 paddr;
-	u64 reserved28;
+	uint64_t reserved08[3];
+	uint64_t paddr;
+	uint64_t reserved28;
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 /* Convert to Secure */
 struct uv_cb_cts {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 guest_handle;
-	u64 gaddr;
+	uint64_t reserved08[2];
+	uint64_t guest_handle;
+	uint64_t gaddr;
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 /* Convert from Secure / Pin Page Shared */
 struct uv_cb_cfs {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 paddr;
+	uint64_t reserved08[2];
+	uint64_t paddr;
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 /* Set Secure Config Parameter */
 struct uv_cb_ssc {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 guest_handle;
-	u64 sec_header_origin;
-	u32 sec_header_len;
-	u32 reserved2c;
-	u64 reserved30[4];
+	uint64_t reserved08[2];
+	uint64_t guest_handle;
+	uint64_t sec_header_origin;
+	uint32_t sec_header_len;
+	uint32_t reserved2c;
+	uint64_t reserved30[4];
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 static inline int uv_call_once(unsigned long r1, unsigned long r2)
@@ -211,7 +213,7 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
-static inline int share(unsigned long addr, u16 cmd)
+static inline int share(unsigned long addr, uint16_t cmd)
 {
 	struct uv_cb_share uvcb = {
 		.header.cmd = cmd,
@@ -220,7 +222,7 @@ static inline int share(unsigned long addr, u16 cmd)
 	};
 	int cc;
 
-	cc = uv_call(0, (u64)&uvcb);
+	cc = uv_call(0, (uint64_t)&uvcb);
 	if (!cc && uvcb.header.rc == UVC_RC_EXECUTED)
 		return 0;
 
@@ -252,11 +254,11 @@ static inline int uv_remove_shared(unsigned long addr)
 
 struct uv_cb_cpu_set_state {
 	struct uv_cb_header header;
-	u64 reserved08[2];
-	u64 cpu_handle;
-	u8  reserved20[7];
-	u8  state;
-	u64 reserved28[5];
+	uint64_t reserved08[2];
+	uint64_t cpu_handle;
+	uint8_t  reserved20[7];
+	uint8_t  state;
+	uint64_t reserved28[5];
 };
 
 #define PV_CPU_STATE_OPR	1
-- 
2.30.2

