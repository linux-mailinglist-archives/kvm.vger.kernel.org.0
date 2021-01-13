Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC63A2F47CB
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbhAMJmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11380 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbhAMJmW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:22 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9XPpQ007838;
        Wed, 13 Jan 2021 04:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OpoE8Y6bxTLR0nmKeCcXbkDvdT59x8h7/q2maMOCtC0=;
 b=IOFafx5V2oYaNd+lXH2BOJyekgSfMRDxAVB1VJ7R7qp5lp6xmm92Gp6yg+8bHDueXmuc
 iIEo9YzAdKhIfQbydwAtuLytiKR0bql4/OhM84Uvwn4lrr6M1WZez/x1HEdB3K+set1V
 V2bR0Nydb3t8ftUkwVU4D0NaW5ib+EHQPotu9Eaheu+GPMIJpPy6+capKz4yx/Ry5IiQ
 HdF+HPlPmmxJqID6WChWwnoZ5T6K/+K3IJEO4aZOVTeAeH9QNez7af2V5PldS7YF8/O0
 s7iux0nyZpNGNIFY2JyZCj+mEt2zfuoiqm8JRxRWN9TNFFidEHnFzHmv35+tmVYrPmjM Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361wdnsk1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:41 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9XRs1007869;
        Wed, 13 Jan 2021 04:41:40 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361wdnsk0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:40 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9QxQ9019232;
        Wed, 13 Jan 2021 09:41:38 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447vucb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:38 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fZqB31654146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:35 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E924A4040;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AF0BA4053;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:35 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 01/14] s390/mm: Code cleanups
Date:   Wed, 13 Jan 2021 09:41:00 +0000
Message-Id: <20210113094113.133668-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's clean up leftovers before introducing new code.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/mm/gmap.c    | 8 ++++----
 arch/s390/mm/pgtable.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9bb2c7512cd5..f857104ca6c1 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -5,7 +5,7 @@
  *    Copyright IBM Corp. 2007, 2020
  *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
  *		 David Hildenbrand <david@redhat.com>
- *		 Janosch Frank <frankja@linux.vnet.ibm.com>
+ *		 Janosch Frank <frankja@linux.ibm.com>
  */
 
 #include <linux/kernel.h>
@@ -2290,10 +2290,10 @@ static void gmap_pmdp_xchg(struct gmap *gmap, pmd_t *pmdp, pmd_t new,
 	pmdp_notify_gmap(gmap, pmdp, gaddr);
 	pmd_val(new) &= ~_SEGMENT_ENTRY_GMAP_IN;
 	if (MACHINE_HAS_TLB_GUEST)
-		__pmdp_idte(gaddr, (pmd_t *)pmdp, IDTE_GUEST_ASCE, gmap->asce,
+		__pmdp_idte(gaddr, pmdp, IDTE_GUEST_ASCE, gmap->asce,
 			    IDTE_GLOBAL);
 	else if (MACHINE_HAS_IDTE)
-		__pmdp_idte(gaddr, (pmd_t *)pmdp, 0, 0, IDTE_GLOBAL);
+		__pmdp_idte(gaddr, pmdp, 0, 0, IDTE_GLOBAL);
 	else
 		__pmdp_csp(pmdp);
 	*pmdp = new;
@@ -2523,7 +2523,7 @@ static inline void thp_split_mm(struct mm_struct *mm)
  * - This must be called after THP was enabled
  */
 static int __zap_zero_pages(pmd_t *pmd, unsigned long start,
-			   unsigned long end, struct mm_walk *walk)
+			    unsigned long end, struct mm_walk *walk)
 {
 	unsigned long addr;
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 18205f851c24..5915f3b725bc 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -743,7 +743,7 @@ void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
  * Test and reset if a guest page is dirty
  */
 bool ptep_test_and_clear_uc(struct mm_struct *mm, unsigned long addr,
-		       pte_t *ptep)
+			    pte_t *ptep)
 {
 	pgste_t pgste;
 	pte_t pte;
-- 
2.27.0

