Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D52F79FE
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbhAOMn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:43:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387632AbhAOMn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:43:26 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCXKtV020081;
        Fri, 15 Jan 2021 07:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tK5dFZ/FvkVDsAgZKBc3w31GaRdrflM4u6eauuUUR0A=;
 b=Q4uMwNBBvK/qvzP8jdiFPjypRxRA0LNiR8X3ElVwGp/gR6+duB1/VcIgeXk7WztY2KrL
 48iTnuvD2q10YWC8bnkfrlEhF25syN1TSQ96tWxzCXyW6I0J6P3GcV2GmhNjgKAQPiWU
 zRChI/juVjE5ODoLkWmlny3BAKO3YgnASa+c86vIblCttHTXUuVsnAFYBimYNzscgyuT
 YWs9agG74xwsq1ed1K7qGcPQdH63p8XLNfx+3XJLpc5HwhtabXc4OO+0SJ5WkBVUpIE2
 pVyLTsicAA/bBWjonGgbKQ+eVEAI1EFhS4P2PkRPbPhXvFaO2Lnvwd2vvnaJVPVkpHjZ hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363b1dga35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:44 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCXMM4020194;
        Fri, 15 Jan 2021 07:37:43 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 363b1dga0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:43 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FC8ZLF014115;
        Fri, 15 Jan 2021 12:37:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrdf9ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbXv944499430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B6E8AE051;
        Fri, 15 Jan 2021 12:37:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9CF7AE055;
        Fri, 15 Jan 2021 12:37:32 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 03/11] lib/vmalloc: add some asserts and improvements
Date:   Fri, 15 Jan 2021 13:37:22 +0100
Message-Id: <20210115123730.381612-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 malwarescore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some asserts to make sure the state is consistent.

Simplify and improve the readability of vm_free.

If a NULL pointer is freed, no operation is performed.

Fixes: 3f6fee0d4da4 ("lib/vmalloc: vmalloc support for handling allocation metadata")

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 986a34c..6b52790 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -162,13 +162,16 @@ static void *vm_memalign(size_t alignment, size_t size)
 static void vm_free(void *mem)
 {
 	struct metadata *m;
-	uintptr_t ptr, end;
+	uintptr_t ptr, page, i;
 
+	if (!mem)
+		return;
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
 
@@ -176,13 +179,14 @@ static void vm_free(void *mem)
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

