Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AB92FE98A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 13:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbhAUMCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 07:02:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728425AbhAULTR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 06:19:17 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LB37tA049413;
        Thu, 21 Jan 2021 06:18:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Hro0mPpGi6tu9bwYPEOZQtRdTY4BS/LEH1pxpN8LQYs=;
 b=E6d3M1TOfsD/MXewKtvuGi4Rej8XSFnT5LtYUBsFQA700DG/E1APEUf1vnd3GO0BzyAh
 z9HJ5sohwTEOJfIHxXs2kTZxLBX1onfGVY245KQ5hl9r8PZ2jI5tKEV0/krZGQuWEBC5
 98XD02wcuI9EbobeapsWul5B0D2XgBNfY/c+tyxJ6kwS44CqlEPFZNLWOK4vbchHNBPe
 dvmgVUJ6u3JeEp+bbeNpfIsVMCX1Ab9XxJ1miwCuycCXxOxbxclY26g10jZCEV9i7CGa
 Qk/ShqVsBND8MkDR9WSbhPWVr5mEJUzhDOxQB0jFBWb1vKOXD/zPz1W9IyXZx8Ucw7ee rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3677nf9xt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 06:18:34 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LB4Gwc056155;
        Thu, 21 Jan 2021 06:18:34 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3677nf9xry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 06:18:34 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LBHRqF014530;
        Thu, 21 Jan 2021 11:18:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3668p80tw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 11:18:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LBIT8o40632648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 11:18:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DD35AE058;
        Thu, 21 Jan 2021 11:18:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8172AE053;
        Thu, 21 Jan 2021 11:18:28 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 11:18:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com,
        dmatlack@google.com, seanjc@google.com
Subject: [kvm-unit-tests PATCH v1 2/2] x86: pku: fix the test to work with new allocator
Date:   Thu, 21 Jan 2021 12:18:08 +0100
Message-Id: <20210121111808.619347-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121111808.619347-1-imbrenda@linux.ibm.com>
References: <20210121111808.619347-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 adultscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test used to simply take a chunk of memory and use it, hoping the
memory allocator would never touch it. The memory area used was exactly
at the beginning of the 16M boundary.

The new allocator stores metadata information there, and could cause the
test to fail.

This patch uses the new features of the allocator to properly reserve
a memory block. To make things easier and cleaner, the memory area used
is now smaller and starts at 8M.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 x86/pku.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/pku.c b/x86/pku.c
index 4f6086c..7e8247c 100644
--- a/x86/pku.c
+++ b/x86/pku.c
@@ -1,4 +1,5 @@
 #include "libcflat.h"
+#include <alloc_page.h>
 #include "x86/desc.h"
 #include "x86/processor.h"
 #include "x86/vm.h"
@@ -6,7 +7,7 @@
 
 #define CR0_WP_MASK      (1UL << 16)
 #define PTE_PKEY_BIT     59
-#define USER_BASE        (1 << 24)
+#define USER_BASE        (1 << 23)
 #define USER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + USER_BASE)))
 
 volatile int pf_count = 0;
@@ -77,6 +78,8 @@ int main(int ac, char **av)
     set_intr_alt_stack(14, pf_tss);
     wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_LMA);
 
+    if (reserve_pages(USER_BASE, USER_BASE >> 12))
+        report_abort("Could not reserve memory");
     for (i = 0; i < USER_BASE; i += PAGE_SIZE) {
         *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) &= ~PT_USER_MASK;
         *get_pte(phys_to_virt(read_cr3()), phys_to_virt(i)) |= ((unsigned long)pkey << PTE_PKEY_BIT);
-- 
2.26.2

