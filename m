Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82602DC789
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgLPUNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728694AbgLPUNH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:07 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2g0k174452
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rIWsyPNixR0hWHVge+Rqu3flWU/5ovq2Dy81UKXuBQk=;
 b=b6WmJ2hMWxKc/+b2lRj2utVC3gIUFduQ/q8Ow8NidSqVe2/l6mV5ERSaeevUF6Exwhwn
 DfIdMTRkquaB89gE4gAd2k3USviyCNoXpkEGIG1faEZe3gobPAH3xMGKvn2ONmI6QZmD
 mxsM2FvSCT/VQQlXS+IfBKM9NynV5wzRGTTRbP1CB1j07nRbygF45R5j44jfIJwgvtg5
 9LPSpYBHrUIiioOOkMhZxwy99zfGU/eNSYAcxAWgTbLFK8KLxvYf1+72vVMqE6rkLVTj
 9PtflK6L4+Axkbr34mifN7kP7IB+Q8VHUVDNVxxAJPPJRBU3aojN8EFxQL3kmUo7Xm0h JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fq29bxmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:26 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK2ksm174926
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:26 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fq29bxmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:26 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK87IH016910;
        Wed, 16 Dec 2020 20:12:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 35cng8adtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCLEx26214694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FF2642047;
        Wed, 16 Dec 2020 20:12:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C9104204B;
        Wed, 16 Dec 2020 20:12:21 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 03/12] lib/vmalloc: add some asserts and improvements
Date:   Wed, 16 Dec 2020 21:11:51 +0100
Message-Id: <20201216201200.255172-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some asserts to make sure the state is consistent.

Simplify and improve the readability of vm_free.

Fixes: 3f6fee0d4da4 ("lib/vmalloc: vmalloc support for handling allocation metadata")

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 986a34c..7a49adf 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -162,13 +162,14 @@ static void *vm_memalign(size_t alignment, size_t size)
 static void vm_free(void *mem)
 {
 	struct metadata *m;
-	uintptr_t ptr, end;
+	uintptr_t ptr, page, i;
 
 	/* the pointer is not page-aligned, it was a single-page allocation */
 	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
 		assert(GET_MAGIC(mem) == VM_MAGIC);
-		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
-		free_page(phys_to_virt(ptr));
+		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
+		assert(page);
+		free_page(phys_to_virt(page));
 		return;
 	}
 
@@ -176,13 +177,14 @@ static void vm_free(void *mem)
 	m = GET_METADATA(mem);
 	assert(m->magic == VM_MAGIC);
 	assert(m->npages > 0);
+	assert(m->npages < BIT_ULL(BITS_PER_LONG - PAGE_SHIFT));
 	/* free all the pages including the metadata page */
-	ptr = (uintptr_t)mem - PAGE_SIZE;
-	end = ptr + m->npages * PAGE_SIZE;
-	for ( ; ptr < end; ptr += PAGE_SIZE)
-		free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
-	/* free the last one separately to avoid overflow issues */
-	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
+	ptr = (uintptr_t)m & PAGE_MASK;
+	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
+		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
+		assert(page);
+		free_page(phys_to_virt(page));
+	}
 }
 
 static struct alloc_ops vmalloc_ops = {
-- 
2.26.2

