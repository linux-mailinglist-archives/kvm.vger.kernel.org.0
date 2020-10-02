Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39D82816F9
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388077AbgJBPof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:44:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388054AbgJBPoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:44:30 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092FXB2Y080576
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FHprWJ6NbTNrYJGfaHPl3hQhyT1VPi+z1BRjKXkm7CU=;
 b=Jde5UiiMKnwVtckiKqnNqwTlLfqWnDRe4qOhVZaB+cMkGfxW/+7ghlgCtBLT61CQJ4tv
 fwH/UcV5VvJ0vHFJh0jmWwAZv177Vudi8CxIpwScE1DgdCknkUuTfWRhMAKWtBLEtObu
 qteeAML0LR8IAAsdlUjA5XsT+vu/IdOZ4joBY+CG9DQZoC+CxrxyNlkzn63wdLjjJ2os
 tjE2e4xUUUM/QjsbP4yxDlXDtAV4ibAC15xRZlGr1ss4pVx9J9BtftZXhBgaRpJ1ddPR
 TCrrY0eM8gi0O3xVOoe8ezD2kmU1iEq8trWIHRLvFxiaKSZMELWiiU/LKHJACAYup8Ur gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x6m7907b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 02 Oct 2020 11:44:29 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092FXFrm080945
        for <kvm@vger.kernel.org>; Fri, 2 Oct 2020 11:44:29 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x6m7906p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 11:44:29 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092FiQCI027332;
        Fri, 2 Oct 2020 15:44:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33sw983ha3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 15:44:26 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092FiO4Z27918668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 15:44:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49A5142042;
        Fri,  2 Oct 2020 15:44:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE99B42041;
        Fri,  2 Oct 2020 15:44:23 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.90])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 15:44:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests PATCH v2 6/7] lib/alloc.h: remove align_min from struct alloc_ops
Date:   Fri,  2 Oct 2020 17:44:19 +0200
Message-Id: <20201002154420.292134-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_10:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=2 mlxlogscore=949 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove align_min from struct alloc_ops.

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
index 046082a..3c6c4ee 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -320,7 +320,6 @@ void *alloc_page()
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
index 986a34c..b28a390 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -188,7 +188,6 @@ static void vm_free(void *mem)
 static struct alloc_ops vmalloc_ops = {
 	.memalign = vm_memalign,
 	.free = vm_free,
-	.align_min = PAGE_SIZE,
 };
 
 void __attribute__((__weak__)) find_highmem(void)
-- 
2.26.2

