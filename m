Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2212B6851
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgKQPKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:10:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38544 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729586AbgKQPKc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:10:32 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHF2Akt136725;
        Tue, 17 Nov 2020 10:10:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aETu0jCgErbd6xJboAapP3cuCMs17eRjCxcEDD+/2wg=;
 b=L7wrCHU8nDNe8FpIwN31NOzV+bKSzzGvyXuGRbXzKKHzJdit7KXzChJ2ydJQauUH/kWi
 M9wEOKsEeYkCkMhUmKQJnFTeTcG3WSPshnMZUskVoRwsgL79eXk7rKQ65z25fVdhOILV
 iRnYhZTYwj9lHjFwobiQ3VGcxDONJfYMuxOpuFOmIFrqRVj14dx5SzVxqWQPRN6/D+ZZ
 RgJJNQLbPKasf4ewRc5cBYvIVJAO6g+HtCwGpdHl05g8KOYBLxscajFL2k9t/699QsCh
 DMqU3THpa6oGpIKaKXIxJxuhNYcAFe3I/pPx8/WhT4cadnqEIMiH3+paGPPyiek6osSR Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vbvqtsav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:10:31 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHF2hQu140023;
        Tue, 17 Nov 2020 10:10:31 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vbvqts85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:10:30 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHF6xZm006392;
        Tue, 17 Nov 2020 15:10:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34t6v8b744-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:10:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFAPfk9241162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:10:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA56F11C054;
        Tue, 17 Nov 2020 15:10:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A150311C06F;
        Tue, 17 Nov 2020 15:10:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 17 Nov 2020 15:10:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 5B5BBE23AA; Tue, 17 Nov 2020 16:10:24 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 2/2] s390/gmap: make gmap memcg aware
Date:   Tue, 17 Nov 2020 16:10:23 +0100
Message-Id: <20201117151023.424575-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117151023.424575-1-borntraeger@de.ibm.com>
References: <20201117151023.424575-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=2 priorityscore=1501
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170109
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gmap allocations can be attributed to a process.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 64795d034926..9bb2c7512cd5 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2,7 +2,7 @@
 /*
  *  KVM guest address space mapping code
  *
- *    Copyright IBM Corp. 2007, 2016, 2018
+ *    Copyright IBM Corp. 2007, 2020
  *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
  *		 David Hildenbrand <david@redhat.com>
  *		 Janosch Frank <frankja@linux.vnet.ibm.com>
@@ -56,19 +56,19 @@ static struct gmap *gmap_alloc(unsigned long limit)
 		atype = _ASCE_TYPE_REGION1;
 		etype = _REGION1_ENTRY_EMPTY;
 	}
-	gmap = kzalloc(sizeof(struct gmap), GFP_KERNEL);
+	gmap = kzalloc(sizeof(struct gmap), GFP_KERNEL_ACCOUNT);
 	if (!gmap)
 		goto out;
 	INIT_LIST_HEAD(&gmap->crst_list);
 	INIT_LIST_HEAD(&gmap->children);
 	INIT_LIST_HEAD(&gmap->pt_list);
-	INIT_RADIX_TREE(&gmap->guest_to_host, GFP_KERNEL);
-	INIT_RADIX_TREE(&gmap->host_to_guest, GFP_ATOMIC);
-	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_ATOMIC);
+	INIT_RADIX_TREE(&gmap->guest_to_host, GFP_KERNEL_ACCOUNT);
+	INIT_RADIX_TREE(&gmap->host_to_guest, GFP_ATOMIC | __GFP_ACCOUNT);
+	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_ATOMIC | __GFP_ACCOUNT);
 	spin_lock_init(&gmap->guest_table_lock);
 	spin_lock_init(&gmap->shadow_lock);
 	refcount_set(&gmap->ref_count, 1);
-	page = alloc_pages(GFP_KERNEL, CRST_ALLOC_ORDER);
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		goto out_free;
 	page->index = 0;
@@ -309,7 +309,7 @@ static int gmap_alloc_table(struct gmap *gmap, unsigned long *table,
 	unsigned long *new;
 
 	/* since we dont free the gmap table until gmap_free we can unlock */
-	page = alloc_pages(GFP_KERNEL, CRST_ALLOC_ORDER);
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
 	new = (unsigned long *) page_to_phys(page);
@@ -594,7 +594,7 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 	if (pmd_large(*pmd) && !gmap->mm->context.allow_gmap_hpage_1m)
 		return -EFAULT;
 	/* Link gmap segment table entry location to page table. */
-	rc = radix_tree_preload(GFP_KERNEL);
+	rc = radix_tree_preload(GFP_KERNEL_ACCOUNT);
 	if (rc)
 		return rc;
 	ptl = pmd_lock(mm, pmd);
@@ -1218,11 +1218,11 @@ static int gmap_protect_rmap(struct gmap *sg, unsigned long raddr,
 		vmaddr = __gmap_translate(parent, paddr);
 		if (IS_ERR_VALUE(vmaddr))
 			return vmaddr;
-		rmap = kzalloc(sizeof(*rmap), GFP_KERNEL);
+		rmap = kzalloc(sizeof(*rmap), GFP_KERNEL_ACCOUNT);
 		if (!rmap)
 			return -ENOMEM;
 		rmap->raddr = raddr;
-		rc = radix_tree_preload(GFP_KERNEL);
+		rc = radix_tree_preload(GFP_KERNEL_ACCOUNT);
 		if (rc) {
 			kfree(rmap);
 			return rc;
@@ -1741,7 +1741,7 @@ int gmap_shadow_r2t(struct gmap *sg, unsigned long saddr, unsigned long r2t,
 
 	BUG_ON(!gmap_is_shadow(sg));
 	/* Allocate a shadow region second table */
-	page = alloc_pages(GFP_KERNEL, CRST_ALLOC_ORDER);
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
 	page->index = r2t & _REGION_ENTRY_ORIGIN;
@@ -1825,7 +1825,7 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long saddr, unsigned long r3t,
 
 	BUG_ON(!gmap_is_shadow(sg));
 	/* Allocate a shadow region second table */
-	page = alloc_pages(GFP_KERNEL, CRST_ALLOC_ORDER);
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
 	page->index = r3t & _REGION_ENTRY_ORIGIN;
@@ -1909,7 +1909,7 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 
 	BUG_ON(!gmap_is_shadow(sg) || (sgt & _REGION3_ENTRY_LARGE));
 	/* Allocate a shadow segment table */
-	page = alloc_pages(GFP_KERNEL, CRST_ALLOC_ORDER);
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
 	if (!page)
 		return -ENOMEM;
 	page->index = sgt & _REGION_ENTRY_ORIGIN;
@@ -2116,7 +2116,7 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 	parent = sg->parent;
 	prot = (pte_val(pte) & _PAGE_PROTECT) ? PROT_READ : PROT_WRITE;
 
-	rmap = kzalloc(sizeof(*rmap), GFP_KERNEL);
+	rmap = kzalloc(sizeof(*rmap), GFP_KERNEL_ACCOUNT);
 	if (!rmap)
 		return -ENOMEM;
 	rmap->raddr = (saddr & PAGE_MASK) | _SHADOW_RMAP_PGTABLE;
@@ -2128,7 +2128,7 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 			rc = vmaddr;
 			break;
 		}
-		rc = radix_tree_preload(GFP_KERNEL);
+		rc = radix_tree_preload(GFP_KERNEL_ACCOUNT);
 		if (rc)
 			break;
 		rc = -EAGAIN;
-- 
2.28.0

