Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF123ED6F1
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbhHPNZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:25:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238961AbhHPNVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD3vW4075335;
        Mon, 16 Aug 2021 09:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=94NCyPjcD6kvqHW93VEOia3+OfyMjIy3Ri8Iy7RNRzI=;
 b=sMw/XroHCDnYMOr65LjSSzT/ztbc+wpcTaBSwRSFoHfJbrZYJqQWVgRMxHU8+Jp2W1lL
 xwal8QkeTdxDW9vOrbk30x2NgppLSAGe7jYePaZpOwvGDwfMVF2EvaNWayRkc2di7n2G
 804hlG/m/nkr1M/+lqL1cmVraMA2kdLk+9zD4Fuw3F8sH2toDqjPZtgJ04zH8UWOq0bh
 Km8iQxWnxCLfB/0MVcBSqXkm0BuS1bVdtY6sjJ13scNXHC8Fodrw31zwSIeSNOqppQxR
 TQZCjbP3PmESQ8KzSQ9XXr+Oup03uKRkbEo9v23MPTt8yWjMgbgulcWhBy8fvEZEbPyM GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwbfdm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:16 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GDCokl104242;
        Mon, 16 Aug 2021 09:21:16 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetwbfdk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:16 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDC9wC001551;
        Mon, 16 Aug 2021 13:21:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ae5f8aws1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDLAOW56951250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:21:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0A4D11C05E;
        Mon, 16 Aug 2021 13:21:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52DF811C054;
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
Subject: [kvm-unit-tests GIT PULL 03/11] s390x: Fix my mail address in the headers
Date:   Mon, 16 Aug 2021 15:20:46 +0200
Message-Id: <20210816132054.60078-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8rpkIb9sH8nQ6LUhDuMxQAfhznRSbh1F
X-Proofpoint-ORIG-GUID: 0rLZQ65uMHVKEBmoyMXmW3QLI9wKiv15
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

I used the wrong one once and then copied it over...

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/mem.h | 2 +-
 lib/s390x/mmu.h     | 2 +-
 lib/s390x/stack.c   | 2 +-
 s390x/gs.c          | 2 +-
 s390x/iep.c         | 2 +-
 s390x/vector.c      | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/asm/mem.h b/lib/s390x/asm/mem.h
index 1963cef7..40b22b63 100644
--- a/lib/s390x/asm/mem.h
+++ b/lib/s390x/asm/mem.h
@@ -3,7 +3,7 @@
  * Physical memory management related functions and definitions.
  *
  * Copyright IBM Corp. 2018
- * Author(s): Janosch Frank <frankja@de.ibm.com>
+ * Author(s): Janosch Frank <frankja@linux.ibm.com>
  */
 #ifndef _ASMS390X_MEM_H_
 #define _ASMS390X_MEM_H_
diff --git a/lib/s390x/mmu.h b/lib/s390x/mmu.h
index ab35d782..15f88e4f 100644
--- a/lib/s390x/mmu.h
+++ b/lib/s390x/mmu.h
@@ -5,7 +5,7 @@
  * Copyright (c) 2018 IBM Corp
  *
  * Authors:
- *	Janosch Frank <frankja@de.ibm.com>
+ *	Janosch Frank <frankja@linux.ibm.com>
  */
 #ifndef _S390X_MMU_H_
 #define _S390X_MMU_H_
diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index 4cf80dae..e714e07c 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -8,7 +8,7 @@
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
- *  Janosch Frank <frankja@de.ibm.com>
+ *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
 #include <stack.h>
diff --git a/s390x/gs.c b/s390x/gs.c
index a017a97d..7567bb78 100644
--- a/s390x/gs.c
+++ b/s390x/gs.c
@@ -6,7 +6,7 @@
  *
  * Authors:
  *    Martin Schwidefsky <schwidefsky@de.ibm.com>
- *    Janosch Frank <frankja@de.ibm.com>
+ *    Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
 #include <asm/page.h>
diff --git a/s390x/iep.c b/s390x/iep.c
index 906c77b3..8d5e044b 100644
--- a/s390x/iep.c
+++ b/s390x/iep.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2018 IBM Corp
  *
  * Authors:
- *	Janosch Frank <frankja@de.ibm.com>
+ *	Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
 #include <vmalloc.h>
diff --git a/s390x/vector.c b/s390x/vector.c
index fdb0eee2..c8c14e33 100644
--- a/s390x/vector.c
+++ b/s390x/vector.c
@@ -5,7 +5,7 @@
  * Copyright 2018 IBM Corp.
  *
  * Authors:
- *    Janosch Frank <frankja@de.ibm.com>
+ *    Janosch Frank <frankja@linux.ibm.com>
  */
 #include <libcflat.h>
 #include <asm/page.h>
-- 
2.31.1

