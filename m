Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754583B7345
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhF2NgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:36:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233144AbhF2NgE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:36:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TD2cCV041524;
        Tue, 29 Jun 2021 09:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AY/GcUEJfxpc1O/juiL78SMFSiIgDuhdSXyoVeN8KNs=;
 b=Hxlet7pxfyYGcUphi97nLSx449yc6+K8t6eM761ZV2ZL/wswcIRmJJ1IwsrI4yor+XSV
 ixu8ZDiItJMqQrh/txphMuU5LjVYhHO7Q98aNjs6EOLPsVhYLuUBo3ALg4r0GDgNvPkR
 QKUkNxdkWdAZEMb1KGU9ovW79OTsUYHtSC1SFlZobKXzKmVqil1ErIdZz4+A32QKyhHL
 4LYmdq74Ae6xQND8peRyWdxJjJtcHP/GfCCepTXzt2nt1HiJnGR7x6KAlrtsmJqJTbMg
 qph0N4LH4n02tEQJuxmxI8xgJ+EaAptpjMKF6UyruhiSQcnhlhCY1RhF1CYhGBpEbmq1 KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g3fqa1b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TD3vFk049854;
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g3fqa1aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDTbpK027726;
        Tue, 29 Jun 2021 13:33:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 39duv89act-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:33:34 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDVw6927263232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:31:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 14CEEA4101;
        Tue, 29 Jun 2021 13:33:32 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C861CA40FF;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:33:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 4/5] lib: s390x: uv: Add offset comments to uv_query and extend it
Date:   Tue, 29 Jun 2021 13:33:21 +0000
Message-Id: <20210629133322.19193-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210629133322.19193-1-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jjkaY9qJWPQyUnqwa3BmXnaftLBAbN4V
X-Proofpoint-ORIG-GUID: yC1K1t7WTUZAhylEBVhOQDzfKK6IP2X8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290088
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
index 96a2a7e..5ff98b8 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -86,22 +86,23 @@ struct uv_cb_init {
 } __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_qui {
-	struct uv_cb_header header;
-	uint64_t reserved08;
-	uint64_t inst_calls_list[4];
-	uint64_t reserved30[2];
-	uint64_t uv_base_stor_len;
-	uint64_t reserved48;
-	uint64_t conf_base_phys_stor_len;
-	uint64_t conf_base_virt_stor_len;
-	uint64_t conf_virt_var_stor_len;
-	uint64_t cpu_stor_len;
-	uint32_t reserved70[3];
-	uint32_t max_num_sec_conf;
-	uint64_t max_guest_stor_addr;
-	uint8_t  reserved88[158 - 136];
-	uint16_t max_guest_cpus;
-	uint8_t  reserveda0[200 - 160];
+	struct uv_cb_header header;		/* 0x0000 */
+	uint64_t reserved08;			/* 0x0008 */
+	uint64_t inst_calls_list[4];		/* 0x0010 */
+	uint64_t reserved30[2];			/* 0x0030 */
+	uint64_t uv_base_stor_len;		/* 0x0040 */
+	uint64_t reserved48;			/* 0x0048 */
+	uint64_t conf_base_phys_stor_len;	/* 0x0050 */
+	uint64_t conf_base_virt_stor_len;	/* 0x0058 */
+	uint64_t conf_virt_var_stor_len;	/* 0x0060 */
+	uint64_t cpu_stor_len;			/* 0x0068 */
+	uint32_t reserved70[3];			/* 0x0070 */
+	uint32_t max_num_sec_conf;		/* 0x007c */
+	uint64_t max_guest_stor_addr;		/* 0x0080 */
+	uint8_t  reserved88[158 - 136];		/* 0x0088 */
+	uint16_t max_guest_cpus;		/* 0x009e */
+	uint64_t uv_feature_indications;	/* 0x00a0 */
+	uint8_t  reserveda0[200 - 168];		/* 0x00a8 */
 }  __attribute__((packed))  __attribute__((aligned(8)));
 
 struct uv_cb_cgc {
-- 
2.30.2

