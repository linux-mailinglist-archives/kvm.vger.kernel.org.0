Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9913E2DC78B
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgLPUNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63234 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728694AbgLPUNI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:08 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2gEx138194
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=12nMh1wtvEAgafG++AUrXPE+5WXvMsrsbgxwZh4QeDU=;
 b=GsoJaJitmzHOGauOIeUD7StxSYOiRK+W48OcoFbf5lCAD+beYo8cl8gKo7MHHrrvvE6R
 lsNC1sdJpZwkidNPPai1sYk6IaqHyCKwHAkJctFpWH+NuuN7lHfoupiakNezMclCDR55
 NaFpMbNJHq22svoTxoErgOk704EqAx+9DKDrOhcQg4iDIi5SYDcpRoXPXXfLVEoe4Qud
 /38lfZ7ZmI/n+ZEw3xDRunJ/a6CEys68FTN2VDmC2Bq2VwL60oEH5KJdt0lKwKjSqXa0
 g/mtrZKmlnMqWNhV+HGYcDgJuilWxKL2zhDc9VelULcGiXebAT9yyOrhZG4RCut0EQa1 LQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fqeku4gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:28 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK3rJh143314
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:27 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fqeku4g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:27 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK8xYm024982;
        Wed, 16 Dec 2020 20:12:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 35cng84n0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:25 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCN7031392140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:23 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0076A42042;
        Wed, 16 Dec 2020 20:12:23 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FB4E42047;
        Wed, 16 Dec 2020 20:12:22 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 06/12] lib/alloc.h: remove align_min from struct alloc_ops
Date:   Wed, 16 Dec 2020 21:11:54 +0100
Message-Id: <20201216201200.255172-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxlogscore=989 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove align_min from struct alloc_ops, since it is no longer used.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
index 8d2700d..b1cdf21 100644
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
index 7a49adf..e146162 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -190,7 +190,6 @@ static void vm_free(void *mem)
 static struct alloc_ops vmalloc_ops = {
 	.memalign = vm_memalign,
 	.free = vm_free,
-	.align_min = PAGE_SIZE,
 };
 
 void __attribute__((__weak__)) find_highmem(void)
-- 
2.26.2

