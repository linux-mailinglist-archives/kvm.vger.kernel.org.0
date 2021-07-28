Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEC73D8B87
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbhG1KOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:14:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235668AbhG1KOD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:14:03 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SA9R2k107245;
        Wed, 28 Jul 2021 06:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WRRioAVIXLg3uvKZd6H87PZSbnmh69QyaDbvkmzt1ZM=;
 b=p6vLOuUVihqckpP2MdR4lWOkNDObMyClWpmrTh8OSjEP+lV+oc4TKs1D5M19v1rpryU0
 ppww2xQC1FQZrbGU3mniunwvWO2K5kxQB1DElKifKssk3x+jUcA7O837WyN4WcGsBD+1
 0lTvAHZTyHwdwpRXR4z+JWPaxXU3k6I2/tZSTliRAe1Lr7I4P7ONqOQQDjfxUtruy4V8
 zxPlh25bjyfB6AfKIWRDCPTXFKYpQI5hYn9IO4J7lt5oHNhsE4J/Lt0EKcSdB/M4oEid
 axQPIS2bOJxHoGgIUTJw0f948dUmyXCL8pjwHpAXkhHSrZF2l7yCdtHGqTHfQ3sFfQAN 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a31svpk3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:02 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SAA4lE110048;
        Wed, 28 Jul 2021 06:14:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a31svpk2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SADC5C004956;
        Wed, 28 Jul 2021 10:13:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235ygyfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:13:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SADvqO33358122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:13:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06ADD4C062;
        Wed, 28 Jul 2021 10:13:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 934AE4C040;
        Wed, 28 Jul 2021 10:13:56 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:13:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 2/3] s390x: Add SPDX and header comments for the snippets folder
Date:   Wed, 28 Jul 2021 10:13:27 +0000
Message-Id: <20210728101328.51646-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210728101328.51646-1-frankja@linux.ibm.com>
References: <20210728101328.51646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zBDKBMlw69giWxM--RDvez9IQvoFJIUz
X-Proofpoint-GUID: n8Fj9xWt2loO3q9L3Y8oK0ZupYr0MtR8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like I missed adding them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/snippets/c/cstart.S       | 9 +++++++++
 s390x/snippets/c/mvpg-snippet.c | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/s390x/snippets/c/cstart.S b/s390x/snippets/c/cstart.S
index 242568d6..a1754808 100644
--- a/s390x/snippets/c/cstart.S
+++ b/s390x/snippets/c/cstart.S
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Start assembly for snippets
+ *
+ * Copyright (c) 2021 IBM Corp.
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <asm/sigp.h>
 
 .section .init
diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
index c1eb5d77..e55caab4 100644
--- a/s390x/snippets/c/mvpg-snippet.c
+++ b/s390x/snippets/c/mvpg-snippet.c
@@ -1,3 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet used by the mvpg-sie.c test to check SIE PEI intercepts.
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
 #include <libcflat.h>
 
 static inline void force_exit(void)
-- 
2.30.2

