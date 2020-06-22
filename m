Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F38203C69
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgFVQVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729511AbgFVQVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:48 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG2vRJ103279
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysv8tjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:48 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MG3OGj107144
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:48 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysv8thk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:48 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MG1DXl029902;
        Mon, 22 Jun 2020 16:21:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 31sa37seg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLhK148890048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83A4652050;
        Mon, 22 Jun 2020 16:21:43 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 36C9F52051;
        Mon, 22 Jun 2020 16:21:43 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 5/8] lib: Fix a typo and add documentation comments
Date:   Mon, 22 Jun 2020 18:21:38 +0200
Message-Id: <20200622162141.279716-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2
 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 cotscore=-2147483648 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a typo in lib/alloc_phys.h and add documentation comments to all
functions in lib/vmalloc.h

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_phys.h | 2 +-
 lib/vmalloc.h    | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index ea38f91..611aa70 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -39,7 +39,7 @@ extern void phys_alloc_show(void);
 /*
  * phys_alloc_get_unused allocates all remaining memory from the region
  * passed to phys_alloc_init, returning the newly allocated memory's base
- * and top addresses. phys_allo_get_unused will still return base and top
+ * and top addresses. phys_alloc_get_unused will still return base and top
  * when no free memory is remaining, but base will equal top.
  */
 extern void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top);
diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 3658b80..2b563f4 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -3,15 +3,23 @@
 
 #include <asm/page.h>
 
+/* Allocate consecutive virtual pages (without backing) */
 extern void *alloc_vpages(ulong nr);
+/* Allocate one virtual page (without backing) */
 extern void *alloc_vpage(void);
+/* Set the top of the virtual address space */
 extern void init_alloc_vpage(void *top);
+/* Set up the virtual allocator; also sets up the page allocator if needed */
 extern void setup_vm(void);
 
+/* Set up paging */
 extern void *setup_mmu(phys_addr_t top);
+/* Walk the page table and resolve the virtual address to a physical address */
 extern phys_addr_t virt_to_pte_phys(pgd_t *pgtable, void *virt);
+/* Map the virtual address to the physical address for the given page tables */
 extern pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt);
 
+/* Map consecutive physical pages */
 void *vmap(phys_addr_t phys, size_t size);
 
 #endif
-- 
2.26.2

