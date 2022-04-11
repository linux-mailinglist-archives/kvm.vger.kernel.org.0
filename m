Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3794FBD35
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 15:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346545AbiDKNg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 09:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346513AbiDKNgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 09:36:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4EE13F;
        Mon, 11 Apr 2022 06:34:02 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BDLcY0023874;
        Mon, 11 Apr 2022 13:34:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i4YXILvisY1Q9PkqgV1NiIoKbchFot1nP11GGaYvMwo=;
 b=eZjiuPLHw6y8VhgaAsrmMOc2cAAP5V51ib1aBuPUv1ukMHvbHxtm2VjUREhp7EEMNXfF
 OyApt/rToAyg4iXyUg9zRfpGbo4AF3+tH7yohBQGOne8PU/OfRq5Z0R/f3c6i93r/XJN
 zFrgKyFfRyRmfsY9qVSbW59hVg3LfS2Qs5Iiv69HSTAIfzq2g7haLFrEHeL4LC2j7DJr
 Pjn8m1+NHnlD28acCG/XP1BRG3Hzd0fA/wuBIgKLMyImsnon5pbxuy5/PG2DkiZpzDjc
 VNvg6vdjI0uBPuVWnmQiwfinZ/eXntW1MS93GtusN3vcIFFc/X5TidvvknJt6SK4K4dD hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fcn580a3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:34:01 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BDLuTN024791;
        Mon, 11 Apr 2022 13:34:01 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fcn580a2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:34:01 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BCrfs2004847;
        Mon, 11 Apr 2022 13:33:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3fb1s8u66m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 13:33:59 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BDXu3w32047614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 13:33:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04ED342041;
        Mon, 11 Apr 2022 13:33:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD99E42045;
        Mon, 11 Apr 2022 13:33:55 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 13:33:55 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/2] s390x: gs: move to new header file
Date:   Mon, 11 Apr 2022 15:33:54 +0200
Message-Id: <20220411133355.3040084-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220411133355.3040084-1-nrb@linux.ibm.com>
References: <20220411133355.3040084-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dKFEZwzCEE_wAQVJsXhDJUTLQAImdoBK
X-Proofpoint-ORIG-GUID: pv7J0HaehZGTDOFBhGKWdFWerX9hP5Mu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_05,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0 phishscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 mlxlogscore=792 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
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

