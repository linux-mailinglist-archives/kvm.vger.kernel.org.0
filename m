Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363053D8B88
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 12:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhG1KOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 06:14:05 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231392AbhG1KOE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 06:14:04 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SA92Xf020977;
        Wed, 28 Jul 2021 06:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UgAVpsGwHapdSwi5xvEYmKK+0W5sxq9IyBy0pnemQ3E=;
 b=PE1o31qkGRRDNx3bnOu/gjSMwK4paoWyRixTW/f6gQaEiDJW78JELVu5fA6FsS8eJ5un
 x4M6cLr4SIr9fa0yzICyvmWrBkMFo2/zrSL+qE29tneaCxASTXJ/2y0r8pvm6mYeT2fA
 lTRRHqQLiCeE2CkINoeKlnaeqETwnVTEbJz8gIlJe4oAh4W4A4VgcD7N/+WkieiMK9uc
 WSRec4awegl3OxomeeOPJRApi3wys0/ZpRFkU+450u9ms/d2R5uCfMNjkU5NYFsaXLVT
 vG29DOFbfTB2u4xMZM0XT9T/J5J0QxFtWd11FTp4tqOY7W/mFiyix7DZ6dJ0nfSYeOEp 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a333x46tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:02 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SA9Yev026751;
        Wed, 28 Jul 2021 06:14:01 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3a333x46t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 06:14:01 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SAD9YY027452;
        Wed, 28 Jul 2021 10:14:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3a235krmrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:13:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SADvE733358126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 10:13:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C6F14C059;
        Wed, 28 Jul 2021 10:13:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17BCF4C040;
        Wed, 28 Jul 2021 10:13:57 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 10:13:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 3/3] s390x: Fix my mail address in the headers
Date:   Wed, 28 Jul 2021 10:13:28 +0000
Message-Id: <20210728101328.51646-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210728101328.51646-1-frankja@linux.ibm.com>
References: <20210728101328.51646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kzeumPzKfkktDUcTAGVSeQivCIf7ugTv
X-Proofpoint-ORIG-GUID: Hp9ytAGM0Dc-Xe4emcxUM-HVszKoLkDt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I used the wrong one once and then copied it over...

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.30.2

