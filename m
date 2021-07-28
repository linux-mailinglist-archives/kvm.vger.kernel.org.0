Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9953D8B86
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhG1KOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:14:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1752 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235647AbhG1KOD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:14:03 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SA4nhH154421;
        Wed, 28 Jul 2021 06:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=T6/CzPrO2rXGAcWx6gN6hAOUDmPJX0on1qVvyR45lLc=;
 b=HK6FljJCrf563IbEMHR1RIIEvsorHgbl3ya2DUvagbH/UF1n81H+v0C9yM60dQPit4BS
 rt111rhhNrw2o6S6LFGBKIOEY5bH4yF76W8W2HmT2FDElGxKk1eNI5otc/2l8evoTwgs
 w6p6ZNO6Zn8jSLOVbge2RlOZuHU81t0eHKkA1lLp00e/bX/tP2sDNmPezNICvsXQCmjr
 khYaPbcjpBo/esqQppl+mzeRcmIEp7Di59fJMedk4BjnJi9kYauf+emXs7g/uQTA+WOq
 ThZm9GeWpKxoQ2gWxwirWcs0/Uwo3NqniYYyz3FxJqjcbI2hcTK31C3PXZ0IkhQUNsQL DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a33jfcnm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:01 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SA4rPc154827;
        Wed, 28 Jul 2021 06:14:00 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a33jfcnk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:00 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SACeQY001423;
        Wed, 28 Jul 2021 10:13:59 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3a235xrmus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:13:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SABHu624183262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:11:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 804E14C04A;
        Wed, 28 Jul 2021 10:13:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FBF84C040;
        Wed, 28 Jul 2021 10:13:56 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:13:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 1/3] s390x: Add SPDX and header comments for s390x/* and lib/s390x/*
Date:   Wed, 28 Jul 2021 10:13:26 +0000
Message-Id: <20210728101328.51646-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210728101328.51646-1-frankja@linux.ibm.com>
References: <20210728101328.51646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bOtjI5cvBvQAQNIKefNAKYeQv4MlpA1T
X-Proofpoint-ORIG-GUID: K4vzamW3Gq0kHSRADsBde_epc4BFEaOu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like I missed adding them.

The s390x/sieve.c one is a bit of a head scratcher since it came with
the first commit but I assume it's lpgl2-only since that's what the
COPYRIGHT file said then.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/uv.c   |  9 +++++++++
 s390x/mvpg-sie.c |  9 +++++++++
 s390x/sie.c      | 10 ++++++++++
 x86/sieve.c      |  5 +++++
 4 files changed, 33 insertions(+)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 0d8c141c..fd9de944 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Ultravisor related functionality
+ *
+ * Copyright 2020 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <libcflat.h>
 #include <bitops.h>
 #include <alloc.h>
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 9bcd15a2..5e70f591 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Tests mvpg SIE partial execution intercepts.
+ *
+ * Copyright 2021 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
 #include <asm-generic/barrier.h>
diff --git a/s390x/sie.c b/s390x/sie.c
index cfc746f3..134d3c4f 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -1,3 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Tests SIE diagnose intercepts.
+ * Mainly used as a template for SIE tests.
+ *
+ * Copyright 2021 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
 #include <asm/arch_def.h>
diff --git a/x86/sieve.c b/x86/sieve.c
index 8150f2d9..b89d5f80 100644
--- a/x86/sieve.c
+++ b/x86/sieve.c
@@ -1,3 +1,8 @@
+/* SPDX-License-Identifier: LGPL-2.0-only */
+/*
+ * Implementation of the sieve of Eratosthenes
+ * Calculation and memory intensive workload for general stress testing.
+ */
 #include "alloc.h"
 #include "libcflat.h"
 
-- 
2.30.2

