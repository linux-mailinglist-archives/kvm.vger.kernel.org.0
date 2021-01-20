Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201792FD0B1
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbhATMtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:49:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388394AbhATLoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:44:17 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KBYDXS077116;
        Wed, 20 Jan 2021 06:43:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f38t3+EMIJAVt/6OrrruLz2QLaRxfKGo09TbV1r+30c=;
 b=ZqUVMEzGP7xKiwRM9uCF3NLLV9HTMroNKsh3GA12Vm+ChG2JS0LIIm/s0YwqcjUyRtyl
 jXVhRfM1aTNE0SUUIOVXQ5/YB7+6khbS0uQ7VFyV7fLN6PG8QiwTyWS0eq3v8j4qypEN
 IYm7qK/EJzIv9z8dYh8ba3kjeNz16HFr4hZS4QBFa4fQFo0Uz4EsKvH7nIBtliiVmnwt
 VY6W7wj748hCpgxpJGH99pP8ke1020aw4SncP5fb3aUyIFnyBHLEvUO0SxF+9zVrqLxI
 gqDTjY2t9rd7iKBoj9faA9INrBFjHm2MGu4RkSTHIRcAkBfrgukjSUhsZpbnhYmBZQ7B 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366j4bu69n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:35 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KBYxqG081483;
        Wed, 20 Jan 2021 06:43:34 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366j4bu690-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:34 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KBgpAa005129;
        Wed, 20 Jan 2021 11:43:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwrhd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:43:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KBhT1517432942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 11:43:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03B9BAE05F;
        Wed, 20 Jan 2021 11:43:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BEB9AE056;
        Wed, 20 Jan 2021 11:43:28 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 11:43:28 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 01/11] s390x: Move to GPL 2 and SPDX license identifiers
Date:   Wed, 20 Jan 2021 06:41:48 -0500
Message-Id: <20210120114158.104559-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120114158.104559-1-frankja@linux.ibm.com>
References: <20210120114158.104559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the past we had some issues when developers wanted to use code
snippets or constants from the kernel in a test or in the library. To
remedy that the s390x maintainers decided to move all files to GPL
2 (if possible).

At the same time let's move to SPDX identifiers as they are much nicer
to read.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/cmm.c       | 4 +---
 s390x/cpumodel.c  | 4 +---
 s390x/css.c       | 4 +---
 s390x/cstart64.S  | 4 +---
 s390x/diag10.c    | 4 +---
 s390x/diag288.c   | 4 +---
 s390x/diag308.c   | 5 +----
 s390x/emulator.c  | 4 +---
 s390x/gs.c        | 4 +---
 s390x/iep.c       | 4 +---
 s390x/intercept.c | 4 +---
 s390x/pfmf.c      | 4 +---
 s390x/sclp.c      | 4 +---
 s390x/selftest.c  | 4 +---
 s390x/skey.c      | 4 +---
 s390x/skrf.c      | 4 +---
 s390x/smp.c       | 4 +---
 s390x/sthyi.c     | 4 +---
 s390x/sthyi.h     | 4 +---
 s390x/stsi.c      | 4 +---
 s390x/uv-guest.c  | 4 +---
 s390x/vector.c    | 4 +---
 22 files changed, 22 insertions(+), 67 deletions(-)

diff --git a/s390x/cmm.c b/s390x/cmm.c
index fe4d9df..c3f0c93 100644
--- a/s390x/cmm.c
+++ b/s390x/cmm.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * CMM tests (ESSA)
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.vnet.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 116a966..4dd8b96 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Test the known dependencies for facilities
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *    Christian Borntraeger <borntraeger@de.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <asm/facility.h>
diff --git a/s390x/css.c b/s390x/css.c
index ee3bc83..23a7b7c 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Channel Subsystem tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Pierre Morel <pmorel@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 4e51150..cc86fc7 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x startup code
  *
@@ -6,9 +7,6 @@
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <asm/asm-offsets.h>
 #include <asm/sigp.h>
diff --git a/s390x/diag10.c b/s390x/diag10.c
index 7ee8945..579a7a5 100644
--- a/s390x/diag10.c
+++ b/s390x/diag10.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Release pages hypercall tests (DIAG 10)
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.vnet.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/diag288.c b/s390x/diag288.c
index e2ecdc8..e132ff0 100644
--- a/s390x/diag288.c
+++ b/s390x/diag288.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Timer Event DIAG288 test
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/diag308.c b/s390x/diag308.c
index 7fc4abd..c9d6c49 100644
--- a/s390x/diag308.c
+++ b/s390x/diag308.c
@@ -1,11 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Diagnose 0x308 hypercall tests
  *
  * Copyright (c) 2019 Thomas Huth, Red Hat Inc.
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2, or (at
- * your option) any later version.
  */
 
 #include <libcflat.h>
diff --git a/s390x/emulator.c b/s390x/emulator.c
index 70ef51a..b2787a5 100644
--- a/s390x/emulator.c
+++ b/s390x/emulator.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Emulator tests - for s390x CPU instructions that are usually interpreted
  *                  by the hardware
@@ -6,9 +7,6 @@
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/cpacf.h>
diff --git a/s390x/gs.c b/s390x/gs.c
index f685aa9..1376d0e 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Tests guarded storage support.
  *
@@ -6,9 +7,6 @@
  * Authors:
  *    Martin Schwidefsky <schwidefsky@de.ibm.com>
  *    Janosch Frank <frankja@de.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/page.h>
diff --git a/s390x/iep.c b/s390x/iep.c
index 55c01ee..fe167ef 100644
--- a/s390x/iep.c
+++ b/s390x/iep.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Instruction Execution Prevention (IEP) DAT test.
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *	Janosch Frank <frankja@de.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <vmalloc.h>
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 2e38257..cde2f5f 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Interception tests - for s390x CPU instruction that cause a VM exit
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
diff --git a/s390x/pfmf.c b/s390x/pfmf.c
index ac57fe4..2f3cb11 100644
--- a/s390x/pfmf.c
+++ b/s390x/pfmf.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Perform Frame Management Function (pfmf) tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.vnet.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
diff --git a/s390x/sclp.c b/s390x/sclp.c
index 7d92bf3..73d722f 100644
--- a/s390x/sclp.c
+++ b/s390x/sclp.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Service Call tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Claudio Imbrenda <imbrenda@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/selftest.c b/s390x/selftest.c
index eaf5b18..b2fe2e7 100644
--- a/s390x/selftest.c
+++ b/s390x/selftest.c
@@ -1,12 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2017 Red Hat Inc
  *
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <util.h>
diff --git a/s390x/skey.c b/s390x/skey.c
index 86d15e2..2539944 100644
--- a/s390x/skey.c
+++ b/s390x/skey.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Storage key tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.vnet.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
diff --git a/s390x/skrf.c b/s390x/skrf.c
index b19d0f4..57524ba 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Storage key removal facility tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
diff --git a/s390x/smp.c b/s390x/smp.c
index 4ca1dce..b0ece49 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Tests sigp emulation
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *    Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
diff --git a/s390x/sthyi.c b/s390x/sthyi.c
index 68c57cb..d8dfc85 100644
--- a/s390x/sthyi.c
+++ b/s390x/sthyi.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Tests exceptions and data validity for the emulated sthyi
  * instruction.
@@ -6,9 +7,6 @@
  *
  * Authors:
  *    Janosch Frank <frankja@linux.vnet.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/asm-offsets.h>
diff --git a/s390x/sthyi.h b/s390x/sthyi.h
index 06f757f..bbd74c6 100644
--- a/s390x/sthyi.h
+++ b/s390x/sthyi.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * STHYI related flags and structure definitions.
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *    Janosch Frank <frankja@linux.vnet.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _STHYI_H_
 #define _STHYI_H_
diff --git a/s390x/stsi.c b/s390x/stsi.c
index b81cea7..4109b8d 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Store System Information tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
index d47333e..bc947ab 100644
--- a/s390x/uv-guest.c
+++ b/s390x/uv-guest.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Guest Ultravisor Call tests
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/s390x/vector.c b/s390x/vector.c
index 0159ba1..d1b6a57 100644
--- a/s390x/vector.c
+++ b/s390x/vector.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Tests vector instruction support
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *    Janosch Frank <frankja@de.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/page.h>
-- 
2.25.1

