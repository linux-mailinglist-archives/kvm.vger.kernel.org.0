Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62203ED6F2
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhHPNZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:25:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhHPNVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:48 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD3GBt171629;
        Mon, 16 Aug 2021 09:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y+Bu2Z14bdFlSnKPzjSSD1r+xc8mnUAFUGwDBcqSHzk=;
 b=Nuux2KUC4HDPwvnezXtgGh+6BFQPIbVVPQcfFXhLNRiYKAFXx2wHu0b5IMMqUuN830pu
 I/aSgXLpNVMcCQ2IJ0lFxyTuUHVYJjIrGlVFYd2AfS0HmTtCydcpSvx0gfUz/hNaQx54
 BFCkJPIMgcCc/R5V205rMo0b6iqHxtQ129lt39CcazUn4tji/gFKpKPc2snFSAQT0KLI
 NZTeWnX4U2vrkjmNFvbrEIncsqr9EpMRdKQapXOzT27LQUcbml8EQR1IqehxL91whFM+
 4XhQ5QVI5OtTT3vNpYWM1tBNEmV2z8oOUVurM8W95VuhRZCE7bo+Zd7KTnMK6mm7o5gq rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwt85q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:16 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD3OPZ172169;
        Mon, 16 Aug 2021 09:21:15 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwt85p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:15 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDD5hf014229;
        Mon, 16 Aug 2021 13:21:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8awq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDL9jY52756990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91FE511C078;
        Mon, 16 Aug 2021 13:21:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 094DE11C04A;
        Mon, 16 Aug 2021 13:21:09 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 01/11] s390x: Add SPDX and header comments for s390x/* and lib/s390x/*
Date:   Mon, 16 Aug 2021 15:20:44 +0200
Message-Id: <20210816132054.60078-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HndvO2J20JjjOWu7jj6iV4sUPZ1JN4ME
X-Proofpoint-ORIG-GUID: 01DcmZFblI0nzQEyN6eslyK95-CLlVaH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Seems like I missed adding them.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.31.1

