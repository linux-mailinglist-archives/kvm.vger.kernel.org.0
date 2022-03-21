Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C0D4E2429
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346271AbiCUKUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346253AbiCUKUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9D52AE1F;
        Mon, 21 Mar 2022 03:19:12 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9qcta026557;
        Mon, 21 Mar 2022 10:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+UxZVigsFqkvCffLxp5O+cgTvGmXU+WkFPd8+oWtZf8=;
 b=c4ZNEmmrHlAv1Va7/ohEVzOkHZbKqkwGtrld+Tffr8HYVyckPbibpAKq7Ee4Dx4rzoIe
 OD7UeTx5YFOUY6GgLtnBlxFFn36Q3asDE2yBejDm9Onh3Rf09vn6nYkt5U9SfLL2eWRS
 jdNHgsJFZ7g7haylJIiRwcmWZuNH7mo4EWppjFumPWO+DixRM6eWReT/Eo57ps0ymJ9g
 bL59fnR8g1DLBtviiQJcKVuN5K7R77v7OWAwg6pHXnHYGC67/fzyPlNA8Jt44n6DJwoa
 J7TZN3E220GeJF8a5+9B275iof/0BZ2LVoeHWJuvJNFuw/jNpb/3PZ+lRNWkaYQWeFpA qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exq48ggkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:11 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22L9xWMj020034;
        Mon, 21 Mar 2022 10:19:11 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exq48ggk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:11 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LADkxU013522;
        Mon, 21 Mar 2022 10:19:09 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3ew6t8k40j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ67G23527750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 221CD11C04A;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF7C011C050;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 3/9] s390x: gs: move to new header file
Date:   Mon, 21 Mar 2022 11:18:58 +0100
Message-Id: <20220321101904.387640-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: R7WxHfv2ZSXLgOKHUKHR_9JxSHvkHZww
X-Proofpoint-GUID: 4vseju_kIAY2XTztoEhmupbiG2XZJPvF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=810 clxscore=1015
 lowpriorityscore=0 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the guarded-storage related structs and instructions to a new
header file because we will also need them for the SIGP store additional
status tests in smp.c.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/gs.h | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/gs.c     | 65 +---------------------------------------
 2 files changed, 81 insertions(+), 64 deletions(-)
 create mode 100644 lib/s390x/gs.h

diff --git a/lib/s390x/gs.h b/lib/s390x/gs.h
new file mode 100644
index 000000000000..e28fa4e1b893
--- /dev/null
+++ b/lib/s390x/gs.h
@@ -0,0 +1,80 @@
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
+static inline unsigned long load_guarded(unsigned long *p)
+{
+	unsigned long v;
+
+	asm(".insn rxy,0xe3000000004c, %0,%1"
+	    : "=d" (v)
+	    : "m" (*p)
+	    : "r14", "memory");
+	return v;
+}
+
+#endif
diff --git a/s390x/gs.c b/s390x/gs.c
index 7567bb78fecb..248f387abf1b 100644
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
@@ -64,27 +22,6 @@ static unsigned long gs_area = 0x2000000;
 
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
-static inline unsigned long load_guarded(unsigned long *p)
-{
-	unsigned long v;
-
-	asm(".insn rxy,0xe3000000004c, %0,%1"
-	    : "=d" (v)
-	    : "m" (*p)
-	    : "r14", "memory");
-	return v;
-}
-
 /* guarded-storage event handler and finally it calls gs_handler */
 extern void gs_handler_asm(void);
 	asm(".globl gs_handler_asm\n"
-- 
2.31.1

