Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B2A322BF3
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 15:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBWOIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 09:08:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45490 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230198AbhBWOIs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 09:08:48 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NE45R5119792;
        Tue, 23 Feb 2021 09:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MIWO16n93tFUyLYO3o+rLOsvn3Pl6OevkKhYOdu8aSg=;
 b=jjPolsWpj1BDy2b8JWJVLXuvOBHj7yzr/IXn6pugQuUuXdDda2CXy6USupL8ezHp521w
 WnpwI/s0jO+rKGDdexCtT3fKDVrkZKdLHZQmt3DCF4zbQGYM4m2EoPg7r6cSQQ8bBGNC
 HQVKt1KPTbprsBqMA1dbC9uOCIuWPu1a/fh7uMY/AAEehiUvEE5dsqk7Nxi7+SyEt7YV
 T/FZ/vmTndlvvmJ2o91I2ceMUZkEptVtO3cbdNSol1Whd564cB5dI5TidTi5OWwpgIa0
 xSlCjmsAcL5Jx9C/CRGibnBpVMKkDR/dxZPd0bFC7Xt7e0XBX4cx7gYYIG9NN7IlWJzc Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkmab2hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:07 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NE4N10121515;
        Tue, 23 Feb 2021 09:08:06 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkmab2h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 09:08:06 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NE3DHU019511;
        Tue, 23 Feb 2021 14:08:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt28anvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:08:04 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NE829c29229496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 14:08:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C73DA407B;
        Tue, 23 Feb 2021 14:08:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E583A407E;
        Tue, 23 Feb 2021 14:08:01 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 14:08:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/5] s390x: lib: improve pgtable.h
Date:   Tue, 23 Feb 2021 15:07:57 +0100
Message-Id: <20210223140759.255670-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210223140759.255670-1-imbrenda@linux.ibm.com>
References: <20210223140759.255670-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_07:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 mlxlogscore=861 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve pgtable.h:

* add macros to check whether a pmd or a pud are large / huge
* add idte functions for pmd, pud, p4d and pgd

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/pgtable.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
index a2ff2d4e..70d4afde 100644
--- a/lib/s390x/asm/pgtable.h
+++ b/lib/s390x/asm/pgtable.h
@@ -100,6 +100,9 @@
 #define pmd_none(entry) (pmd_val(entry) & SEGMENT_ENTRY_I)
 #define pte_none(entry) (pte_val(entry) & PAGE_ENTRY_I)
 
+#define pud_huge(entry)  (pud_val(entry) & REGION3_ENTRY_FC)
+#define pmd_large(entry) (pmd_val(entry) & SEGMENT_ENTRY_FC)
+
 #define pgd_addr(entry) __va(pgd_val(entry) & REGION_ENTRY_ORIGIN)
 #define p4d_addr(entry) __va(p4d_val(entry) & REGION_ENTRY_ORIGIN)
 #define pud_addr(entry) __va(pud_val(entry) & REGION_ENTRY_ORIGIN)
@@ -216,6 +219,34 @@ static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
 		: : "a" (table_origin), "a" (vaddr) : "memory");
 }
 
+static inline void idte(unsigned long table_origin, unsigned long vaddr)
+{
+	vaddr &= SEGMENT_ENTRY_SFAA;
+	asm volatile(
+		"	idte %0,0,%1\n"
+		: : "a" (table_origin), "a" (vaddr) : "memory");
+}
+
+static inline void idte_pmdp(unsigned long vaddr, pmdval_t *pmdp)
+{
+	idte((unsigned long)(pmdp - pmd_index(vaddr)) | ASCE_DT_SEGMENT, vaddr);
+}
+
+static inline void idte_pudp(unsigned long vaddr, pudval_t *pudp)
+{
+	idte((unsigned long)(pudp - pud_index(vaddr)) | ASCE_DT_REGION3, vaddr);
+}
+
+static inline void idte_p4dp(unsigned long vaddr, p4dval_t *p4dp)
+{
+	idte((unsigned long)(p4dp - p4d_index(vaddr)) | ASCE_DT_REGION2, vaddr);
+}
+
+static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
+{
+	idte((unsigned long)(pgdp - pgd_index(vaddr)) | ASCE_DT_REGION1, vaddr);
+}
+
 void configure_dat(int enable);
 
 #endif /* _ASMS390X_PGTABLE_H_ */
-- 
2.26.2

