Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE34EED35
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 14:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345896AbiDAMfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 08:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344958AbiDAMfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 08:35:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7749A4B86F;
        Fri,  1 Apr 2022 05:33:28 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231Bp6wL013022;
        Fri, 1 Apr 2022 12:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i4YXILvisY1Q9PkqgV1NiIoKbchFot1nP11GGaYvMwo=;
 b=cRTtZ8X3B/TibTOODPoKVif5EV2wrwZk+/rh5ifsa/raMKxoNOG8ePONbo6erbiLgX7J
 q7tomExoqN78WRJXQHmvWwHM1+INiUVoMbRoxmhPxJsxMLZfRk4peMBGPsc+rNPoIlXA
 knt+f3HJxzu64ao5vLbyc/BG7/sFdDvelPNlV7ANRzehIYBCAB3dG9GqKQOV5XsTYnoL
 OhU5bx+4f9OgZIsgc6cMes2Et5iB88L52gpcaPjpP/b1Q7T4+ptgzGB6k2XJSKvhumt+
 WL0n2cyVH7luR7zAlgFr/VimcuH0hRMLLmkv95lbUcykjWyH5zZcH10BuJ3stLwE2xiB eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f60vgry5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 12:33:27 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231CVctt030494;
        Fri, 1 Apr 2022 12:33:27 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f60vgry4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 12:33:27 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231CDXZM022041;
        Fri, 1 Apr 2022 12:33:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf931u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 12:33:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231CLH9t45416842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 12:21:18 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D628FA407A;
        Fri,  1 Apr 2022 12:33:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DC7CA4070;
        Fri,  1 Apr 2022 12:33:21 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 12:33:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/2] s390x: gs: move to new header file
Date:   Fri,  1 Apr 2022 14:33:20 +0200
Message-Id: <20220401123321.1714489-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220401123321.1714489-1-nrb@linux.ibm.com>
References: <20220401123321.1714489-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5C6ILTYgWkbQaS61u-IW-nPj9Ie6GgEj
X-Proofpoint-GUID: gME18poY4pLqkiDH1Nujvr6IgkVK_G1j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=832 clxscore=1015
 mlxscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the guarded-storage related structs and instructions to a new
header file because we will also need them for the SIGP store additional
status tests.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/gs.h | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/gs.c     | 54 +--------------------------------------
 2 files changed, 70 insertions(+), 53 deletions(-)
 create mode 100644 lib/s390x/gs.h

diff --git a/lib/s390x/gs.h b/lib/s390x/gs.h
new file mode 100644
index 000000000000..9c94e580b4b9
--- /dev/null
+++ b/lib/s390x/gs.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Guarded storage related definitions
+ *
+ * Copyright 2018 IBM Corp.
+ *
+ * Authors:
+ *    Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <stdint.h>
+
+#ifndef _S390X_GS_H_
+#define _S390X_GS_H_
+
+struct gs_cb {
+	uint64_t reserved;
+	uint64_t gsd;
+	uint64_t gssm;
+	uint64_t gs_epl_a;
+};
+
+struct gs_epl {
+	uint8_t pad1;
+	union {
+		uint8_t gs_eam;
+		struct {
+			uint8_t		: 6;
+			uint8_t e	: 1;
+			uint8_t b	: 1;
+		};
+	};
+	union {
+		uint8_t gs_eci;
+		struct {
+			uint8_t tx	: 1;
+			uint8_t cx	: 1;
+			uint8_t		: 5;
+			uint8_t in	: 1;
+		};
+	};
+	union {
+		uint8_t gs_eai;
+		struct {
+			uint8_t		: 1;
+			uint8_t t	: 1;
+			uint8_t as	: 2;
+			uint8_t ar	: 4;
+		};
+	};
+	uint32_t pad2;
+	uint64_t gs_eha;
+	uint64_t gs_eia;
+	uint64_t gs_eoa;
+	uint64_t gs_eir;
+	uint64_t gs_era;
+};
+
+static inline void load_gs_cb(struct gs_cb *gs_cb)
+{
+	asm volatile(".insn rxy,0xe3000000004d,0,%0" : : "Q" (*gs_cb));
+}
+
+static inline void store_gs_cb(struct gs_cb *gs_cb)
+{
+	asm volatile(".insn rxy,0xe30000000049,0,%0" : : "Q" (*gs_cb));
+}
+
+#endif
diff --git a/s390x/gs.c b/s390x/gs.c
index 7567bb78fecb..4993eb8f43a9 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -13,49 +13,7 @@
 #include <asm/facility.h>
 #include <asm/interrupt.h>
 #include <asm-generic/barrier.h>
-
-struct gs_cb {
-	uint64_t reserved;
-	uint64_t gsd;
-	uint64_t gssm;
-	uint64_t gs_epl_a;
-};
-
-struct gs_epl {
-	uint8_t pad1;
-	union {
-		uint8_t gs_eam;
-		struct {
-			uint8_t		: 6;
-			uint8_t e	: 1;
-			uint8_t b	: 1;
-		};
-	};
-	union {
-		uint8_t gs_eci;
-		struct {
-			uint8_t tx	: 1;
-			uint8_t cx	: 1;
-			uint8_t		: 5;
-			uint8_t in	: 1;
-		};
-	};
-	union {
-		uint8_t gs_eai;
-		struct {
-			uint8_t		: 1;
-			uint8_t t	: 1;
-			uint8_t as	: 2;
-			uint8_t ar	: 4;
-		};
-	};
-	uint32_t pad2;
-	uint64_t gs_eha;
-	uint64_t gs_eia;
-	uint64_t gs_eoa;
-	uint64_t gs_eir;
-	uint64_t gs_era;
-};
+#include <gs.h>
 
 static volatile int guarded = 0;
 static struct gs_cb gs_cb;
@@ -64,16 +22,6 @@ static unsigned long gs_area = 0x2000000;
 
 void gs_handler(struct gs_cb *this_cb);
 
-static inline void load_gs_cb(struct gs_cb *gs_cb)
-{
-	asm volatile(".insn rxy,0xe3000000004d,0,%0" : : "Q" (*gs_cb));
-}
-
-static inline void store_gs_cb(struct gs_cb *gs_cb)
-{
-	asm volatile(".insn rxy,0xe30000000049,0,%0" : : "Q" (*gs_cb));
-}
-
 static inline unsigned long load_guarded(unsigned long *p)
 {
 	unsigned long v;
-- 
2.31.1

