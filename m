Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AC62D5EB0
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389833AbgLJOy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:54:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387518AbgLJOyM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 09:54:12 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEZSWT051413;
        Thu, 10 Dec 2020 09:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g74NcArlqtnhw2bKQpKJeeBYQLchv05Vd5hyOPEVYBs=;
 b=eidl2MwP/gjbHhsEODEyQc/rbbprd+CLVBdE26xZhA7QEknIgkSFUoiIlAZ4sJQUK17Q
 3Wi2JPkZ1WtuPbnEkLKBp24B9tRmzoY2KEFwMGV+nPDn37RbRsnkhAacp/ktabR9DUGo
 O+kDGA2+FnrbZRbx3DZvjlF6EfdRFCZNbOk130QUWihV6KS3xDNXYHOhBZlqLjsdRIBB
 L4UkbqO8UznZ/L6X+SmzjjhB1EVjnbIIOhHpSEHsTRRLEuLg3s3eBQwo2xDFlxJBShwb
 r+G91y/nmtBB/YOjH7L+T+NMN1K8fjAEunxk+AeKP0CjzlerAvrDaJpRVOguiSKNBACc yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bj9m7df3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:53:30 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAErUAJ158982;
        Thu, 10 Dec 2020 09:53:30 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bj9m7db8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:53:30 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAETOuI001279;
        Thu, 10 Dec 2020 14:29:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8rnxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:29:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAEQ1ur32833896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 14:26:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0B0EA405E;
        Thu, 10 Dec 2020 14:26:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89885A405D;
        Thu, 10 Dec 2020 14:26:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Dec 2020 14:26:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 4E3F1E0450; Thu, 10 Dec 2020 15:26:01 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [GIT PULL 2/4] s390/gmap: make gmap memcg aware
Date:   Thu, 10 Dec 2020 15:25:57 +0100
Message-Id: <20201210142600.6771-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210142600.6771-1-borntraeger@de.ibm.com>
References: <20201210142600.6771-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=2 spamscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gmap allocations can be attributed to a process.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/mm/gmap.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index cfb0017f33a7..0160ac97a27d 100644
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

