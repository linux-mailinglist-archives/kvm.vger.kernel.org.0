Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB17A42BCC9
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 12:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhJMKaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 06:30:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35560 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239318AbhJMKaI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 06:30:08 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D7ZEQU021891;
        Wed, 13 Oct 2021 06:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1hVbRLecG0cvYdyAOrYjMRyped4YUoRe32NAcAioErg=;
 b=YAUx9MAkDI4fuJ+jd896qkUGBwjFRaXiZUsAQ0cZI411sg0hryNVV80ki24iYcmQvWP4
 SfXAN8cKi9tqnOpFtQEsCIRdm/NZ1AnujrRJGuCQQRDPoPBhc51N7dA7A4FEeJgk2CTv
 iSb2QwGbm8RKbE5kXzFgcyUO9VOkSlmcriB33u9DcEzqbNe30cxf9jPtioqXXcEkoFjT
 Aum30qRJ+ogmLJUObPsOb0JUz79Jpbl/8stJGmh+y+wfOoMM3G4ixO0m1lXwQYiAW+7n
 eZFfivPyJt/0FVckc+QQtG1aVcG2X0TOAZYW0uquVZpj86C79Mj1G6URL2rFI5WwspTC VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnr79f3v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:28:05 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19D8gdWH019279;
        Wed, 13 Oct 2021 06:28:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bnr79f3uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 06:28:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19DAHUIt015983;
        Wed, 13 Oct 2021 10:28:02 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3bk2qa9n23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 10:28:02 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19DARqml54788580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Oct 2021 10:27:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41853A406B;
        Wed, 13 Oct 2021 10:27:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7E7A4040;
        Wed, 13 Oct 2021 10:27:48 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Oct 2021 10:27:47 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/2] lib: s390x: snippet.h: Add a few constants that will make our life easier
Date:   Wed, 13 Oct 2021 10:27:22 +0000
Message-Id: <20211013102722.17160-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013102722.17160-1-frankja@linux.ibm.com>
References: <20211013102722.17160-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jyY-GY0pe1pI6bN-0H-zXHUoNpw5hpFc
X-Proofpoint-ORIG-GUID: dVT3YGn7yRQsO5vfmBjW-4zOU93iwMt9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110130068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The variable names for the snippet objects are of gigantic length so
let's define a few macros to make them easier to read.

Also add a standard PSW which should be used to start the snippet.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/snippet.h | 40 ++++++++++++++++++++++++++++++++++++++++
 s390x/mvpg-sie.c    | 13 ++++++-------
 2 files changed, 46 insertions(+), 7 deletions(-)
 create mode 100644 lib/s390x/snippet.h

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
new file mode 100644
index 00000000..9ead4fe3
--- /dev/null
+++ b/lib/s390x/snippet.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet definitions
+ *
+ * Copyright IBM, Corp. 2021
+ * Author: Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#ifndef _S390X_SNIPPET_H_
+#define _S390X_SNIPPET_H_
+
+/* This macro cuts down the length of the pointers to snippets */
+#define SNIPPET_NAME_START(type, file) \
+	_binary_s390x_snippets_##type##_##file##_gbin_start
+#define SNIPPET_NAME_END(type, file) \
+	_binary_s390x_snippets_##type##_##file##_gbin_end
+
+/* Returns the length of the snippet */
+#define SNIPPET_LEN(type, file) \
+	(uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file)
+
+/*
+ * C snippet instructions start at 0x4000 due to the prefix and the
+ * stack being before that.
+ */
+#define SNIPPET_C_ENTRY_ADDR 0x4000
+/* ASM snippets only have the prefix and hence start at 0x2000 */
+#define SNIPPET_ASM_ENTRY_ADDR 0x2000
+
+/* Standard entry PSWs for snippets which can simply be copied into the guest PSW */
+static const struct psw snippet_c_psw = {
+	.mask = PSW_MASK_64,
+	.addr = SNIPPET_C_ENTRY_ADDR,
+};
+
+static const struct psw snippet_asm_psw = {
+	.mask = PSW_MASK_64,
+	.addr = SNIPPET_ASM_ENTRY_ADDR,
+};
+#endif
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 5adcec1e..46170d02 100644
--- a/s390x/mvpg-sie.c
+++ b/s390x/mvpg-sie.c
@@ -19,6 +19,7 @@
 #include <vm.h>
 #include <sclp.h>
 #include <sie.h>
+#include <snippet.h>
 
 static u8 *guest;
 static struct vm vm;
@@ -27,8 +28,8 @@ static uint8_t *src;
 static uint8_t *dst;
 static uint8_t *cmp;
 
-extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
-extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
+extern const char SNIPPET_NAME_START(c, mvpg_snippet)[];
+extern const char SNIPPET_NAME_END(c, mvpg_snippet)[];
 int binary_size;
 
 static void test_mvpg_pei(void)
@@ -77,10 +78,9 @@ static void test_mvpg_pei(void)
 
 static void test_mvpg(void)
 {
-	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_end -
-			   (uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_start);
+	int binary_size = SNIPPET_LEN(c, mvpg_snippet);
 
-	memcpy(guest, _binary_s390x_snippets_c_mvpg_snippet_gbin_start, binary_size);
+	memcpy(guest, SNIPPET_NAME_START(c, mvpg_snippet), binary_size);
 	memset(src, 0x42, PAGE_SIZE);
 	memset(dst, 0x43, PAGE_SIZE);
 	sie(&vm);
@@ -96,8 +96,7 @@ static void setup_guest(void)
 
 	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
 
-	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
-	vm.sblk->gpsw.mask = PSW_MASK_64;
+	vm.sblk->gpsw = snippet_c_psw;
 	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
 	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
 	vm.sblk->eca = ECA_MVPGI;
-- 
2.30.2

