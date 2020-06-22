Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355CC203C6E
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgFVQVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7496 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729612AbgFVQVw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:52 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG6k8T193662
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31t02g7scy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:50 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MFWbDD194097
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:50 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31t02g7s9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:50 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MG0JQZ003831;
        Mon, 22 Jun 2020 16:21:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 31sa383njh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLgi240632568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C94065204E;
        Mon, 22 Jun 2020 16:21:42 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8511452057;
        Mon, 22 Jun 2020 16:21:42 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 3/8] lib: use PAGE_ALIGN
Date:   Mon, 22 Jun 2020 18:21:36 +0200
Message-Id: <20200622162141.279716-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622162141.279716-1-imbrenda@linux.ibm.com>
References: <20200622162141.279716-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 adultscore=0 clxscore=1015 cotscore=-2147483648 mlxscore=0
 bulkscore=0 mlxlogscore=841 suspectscore=2 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since now PAGE_ALIGN is available in all architectures, start using it in
common code to improve readability.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 5022a31..74b785c 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -41,7 +41,7 @@ void *vmap(phys_addr_t phys, size_t size)
 	void *mem, *p;
 	unsigned pages;
 
-	size = (size + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1);
+	size = PAGE_ALIGN(size);
 	pages = size / PAGE_SIZE;
 	mem = p = alloc_vpages(pages);
 
@@ -60,7 +60,7 @@ static void *vm_memalign(size_t alignment, size_t size)
 	unsigned pages;
 
 	assert(alignment <= PAGE_SIZE);
-	size = (size + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1);
+	size = PAGE_ALIGN(size);
 	pages = size / PAGE_SIZE;
 	mem = p = alloc_vpages(pages);
 	while (pages--) {
@@ -104,7 +104,7 @@ void setup_vm()
 	 * so that it can be used to allocate page tables.
 	 */
 	if (!page_alloc_initialized()) {
-		base = (base + PAGE_SIZE - 1) & -PAGE_SIZE;
+		base = PAGE_ALIGN(base);
 		top = top & -PAGE_SIZE;
 		free_pages(phys_to_virt(base), top - base);
 	}
@@ -113,7 +113,7 @@ void setup_vm()
 	phys_alloc_get_unused(&base, &top);
 	page_root = setup_mmu(top);
 	if (base != top) {
-		base = (base + PAGE_SIZE - 1) & -PAGE_SIZE;
+		base = PAGE_ALIGN(base);
 		top = top & -PAGE_SIZE;
 		free_pages(phys_to_virt(base), top - base);
 	}
-- 
2.26.2

