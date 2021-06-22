Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8722F3AFF26
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhFVIYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:24:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230445AbhFVIX4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:56 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M83UZg020751;
        Tue, 22 Jun 2021 04:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QwKP8xw/psgaMga/txQ+lAjNisspP9u4tRIx9LvZikg=;
 b=X6+0cFUdS9YGFwvu3OKN+58i3rZal0c41w9yDCNbx0KqOtgvPxFGSqHgKiVzcf9RZksM
 e8IdaarhA9w9T/uM9MpkCepRkUD1ePga39ImXrpFKSXX8pVYl4d0IjpDh5V9B5ufKv0+
 PtCJQD974rUSjfBPdSFGu3/aWSPgyK3XbUzwhsTezRcsc13y0VH2aPzLmQ4mJvEQhF0i
 DbdA2UVjiXwVMrQm5MmaLsX2UNLyaJgAha7rRSC1eXqEKEPrDCwa/BTfR5KBmsNJSYCw
 4q7bzFrk8DtL7YtlC9DPpxMCL5IDOBAkbKdgU5iGDMCO6IgglQDbYAM5E1a2kHStTgR4 Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8ng5ujx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:41 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M83lJS021935;
        Tue, 22 Jun 2021 04:21:41 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39b8ng5uj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:40 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8D9SQ016038;
        Tue, 22 Jun 2021 08:21:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3998788q7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8KFRo36438464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:20:15 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 978D9AE051;
        Tue, 22 Jun 2021 08:21:35 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1932DAE04D;
        Tue, 22 Jun 2021 08:21:35 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 08/12] s390x: lib: fix pgtable.h
Date:   Tue, 22 Jun 2021 10:20:38 +0200
Message-Id: <20210622082042.13831-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r7knnnYoLsU0y9GvEAg1lNwXSN8qOTHG
X-Proofpoint-ORIG-GUID: YuDjjdtmRdtw8tb5axryxHGYFO1NdaGo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Fix pgtable.h:

* SEGMENT_ENTRY_SFAA had one extra bit set
* pmd entries don't have a length field
* ipte does not need to clear the lower bits
 - clearing the 12 lower bits is technically incorrect, as page tables are
   architecturally aligned to 11 bit addresses (even though the unit tests
   allocate always one full page)
* region table entries should use REGION_ENTRY_TL instead of *_TABLE_LENGTH
 - *_TABLE_LENGTH need to stay, because they should be used for ASCEs

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210611140705.553307-4-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index 277f3480..1a21f175 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -60,7 +60,7 @@
 #define SEGMENT_SHIFT			20
 
 #define SEGMENT_ENTRY_ORIGIN		0xfffffffffffff800UL
-#define SEGMENT_ENTRY_SFAA		0xfffffffffff80000UL
+#define SEGMENT_ENTRY_SFAA		0xfffffffffff00000UL
 #define SEGMENT_ENTRY_AV		0x0000000000010000UL
 #define SEGMENT_ENTRY_ACC		0x000000000000f000UL
 #define SEGMENT_ENTRY_F			0x0000000000000800UL
@@ -143,7 +143,7 @@ static inline p4d_t *p4d_alloc(pgd_t *pgd, unsigned long addr)
 	if (pgd_none(*pgd)) {
 		p4d_t *p4d = p4d_alloc_one();
 		pgd_val(*pgd) = __pa(p4d) | REGION_ENTRY_TT_REGION1 |
-				REGION_TABLE_LENGTH;
+				REGION_ENTRY_TL;
 	}
 	return p4d_offset(pgd, addr);
 }
@@ -163,7 +163,7 @@ static inline pud_t *pud_alloc(p4d_t *p4d, unsigned long addr)
 	if (p4d_none(*p4d)) {
 		pud_t *pud = pud_alloc_one();
 		p4d_val(*p4d) = __pa(pud) | REGION_ENTRY_TT_REGION2 |
-				REGION_TABLE_LENGTH;
+				REGION_ENTRY_TL;
 	}
 	return pud_offset(p4d, addr);
 }
@@ -183,7 +183,7 @@ static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
 	if (pud_none(*pud)) {
 		pmd_t *pmd = pmd_alloc_one();
 		pud_val(*pud) = __pa(pmd) | REGION_ENTRY_TT_REGION3 |
-				REGION_TABLE_LENGTH;
+				REGION_ENTRY_TL;
 	}
 	return pmd_offset(pud, addr);
 }
@@ -202,15 +202,14 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
 {
 	if (pmd_none(*pmd)) {
 		pte_t *pte = pte_alloc_one();
-		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT |
-				SEGMENT_TABLE_LENGTH;
+		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;
 	}
 	return pte_offset(pmd, addr);
 }
 
 static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
 {
-	unsigned long table_origin = (unsigned long)p_pte & PAGE_MASK;
+	unsigned long table_origin = (unsigned long)p_pte;
 
 	asm volatile(
 		"	ipte %0,%1\n"
-- 
2.31.1

