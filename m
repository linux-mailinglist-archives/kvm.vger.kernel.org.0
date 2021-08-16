Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201AD3ED6DC
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239830AbhHPNYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:24:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239257AbhHPNVt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:49 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD3uga075301;
        Mon, 16 Aug 2021 09:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tZJvGKdKUbaTSg+q9tFuZWBxNzdVq396Q97xI4Q5OGU=;
 b=QvbOlMj6EHezutbJLJDwK9f45XRh0AqjrV0iWazttu+lkX3IQSOabp7Of2ABVhm5CkK+
 rg6oYoqrnWqp4H6yLZOgjzvAhlx3A7GWwNiEYbPKutbCWnzlsDuHvtHdGNPVi3A58OtM
 WKt0WwmfGR1TIpYQNVmHt+YWCsrv+oeyRThCpH0S85xrPwQ8JswyHHhZhyCE2kHV5PPz
 FM1K3D6uMEwpgjhZ7eir6RCCUSk+RK7xYb1GPgfpUY/+5RawBm4mlrCw+/H55nNXLr7i
 VdZvj+1StuFsztADW/ZuH1mf8JxcaNMep0rgMu9+ACo6PH9vSqz4tdYyCwsqAAzwPDcQ Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwbfdme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD4105075693;
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwbfdkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:17 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCoDA020390;
        Mon, 16 Aug 2021 13:21:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8b9yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDLBHK51904870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79F6F11C054;
        Mon, 16 Aug 2021 13:21:11 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1D4211C050;
        Mon, 16 Aug 2021 13:21:10 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:10 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 04/11] s390x: sie: Add sie lib validity handling
Date:   Mon, 16 Aug 2021 15:20:47 +0200
Message-Id: <20210816132054.60078-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uzpN93lgez2z8IvyMN1X39ZpHQdcVLe_
X-Proofpoint-ORIG-GUID: zeLeajdmYkgl19wZ_lFPPDS0qmo-NOW-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start off the SIE lib with validity handling code since that has
the least amount of dependencies to other files.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.c  | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/s390x/sie.h  |  3 +++
 s390x/Makefile   |  1 +
 s390x/mvpg-sie.c |  2 +-
 s390x/sie.c      |  7 +------
 5 files changed, 46 insertions(+), 7 deletions(-)
 create mode 100644 lib/s390x/sie.c

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
new file mode 100644
index 00000000..15ba407c
--- /dev/null
+++ b/lib/s390x/sie.c
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Virtualization library that speeds up managing guests.
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <asm/barrier.h>
+#include <libcflat.h>
+#include <sie.h>
+
+static bool validity_expected;
+static uint16_t vir;		/* Validity interception reason */
+
+void sie_expect_validity(void)
+{
+	validity_expected = true;
+	vir = 0;
+}
+
+void sie_check_validity(uint16_t vir_exp)
+{
+	report(vir_exp == vir, "VALIDITY: %x", vir);
+	vir = 0;
+}
+
+void sie_handle_validity(struct vm *vm)
+{
+	if (vm->sblk->icptcode != ICPT_VALIDITY)
+		return;
+
+	vir = vm->sblk->ipb >> 16;
+
+	if (!validity_expected)
+		report_abort("VALIDITY: %x", vir);
+	validity_expected = false;
+}
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 6ba858a2..7ff98d2d 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -197,5 +197,8 @@ struct vm {
 extern void sie_entry(void);
 extern void sie_exit(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
+void sie_expect_validity(void);
+void sie_check_validity(uint16_t vir_exp);
+void sie_handle_validity(struct vm *vm);
 
 #endif /* _S390X_SIE_H_ */
diff --git a/s390x/Makefile b/s390x/Makefile
index 6565561b..ef8041a6 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -71,6 +71,7 @@ cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
 cflatobjs += lib/s390x/uv.o
+cflatobjs += lib/s390x/sie.o
 
 OBJDIRS += lib/s390x
 
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 5e70f591..2ac91eec 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -39,7 +39,7 @@ static void sie(struct vm *vm)
 
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
-		assert(vm->sblk->icptcode != ICPT_VALIDITY);
+		sie_handle_validity(vm);
 	}
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
diff --git a/s390x/sie.c b/s390x/sie.c
index 134d3c4f..5c798a9e 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -24,17 +24,12 @@ static u8 *guest;
 static u8 *guest_instr;
 static struct vm vm;
 
-static void handle_validity(struct vm *vm)
-{
-	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
-}
 
 static void sie(struct vm *vm)
 {
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
-		if (vm->sblk->icptcode == ICPT_VALIDITY)
-			handle_validity(vm);
+		sie_handle_validity(vm);
 	}
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
-- 
2.31.1

