Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461A0411595
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbhITN1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:27:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239448AbhITN0n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:43 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD46a023914;
        Mon, 20 Sep 2021 09:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hDcxZ4AUCI/G7t344KYgukPVmmSCzYYNk89jZGzSkms=;
 b=XaB4qM50KcADVjivjjgwemZ150Ji7/0gSY8PVpCdoIN0Mgvs/1CY69RhIgV/OgDh92WV
 wYKuWsMmh3mDoVCa+baORYOTCUyO6xVPQ7LNl4QvidHtSIm4e1DARBwY9SaD54zFAaNh
 i/UHKRLUYA2yV+TuNH7KIpF3ubHvV+Hdy6eGr8jlKHuMqCL0h//Go4nxXRbgIGmgzEj6
 sJuZwOnQvQ3FadzT+eSHeksFIQMQlNnFTCIjp9lQQx91wfvafh6WvxS71zvTFGFDZHS3
 LEf056brwj+8RlObSeCuENxPf11T19o4GjhzZge8BCnEA0yUMYIXOAbNTdAKYB+998US ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w699x1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:16 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDEZmO031931;
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5w699x04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6eO029263;
        Mon, 20 Sep 2021 13:25:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3b57cj8ya8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDP6Ou49217852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:25:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6767A4053;
        Mon, 20 Sep 2021 13:25:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CDF1A4072;
        Mon, 20 Sep 2021 13:25:06 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:06 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 06/14] KVM: s390: pv: properly handle page flags for protected guests
Date:   Mon, 20 Sep 2021 15:24:54 +0200
Message-Id: <20210920132502.36111-7-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Juo6mjvIM_vM3zFDfVfhIPzWur2TAI-v
X-Proofpoint-ORIG-GUID: b_Xi-LNKnPetzpjRgFT9itT52r1PzdTt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=991 priorityscore=1501 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce variants of the convert and destroy page functions that also
clear the PG_arch_1 bit used to mark them as secure pages.

The PG_arch_1 flag is always allowed to overindicate; using the new
functions introduced here allows to reduce the extent of overindication
and thus improve performance.

These new functions can only be called on pages for which a reference
is already being held.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  9 ++++++---
 arch/s390/include/asm/uv.h      | 10 ++++++++--
 arch/s390/kernel/uv.c           | 34 ++++++++++++++++++++++++++++++++-
 arch/s390/mm/gmap.c             |  4 +++-
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index dcac7b2df72c..0f1af2232ebe 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1074,8 +1074,9 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	pte_t res;
 
 	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
@@ -1091,8 +1092,9 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 	pte_t res;
 
 	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(vma->vm_mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
@@ -1116,8 +1118,9 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
+	/* At this point the reference through the mapping is still present */
 	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
 	return res;
 }
 
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index b35add51b967..3236293d5a31 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -356,8 +356,9 @@ static inline int is_prot_virt_host(void)
 }
 
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
-int uv_destroy_page(unsigned long paddr);
+int uv_destroy_owned_page(unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
+int uv_convert_owned_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 
 void setup_uv(void);
@@ -367,7 +368,7 @@ void adjust_to_uv_max(unsigned long *vmax);
 static inline void setup_uv(void) {}
 static inline void adjust_to_uv_max(unsigned long *vmax) {}
 
-static inline int uv_destroy_page(unsigned long paddr)
+static inline int uv_destroy_owned_page(unsigned long paddr)
 {
 	return 0;
 }
@@ -376,6 +377,11 @@ static inline int uv_convert_from_secure(unsigned long paddr)
 {
 	return 0;
 }
+
+static inline int uv_convert_owned_from_secure(unsigned long paddr)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 68a8fbafcb9c..05f8bf61d20a 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -115,7 +115,7 @@ static int uv_pin_shared(unsigned long paddr)
  *
  * @paddr: Absolute host address of page to be destroyed
  */
-int uv_destroy_page(unsigned long paddr)
+static int uv_destroy_page(unsigned long paddr)
 {
 	struct uv_cb_cfs uvcb = {
 		.header.cmd = UVC_CMD_DESTR_SEC_STOR,
@@ -135,6 +135,22 @@ int uv_destroy_page(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * The caller must already hold a reference to the page
+ */
+int uv_destroy_owned_page(unsigned long paddr)
+{
+	struct page *page = phys_to_page(paddr);
+	int rc;
+
+	get_page(page);
+	rc = uv_destroy_page(paddr);
+	if (!rc)
+		clear_bit(PG_arch_1, &page->flags);
+	put_page(page);
+	return rc;
+}
+
 /*
  * Requests the Ultravisor to encrypt a guest page and make it
  * accessible to the host for paging (export).
@@ -154,6 +170,22 @@ int uv_convert_from_secure(unsigned long paddr)
 	return 0;
 }
 
+/*
+ * The caller must already hold a reference to the page
+ */
+int uv_convert_owned_from_secure(unsigned long paddr)
+{
+	struct page *page = phys_to_page(paddr);
+	int rc;
+
+	get_page(page);
+	rc = uv_convert_from_secure(paddr);
+	if (!rc)
+		clear_bit(PG_arch_1, &page->flags);
+	put_page(page);
+	return rc;
+}
+
 /*
  * Calculate the expected ref_count for a page that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 5a138f6220c4..38b792ab57f7 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2678,8 +2678,10 @@ static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
 {
 	pte_t pte = READ_ONCE(*ptep);
 
+	/* There is a reference through the mapping */
 	if (pte_present(pte))
-		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
+		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
+
 	return 0;
 }
 
-- 
2.31.1

