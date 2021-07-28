Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8882D3D8E62
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbhG1M44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:56:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234256AbhG1M4z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 08:56:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SCipZe113910;
        Wed, 28 Jul 2021 08:56:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uDII4y8NUZgDl9hIMjhswCs5sld4I6xc+AICO2QZhPg=;
 b=deS2cQn3s5+UV1o1XHCEju38J8GMVZMph9NVIFjlNi1923hcEkLDFLOV38s5NjTE34k2
 41SLBULkZpqLtxlzDUzWbPjIl62p3QPXSIxXA/5zMIYSb1EfdSENTxg8+KbWjSJAgJMW
 UiPx1CKQsN5WbcNF98XsZ8HsoV9QY/KefJt/DEERAGWdiy7HUhaR2qxCIB5I3J5V0nb5
 3qy08SOlLuL7yyM6SGuKxVfjeLtoGVEGyvs5OnOTxeDp6Ir6RfopuG5gLJFqiTza/icd
 OkCiZNPsJ0TYAUVyrCpVLTb/B33uMY+OOiVTFnzHlqJ5Kwcr+9Ouy8lXl6973Xrq5Mtk lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a37gprd6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 08:56:54 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SCitRe114034;
        Wed, 28 Jul 2021 08:56:54 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a37gprd5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 08:56:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SCqZuI001661;
        Wed, 28 Jul 2021 12:56:51 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235kh2mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 12:56:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SCunP030081482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 12:56:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4109D4C04E;
        Wed, 28 Jul 2021 12:56:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF95F4C062;
        Wed, 28 Jul 2021 12:56:48 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 12:56:48 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2] s390x: Add SPDX and header comments for s390x/* and lib/s390x/*
Date:   Wed, 28 Jul 2021 12:56:43 +0000
Message-Id: <20210728125643.80840-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210728101328.51646-2-frankja@linux.ibm.com>
References: <20210728101328.51646-2-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: InJ0LgrB_H4Fhh-UqYTIO8qEuR8aTEXN
X-Proofpoint-ORIG-GUID: 4Y8vr_w-5h7dJGG9TFjYCD-VJGOZprn0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like I missed adding them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

Dropped the sieve.c change.

---
 lib/s390x/uv.c   |  9 +++++++++
 s390x/mvpg-sie.c |  9 +++++++++
 s390x/sie.c      | 10 ++++++++++
 3 files changed, 28 insertions(+)

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
-- 
2.30.2

