Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0B3310F0
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhCHOfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:35:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231325AbhCHOfM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:35:12 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EYvBZ103844;
        Mon, 8 Mar 2021 09:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WAenqBncc9WPpUnhK3jQ1jsbuxh9jvcLPWj6+r8FQBs=;
 b=cjzxOmxWBGoTqSroN9oId8Njf/t2LnKUfga31jaQAWQUj8VGGLj53rP6xVpLWx3bAnga
 xyeFSizwwleo5ifhi+lSrgw/h3NlenIpJo6P/pMmq+7zcaS5UaeVWC5D1edxguCh7beo
 UCQRo55kyWFNtm8D7maEVRJgW4wqbxsKRL4A9RM20lzRrOYRUZN10uGjcxSqGKDuf4fY
 O0q6cBJXgzTSTcIrNnjRoJ2sNreqWI/FEfzSDqZNUc4ndln56bZKNilYedaCzhkHLVUY
 NK/faSQqB0CxvG8lx3VSP/bRRXx8P2cGtxbCc06SbSig0l7BqulqLBg7SmmIC8sJZnQA pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757wwmgfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:35:12 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EZBZD106074;
        Mon, 8 Mar 2021 09:35:11 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3757wwmfma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:35:11 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EWMVY027252;
        Mon, 8 Mar 2021 14:33:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3741c89wfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXg9E46924192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47878A404D;
        Mon,  8 Mar 2021 14:33:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFD14A4053;
        Mon,  8 Mar 2021 14:33:41 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 10/16] s390x: Provide preliminary backtrace support
Date:   Mon,  8 Mar 2021 15:31:41 +0100
Message-Id: <20210308143147.64755-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the stack changes we can finally use -mbackchain and have a
working backtrace.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/stack.c | 20 ++++++++++++++------
 s390x/Makefile    |  1 +
 s390x/macros.S    |  5 +++++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index 0fcd1afb..4cf80dae 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -3,24 +3,32 @@
  * s390x stack implementation
  *
  * Copyright (c) 2017 Red Hat Inc
+ * Copyright 2021 IBM Corp
  *
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
+ *  Janosch Frank <frankja@de.ibm.com>
  */
 #include <libcflat.h>
 #include <stack.h>
+#include <asm/arch_def.h>
 
 int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 {
-	printf("TODO: Implement backtrace_frame(%p, %p, %d) function!\n",
-	       frame, return_addrs, max_depth);
-	return 0;
+	int depth = 0;
+	struct stack_frame *stack = (struct stack_frame *)frame;
+
+	for (depth = 0; stack && depth < max_depth; depth++) {
+		return_addrs[depth] = (void *)stack->grs[8];
+		stack = stack->back_chain;
+	}
+
+	return depth;
 }
 
 int backtrace(const void **return_addrs, int max_depth)
 {
-	printf("TODO: Implement backtrace(%p, %d) function!\n",
-	       return_addrs, max_depth);
-	return 0;
+	return backtrace_frame(__builtin_frame_address(0),
+			       return_addrs, max_depth);
 }
diff --git a/s390x/Makefile b/s390x/Makefile
index f3b0fccf..20bb5683 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
 CFLAGS += -O2
 CFLAGS += -march=zEC12
+CFLAGS += -mbackchain
 CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
diff --git a/s390x/macros.S b/s390x/macros.S
index 11f4397a..d4f41ec4 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -22,6 +22,11 @@
 	lgr     %r2, %r15
 	/* Allocate stack space for called C function, as specified in s390 ELF ABI */
 	slgfi   %r15, 160
+	/*
+	 * Save the address of the interrupt stack into the back chain
+	 * of the called function.
+	 */
+	stg     %r2, STACK_FRAME_INT_BACKCHAIN(%r15)
 	brasl	%r14, \c_func
 	algfi   %r15, 160
 	RESTORE_REGS_STACK
-- 
2.29.2

