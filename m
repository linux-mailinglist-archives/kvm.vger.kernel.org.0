Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC19A2F79FC
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbhAOMnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:43:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387463AbhAOMnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:43:23 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCYlsR175440;
        Fri, 15 Jan 2021 07:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ixiqTO3LGJt+CEmpWlnOBc6oIrmT6d/iTOXcPe6348g=;
 b=fHAjMgPe9bL9AlGODodbmVTZBx8TA/3RRdUYIoqyxEj2Yet2JY+FK6aoaTbTyn0ND3q+
 /GbXmLvWJRTJ8Llri+UOLPOmnsfYoxH2jCiizxyHTZRhRGFLmwOHLR2jQ4kODaQwTb2Q
 z6i/INnSElzPTWEtjCg35z9vVX7cP2I4eZrYDxsg+Wbqxi+WPHPi+hWO5TlX/TGB/TSM
 nYkvO+FZLQUSJ+bM6CEqqETJ0BgGeBAWV0u1WPNh6vAEmOKXnH9A9yJzZ+92ZeZ41rUW
 35jAlxXrPqQA0MXVb4CJf6+T6yGLUEJS8/cFjmcNDSGdwr2wczmT3yEuXcxuWtJ0JhLa ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363axcger6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:40 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCYear175070;
        Fri, 15 Jan 2021 07:37:39 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363axcgeq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:39 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FCaQsU022780;
        Fri, 15 Jan 2021 12:37:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448fq7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbZ8Q39780768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:35 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE461AE05A;
        Fri, 15 Jan 2021 12:37:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D252AE059;
        Fri, 15 Jan 2021 12:37:34 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:34 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 06/11] lib/alloc.h: remove align_min from struct alloc_ops
Date:   Fri, 15 Jan 2021 13:37:25 +0100
Message-Id: <20210115123730.381612-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove align_min from struct alloc_ops, since it is no longer used.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/alloc.h      | 1 -
 lib/alloc_page.c | 1 -
 lib/alloc_phys.c | 9 +++++----
 lib/vmalloc.c    | 1 -
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/lib/alloc.h b/lib/alloc.h
index 9b4b634..db90b01 100644
--- a/lib/alloc.h
+++ b/lib/alloc.h
@@ -25,7 +25,6 @@
 struct alloc_ops {
 	void *(*memalign)(size_t alignment, size_t size);
 	void (*free)(void *ptr);
-	size_t align_min;
 };
 
 extern struct alloc_ops *alloc_ops;
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 337a4e0..7d1fa85 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -385,7 +385,6 @@ void *memalign_pages_area(unsigned int area, size_t alignment, size_t size)
 static struct alloc_ops page_alloc_ops = {
 	.memalign = memalign_pages,
 	.free = free_pages,
-	.align_min = PAGE_SIZE,
 };
 
 /*
diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 72e20f7..a4d2bf2 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -29,8 +29,8 @@ static phys_addr_t base, top;
 static void *early_memalign(size_t alignment, size_t size);
 static struct alloc_ops early_alloc_ops = {
 	.memalign = early_memalign,
-	.align_min = DEFAULT_MINIMUM_ALIGNMENT
 };
+static size_t align_min;
 
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
@@ -39,8 +39,7 @@ void phys_alloc_show(void)
 	int i;
 
 	spin_lock(&lock);
-	printf("phys_alloc minimum alignment: %#" PRIx64 "\n",
-		(u64)early_alloc_ops.align_min);
+	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
 	for (i = 0; i < nr_regions; ++i)
 		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
 			(u64)regions[i].base,
@@ -64,7 +63,7 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 {
 	assert(align && !(align & (align - 1)));
 	spin_lock(&lock);
-	early_alloc_ops.align_min = align;
+	align_min = align;
 	spin_unlock(&lock);
 }
 
@@ -83,6 +82,8 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
 		top_safe = MIN(top_safe, 1ULL << 32);
 
 	assert(base < top_safe);
+	if (align < align_min)
+		align = align_min;
 
 	addr = ALIGN(base, align);
 	size += addr - base;
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 6b52790..aa7cc41 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -192,7 +192,6 @@ static void vm_free(void *mem)
 static struct alloc_ops vmalloc_ops = {
 	.memalign = vm_memalign,
 	.free = vm_free,
-	.align_min = PAGE_SIZE,
 };
 
 void __attribute__((__weak__)) find_highmem(void)
-- 
2.26.2

