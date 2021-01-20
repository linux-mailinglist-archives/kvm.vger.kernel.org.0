Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E902FD17D
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 14:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbhATMuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:50:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388461AbhATLoW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:44:22 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KBVgxN173916;
        Wed, 20 Jan 2021 06:43:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VuLNCOB0btkndfd+GRohuC4BF2DYdliefL4750zlnXY=;
 b=hMjkDMk6RKcWo2/PscXOS9b5fHurCVk8oyBilu2dEJCJZT+hpf3bg+rxFw4aPBQltI/g
 RZl1gf+u4xNZ4CzhBJPqGiguI9EVPz+XQx0VwK1aNqfB5xA2avLkv5GkDbs/lJmUlISJ
 hJT8RZuTN4MrzhRPK9rQyRiAL2hA9+7TADhK+YlJtcKtF6HAScZbnOQwpsV+Bly/djLz
 7hMsAxuJhxuxg4WHe5dZi4NnjeoYskVExs/51n/DJmCA0AGQtSAvJhZLMO3IPdy7KlUb
 3NaoESmf8ZRRBpoxikdS/szzGJMvH11putf4DVaXBQ1rXegxylEw9WNF8KRlbzQ2dRmo KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366jtphnhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:40 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KBVkbZ174095;
        Wed, 20 Jan 2021 06:43:36 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366jtphngf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 06:43:35 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KBfNgq001723;
        Wed, 20 Jan 2021 11:43:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3668p90910-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 11:43:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KBhUMY48103846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 11:43:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECF85AE065;
        Wed, 20 Jan 2021 11:43:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A2B4AE04D;
        Wed, 20 Jan 2021 11:43:29 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 11:43:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 02/11] s390x: lib: Move to GPL 2 and SPDX license identifiers
Date:   Wed, 20 Jan 2021 06:41:49 -0500
Message-Id: <20210120114158.104559-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120114158.104559-1-frankja@linux.ibm.com>
References: <20210120114158.104559-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the past we had some issues when developers wanted to use code
snippets or constants from the kernel in a test or in the library. To
remedy that the s390x maintainers decided to move all files to GPL 2
(if possible).

At the same time let's move to SPDX identifiers as they are much nicer
to read.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm-offsets.c     | 4 +---
 lib/s390x/asm/arch_def.h    | 4 +---
 lib/s390x/asm/asm-offsets.h | 4 +---
 lib/s390x/asm/barrier.h     | 4 +---
 lib/s390x/asm/cpacf.h       | 1 +
 lib/s390x/asm/facility.h    | 4 +---
 lib/s390x/asm/float.h       | 4 +---
 lib/s390x/asm/interrupt.h   | 4 +---
 lib/s390x/asm/io.h          | 4 +---
 lib/s390x/asm/mem.h         | 4 +---
 lib/s390x/asm/page.h        | 4 +---
 lib/s390x/asm/pgtable.h     | 4 +---
 lib/s390x/asm/sigp.h        | 4 +---
 lib/s390x/asm/spinlock.h    | 4 +---
 lib/s390x/asm/stack.h       | 4 +---
 lib/s390x/asm/time.h        | 4 +---
 lib/s390x/css.h             | 4 +---
 lib/s390x/css_dump.c        | 4 +---
 lib/s390x/css_lib.c         | 4 +---
 lib/s390x/interrupt.c       | 4 +---
 lib/s390x/io.c              | 4 +---
 lib/s390x/mmu.c             | 4 +---
 lib/s390x/mmu.h             | 4 +---
 lib/s390x/sclp-console.c    | 5 +----
 lib/s390x/sclp.c            | 4 +---
 lib/s390x/sclp.h            | 5 +----
 lib/s390x/smp.c             | 4 +---
 lib/s390x/smp.h             | 4 +---
 lib/s390x/stack.c           | 4 +---
 lib/s390x/vm.c              | 3 +--
 lib/s390x/vm.h              | 3 +--
 31 files changed, 31 insertions(+), 90 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 61d2658..ee94ed3 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2017 Red Hat Inc
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <kbuild.h>
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index edc06ef..f3ab830 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2017 Red Hat Inc
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASM_S390X_ARCH_DEF_H_
 #define _ASM_S390X_ARCH_DEF_H_
diff --git a/lib/s390x/asm/asm-offsets.h b/lib/s390x/asm/asm-offsets.h
index a6d7af8..bed7f8e 100644
--- a/lib/s390x/asm/asm-offsets.h
+++ b/lib/s390x/asm/asm-offsets.h
@@ -1,10 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2017 Red Hat Inc
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <generated/asm-offsets.h>
diff --git a/lib/s390x/asm/barrier.h b/lib/s390x/asm/barrier.h
index d862e78..8e2fd6d 100644
--- a/lib/s390x/asm/barrier.h
+++ b/lib/s390x/asm/barrier.h
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
 #ifndef _ASM_S390X_BARRIER_H_
 #define _ASM_S390X_BARRIER_H_
diff --git a/lib/s390x/asm/cpacf.h b/lib/s390x/asm/cpacf.h
index 2146a01..805fcf1 100644
--- a/lib/s390x/asm/cpacf.h
+++ b/lib/s390x/asm/cpacf.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * CP Assist for Cryptographic Functions (CPACF)
  *
diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
index def2705..7828cf8 100644
--- a/lib/s390x/asm/facility.h
+++ b/lib/s390x/asm/facility.h
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2017 Red Hat Inc
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASM_S390X_FACILITY_H_
 #define _ASM_S390X_FACILITY_H_
diff --git a/lib/s390x/asm/float.h b/lib/s390x/asm/float.h
index f61fa62..1367944 100644
--- a/lib/s390x/asm/float.h
+++ b/lib/s390x/asm/float.h
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2018 Red Hat Inc
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASM_S390X_FLOAT_H_
 #define _ASM_S390X_FLOAT_H_
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index 2772e6b..1a2e2cd 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright (c) 2017 Red Hat Inc
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASMS390X_IRQ_H_
 #define _ASMS390X_IRQ_H_
diff --git a/lib/s390x/asm/io.h b/lib/s390x/asm/io.h
index 094dace..1dc6283 100644
--- a/lib/s390x/asm/io.h
+++ b/lib/s390x/asm/io.h
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
 #ifndef _ASMS390X_IO_H_
 #define _ASMS390X_IO_H_
diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index c78bfa2..281390e 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Physical memory management related functions and definitions.
  *
  * Copyright IBM Corp. 2018
  * Author(s): Janosch Frank <frankja@de.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASM_S390_MEM_H
 #define _ASM_S390_MEM_H
diff --git a/lib/s390x/asm/page.h b/lib/s390x/asm/page.h
index bc19154..f130f93 100644
--- a/lib/s390x/asm/page.h
+++ b/lib/s390x/asm/page.h
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
 #ifndef _ASMS390X_PAGE_H_
 #define _ASMS390X_PAGE_H_
diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index e15bee9..277f348 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x page table definitions and functions
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASMS390X_PGTABLE_H_
 #define _ASMS390X_PGTABLE_H_
diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 2d52313..00844d2 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -1,10 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * SIGP related definitions.
  *
  * Copied from the Linux kernel file arch/s390/include/asm/sigp.h
- *
- * This work is licensed under the terms of the GNU GPL, version
- * 2.
  */
 
 #ifndef ASM_S390X_SIGP_H
diff --git a/lib/s390x/asm/spinlock.h b/lib/s390x/asm/spinlock.h
index f7d3982..677d2cd 100644
--- a/lib/s390x/asm/spinlock.h
+++ b/lib/s390x/asm/spinlock.h
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
 #ifndef __ASMS390X_SPINLOCK_H
 #define __ASMS390X_SPINLOCK_H
diff --git a/lib/s390x/asm/stack.h b/lib/s390x/asm/stack.h
index e36d975..909da36 100644
--- a/lib/s390x/asm/stack.h
+++ b/lib/s390x/asm/stack.h
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
 #ifndef _ASMS390X_STACK_H_
 #define _ASMS390X_STACK_H_
diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 7375aa2..0d67f72 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Clock utilities for s390
  *
@@ -6,9 +7,6 @@
  *
  * Copied from the s390/intercept test by:
  *  Pierre Morel <pmorel@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 #ifndef ASM_S390X_TIME_H
 #define ASM_S390X_TIME_H
diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index 221b67c..d10d265 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * CSS definitions
  *
  * Copyright IBM, Corp. 2020
  * Author: Pierre Morel <pmorel@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 
 #ifndef CSS_H
diff --git a/lib/s390x/css_dump.c b/lib/s390x/css_dump.c
index 1266f04..2268086 100644
--- a/lib/s390x/css_dump.c
+++ b/lib/s390x/css_dump.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Channel subsystem structures dumping
  *
@@ -6,9 +7,6 @@
  * Authors:
  *  Pierre Morel <pmorel@linux.ibm.com>
  *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
- *
  * Description:
  * Provides the dumping functions for various structures used by subchannels:
  * - ORB  : Operation request block, describes the I/O operation and points to
diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
index 8e02371..5af6f77 100644
--- a/lib/s390x/css_lib.c
+++ b/lib/s390x/css_lib.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Channel Subsystem tests library
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
 #include <alloc_phys.h>
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index a074505..bac8862 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x interrupt handling
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/barrier.h>
diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index c0f0bf7..1ff0589 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x io implementation
  *
@@ -6,9 +7,6 @@
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <argv.h>
diff --git a/lib/s390x/mmu.c b/lib/s390x/mmu.c
index 912236c..5c51736 100644
--- a/lib/s390x/mmu.c
+++ b/lib/s390x/mmu.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x MMU
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index f5095fa..603f289 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x mmu functions
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *	Janosch Frank <frankja@de.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #ifndef _ASMS390X_MMU_H_
 #define _ASMS390X_MMU_H_
diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
index 6067a1a..fa36a6a 100644
--- a/lib/s390x/sclp-console.c
+++ b/lib/s390x/sclp-console.c
@@ -1,11 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * SCLP ASCII access driver
  *
  * Copyright (c) 2013 Alexander Graf <agraf@suse.de>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or (at
- * your option) any later version. See the COPYING file in the top-level
- * directory.
  */
 
 #include <libcflat.h>
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 4e2ac18..08a4813 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x SCLP driver
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 
 #include <libcflat.h>
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 675f07e..a8f58f5 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * SCLP definitions
  *
@@ -7,10 +8,6 @@
  * and based on the file include/hw/s390x/sclp.h from QEMU
  * Copyright IBM, Corp. 2012
  * Author: Christian Borntraeger <borntraeger@de.ibm.com>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or (at
- * your option) any later version. See the COPYING file in the top-level
- * directory.
  */
 
 #ifndef SCLP_H
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 44b2eb4..423970b 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x smp
  * Based on Linux's arch/s390/kernel/smp.c and
@@ -7,9 +8,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 #include <libcflat.h>
 #include <asm/arch_def.h>
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index d66e39a..67ff16c 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x smp
  *
@@ -5,9 +6,6 @@
  *
  * Authors:
  *  Janosch Frank <frankja@linux.ibm.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2.
  */
 #ifndef SMP_H
 #define SMP_H
diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index cd34b20..0fcd1af 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * s390x stack implementation
  *
@@ -6,9 +7,6 @@
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
- *
- * This code is free software; you can redistribute it and/or modify it
- * under the terms of the GNU Library General Public License version 2.
  */
 #include <libcflat.h>
 #include <stack.h>
diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
index c852713..a5b9286 100644
--- a/lib/s390x/vm.c
+++ b/lib/s390x/vm.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Functions to retrieve VM-specific information
  *
@@ -5,8 +6,6 @@
  *
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
- *
- * SPDX-License-Identifier: LGPL-2.1-or-later
  */
 
 #include <libcflat.h>
diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
index 33008d8..1672276 100644
--- a/lib/s390x/vm.h
+++ b/lib/s390x/vm.h
@@ -1,9 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Functions to retrieve VM-specific information
  *
  * Copyright (c) 2020 Red Hat Inc
- *
- * SPDX-License-Identifier: LGPL-2.1-or-later
  */
 
 #ifndef S390X_VM_H
-- 
2.25.1

