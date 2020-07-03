Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CC4213999
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 13:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgGCLvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 07:51:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62918 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725984AbgGCLvS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 07:51:18 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063BVN14148877
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8d0gyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 07:51:16 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063BVPpi149074
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:16 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8d0gy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 07:51:16 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063BoCfv022100;
        Fri, 3 Jul 2020 11:51:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 31wwr8bddv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 11:51:14 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063BpCXS50266152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 11:51:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FF1211C052;
        Fri,  3 Jul 2020 11:51:12 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B583711C050;
        Fri,  3 Jul 2020 11:51:11 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 11:51:11 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/4] lib/alloc_page: change some parameter types
Date:   Fri,  3 Jul 2020 13:51:07 +0200
Message-Id: <20200703115109.39139-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703115109.39139-1-imbrenda@linux.ibm.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_03:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=2 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 cotscore=-2147483648 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For size parameters, size_t is probably semantically more appropriate
than unsigned long (although they map to the same value).

For order, unsigned long is just too big. Also, get_order returns an
unsigned int anyway.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.h | 6 +++---
 lib/alloc_page.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 6181299..d9aceb7 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -11,10 +11,10 @@
 bool page_alloc_initialized(void);
 void page_alloc_ops_enable(void);
 void *alloc_page(void);
-void *alloc_pages(unsigned long order);
+void *alloc_pages(unsigned int order);
 void free_page(void *page);
-void free_pages(void *mem, unsigned long size);
-void free_pages_by_order(void *mem, unsigned long order);
+void free_pages(void *mem, size_t size);
+void free_pages_by_order(void *mem, unsigned int order);
 unsigned int get_order(size_t size);
 
 #endif
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 8769c3f..f16eaad 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -21,7 +21,7 @@ bool page_alloc_initialized(void)
 	return freelist != 0;
 }
 
-void free_pages(void *mem, unsigned long size)
+void free_pages(void *mem, size_t size)
 {
 	void *old_freelist;
 	void *end;
@@ -53,7 +53,7 @@ void free_pages(void *mem, unsigned long size)
 	spin_unlock(&lock);
 }
 
-void free_pages_by_order(void *mem, unsigned long order)
+void free_pages_by_order(void *mem, unsigned int order)
 {
 	free_pages(mem, 1ul << (order + PAGE_SHIFT));
 }
@@ -79,7 +79,7 @@ void *alloc_page()
  * Allocates (1 << order) physically contiguous and naturally aligned pages.
  * Returns NULL if there's no memory left.
  */
-void *alloc_pages(unsigned long order)
+void *alloc_pages(unsigned int order)
 {
 	/* Generic list traversal. */
 	void *prev;
@@ -150,7 +150,7 @@ void free_page(void *page)
 static void *page_memalign(size_t alignment, size_t size)
 {
 	unsigned long n = ALIGN(size, PAGE_SIZE) >> PAGE_SHIFT;
-	unsigned long order;
+	unsigned int order;
 
 	if (!size)
 		return NULL;
-- 
2.26.2

