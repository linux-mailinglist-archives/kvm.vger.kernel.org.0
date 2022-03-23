Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724DA4E5712
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245640AbiCWRFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245618AbiCWRFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:05:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B545131D;
        Wed, 23 Mar 2022 10:03:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NFNFgt010482;
        Wed, 23 Mar 2022 17:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+UxZVigsFqkvCffLxp5O+cgTvGmXU+WkFPd8+oWtZf8=;
 b=VrPySJ4qW6gywkDgyn3FhPya/GNKJi/GLVVTQRDFn1XLziPiiMofSfeg+Tr2E2ttnD4l
 nhuvpVmJHNWk3/SzOJpHQZXYu0x8rL+bX/11eJq9/t/vgGSxKJLTi9LSxW5LTbgsM8uz
 qlz7EnyA0g4I9eQiE1XVPETwoYtgfqdJ044DUN6A+ytKDxQAwOv6/8RCzzPtro/7Tz6s
 kIn12Zl2GFEAMX3gEoccw0epeJII/liIXTXYIpZZytPThDn3IOcLFhSwOpCnKYBvFXL5
 TTtalgUBlsaie/XujzVy2rTwkBDF3DBBnpbUJslv9gyFoViVUJYyvg8rO4Ojkdq4+gCQ Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f064x29rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NGtleP013694;
        Wed, 23 Mar 2022 17:03:32 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f064x29qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:32 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NGxORF028072;
        Wed, 23 Mar 2022 17:03:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t97rj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 17:03:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NH3RZn38470090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 17:03:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F07F74C04A;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B23404C059;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 17:03:26 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/9] s390x: gs: move to new header file
Date:   Wed, 23 Mar 2022 18:03:19 +0100
Message-Id: <20220323170325.220848-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220323170325.220848-1-nrb@linux.ibm.com>
References: <20220323170325.220848-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H5uqzk0gSGy1dzx94xGj2tgnTmWHP3zq
X-Proofpoint-ORIG-GUID: uNahCSsQNmURq1LtiuoV_iSSDxRSHwhx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 adultscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 mlxlogscore=811
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230091
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

