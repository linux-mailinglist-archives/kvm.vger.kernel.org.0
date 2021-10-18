Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A90431964
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhJRMkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231774AbhJRMkX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:23 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICINTX005992;
        Mon, 18 Oct 2021 08:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rk3Dh9GVoFD6oyJPdjESikhaO1+FeVZe/Bo/O7xyBYA=;
 b=mzmE7WHOr34umRFpJG70jeYbKa8GN2A6tN0QvJm20lCF7LqA/nmUIQvNNWZvfsH1hFn6
 iHdYCwME9kz6Heb9OHLb2knKynypdopX/pK4TfmB4zVCgiPEtvg3/yDUnn18oeoJpjef
 bZBQ4QLgsbOnIebD/vlSJKqfTsHpbez3es8KXwEmXLcbzlHX0cRf9/j9GbVcHjE2EAQ7
 pxyIK4P2yBahNVMabzHSuZfMeJgmEe/6+ZucHlD6UuTTnXLgHyHQmloKRGsMmHE9k7Ej
 MjhnFKK+QRcAtrYkSBGNEEh0Ji3LiYZK/yx0LodNYGMrO/8GQJ+gh9uPNkbVNvICESdC vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs2n8gj6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:12 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19IBvWdY003311;
        Mon, 18 Oct 2021 08:38:12 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs2n8gj61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:11 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc1LS024837;
        Mon, 18 Oct 2021 12:38:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3bqpc9cx4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc6WF5505654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5392452057;
        Mon, 18 Oct 2021 12:38:06 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D9BB652054;
        Mon, 18 Oct 2021 12:38:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 16/17] lib: s390x: snippet.h: Add a few constants that will make our life easier
Date:   Mon, 18 Oct 2021 14:26:34 +0200
Message-Id: <20211018122635.53614-17-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GHw23U_S2Tn2DFykAA9bMAR4cz710ROm
X-Proofpoint-ORIG-GUID: UBGVXfhsokF5Aqthy_D_R0D5OOVR-1Uh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The variable names for the snippet objects are of gigantic length so
let's define a few macros to make them easier to read.

Also add a standard PSW which should be used to start the snippet.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/snippet.h | 34 ++++++++++++++++++++++++++++++++++
 s390x/mvpg-sie.c    | 13 ++++++-------
 2 files changed, 40 insertions(+), 7 deletions(-)
 create mode 100644 lib/s390x/snippet.h

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
new file mode 100644
index 00000000..8e4765f8
--- /dev/null
+++ b/lib/s390x/snippet.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Snippet definitions
+ *
+ * Copyright IBM Corp. 2021
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
+	((uintptr_t)SNIPPET_NAME_END(type, file) - (uintptr_t)SNIPPET_NAME_START(type, file))
+
+/*
+ * C snippet instructions start at 0x4000 due to the prefix and the
+ * stack being before that. ASM snippets don't strictly need a stack
+ * but keeping the starting address the same means less code.
+ */
+#define SNIPPET_ENTRY_ADDR 0x4000
+
+/* Standard entry PSWs for snippets which can simply be copied into the guest PSW */
+static const struct psw snippet_psw = {
+	.mask = PSW_MASK_64,
+	.addr = SNIPPET_ENTRY_ADDR,
+};
+#endif
diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
index 5adcec1e..d526069d 100644
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
+	vm.sblk->gpsw = snippet_psw;
 	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
 	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
 	vm.sblk->eca = ECA_MVPGI;
-- 
2.31.1

