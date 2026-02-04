Return-Path: <kvm+bounces-70208-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMurMKlgg2mJlQMAu9opvQ
	(envelope-from <kvm+bounces-70208-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:07:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39E12E7F20
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BF0423063438
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1957828853E;
	Wed,  4 Feb 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N2rYW+j1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292052BEFED;
	Wed,  4 Feb 2026 15:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217388; cv=none; b=pSEgZ/8UauvWdiz2nA5ixkntEE0aiZklWxWZwStzkb+1TxNwoFQapJVrjVoNpAMcz63hcToaiWKrOCH0Qd+jkKRuXxjGzOrV7IUgsziMdjvT6VImFwl+X6reK9wUIwjOTVcQyI01ATRIQ0KNl0ltK2Fe4hYEWT+sVKZmzFeS4pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217388; c=relaxed/simple;
	bh=Frn6hltIyV5WJ2d6pPnm0V60inoBt8b4iK5mJVeSKiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqmbmbfq3lulBwPSCLkSFTflg/Wp8lyFqiFAyBTRxXOgINsyCNBEBkLMZhFRIWpQEAdHrT3O1UcY14wGIEKeSbLvzZjMKFVgKt1fe6Bdo+R0iGpie0KbA18Rp1MJlMb+JD7G733sPVPIamVhepNi3H0/8agXN/TOCp8QHEsF6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N2rYW+j1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 614CPYNr027389;
	Wed, 4 Feb 2026 15:03:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=rv39S/P+MdKrw6xwW
	OVNfixy/froEIPZnW3Fr4nBnwA=; b=N2rYW+j1Fcpd2L0K0j6LwBES6KltAbQj0
	v+XMIOd3oOPtayo2KxjZa1l6QXpRdH/aooCnsRO8OGscdYlbzW/TOV01zD6brj2/
	0ZjO7ht5YFQAfsQ0ItsNXUoxVOqnz/TDV+v00AgxPsUHjy3LhoUHJrtHR0XJ6MIk
	6A5uI4aY5mbJhZ1cjM5DVGwPkqKC6eFW9iKMQR5jmysrAZ2AkEyhxyZQthIN4boK
	TkFymx8CurHNrcmKPBhcqds6/zxWy3K3RYQMr5LugGvFNxv2Hb+TtKX45Edffs2W
	O8ULyEV4mDB/0ukzTvb+ueQxHI9ZjnBQGm63XBQiE384UQZ3cgW1A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175n00e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614CA55B025710;
	Wed, 4 Feb 2026 15:03:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2mwnj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F2xU152887836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:02:59 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CC28B20040;
	Wed,  4 Feb 2026 15:02:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88F452004B;
	Wed,  4 Feb 2026 15:02:59 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:02:59 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 01/29] KVM: s390: Refactor pgste lock and unlock functions
Date: Wed,  4 Feb 2026 16:02:30 +0100
Message-ID: <20260204150259.60425-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260204150259.60425-1-imbrenda@linux.ibm.com>
References: <20260204150259.60425-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RT40z16FDrzUcVCWGl5IxA5XsRdWpMic
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=69835fa8 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=gw90SDbXj9Ny8T8iXsQA:9
X-Proofpoint-GUID: RT40z16FDrzUcVCWGl5IxA5XsRdWpMic
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX7lqqrQJk1mm6
 XubXh4TeTObWSjmCllyvql0HDYcUOnkZA7DTVbDjOiDdX7+3L6LSRzcpB/Tq5dOO4V/Vlpip8s0
 prudWcPAdCdzkb1qvgxul/V0QQYthBH2TAIrBo9c76GrrED39mpWREh5PS5gNegLh8CibFMBUqX
 56q+nqN1U23NB58kYtq+aRbigsA3ormKpXuj+bhjWVBkoIoHOofcwN2W7zuk9dcE4Z/Nzsn97NM
 es7x+kaVWIghM3QRZsHtuuxw1TyhDzuyWp5fnsav8cPmbHryxm/G+Q9JJGtI/nqCLbQfz6+PNaU
 pVbO0w96nuQVIMQ1bD/qBzW+yPSigpSQV/dJvEu77kE1ZgKtZTBWkj0hkU0YZGNDTZLCmha+oTi
 zK+a2kz50gCorbnrIYUQ9lt4GaHVw9+Jjv/fLNggrWM7NB6+VoZi51YA4zFwFPZ/kuBVJqCoeUr
 ofUbRfdC53w1I+xMadw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70208-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 39E12E7F20
X-Rspamd-Action: no action

Move the pgste lock and unlock functions back into mm/pgtable.c and
duplicate them in mm/gmap_helpers.c to avoid function name collisions
later on.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 22 ----------------------
 arch/s390/mm/gmap_helpers.c     | 23 ++++++++++++++++++++++-
 arch/s390/mm/pgtable.c          | 23 ++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index bca9b29778c3..8194a2b12ecf 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -2040,26 +2040,4 @@ static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
 	return res;
 }
 
-static inline pgste_t pgste_get_lock(pte_t *ptep)
-{
-	unsigned long value = 0;
-#ifdef CONFIG_PGSTE
-	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
-
-	do {
-		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
-	} while (value & PGSTE_PCL_BIT);
-	value |= PGSTE_PCL_BIT;
-#endif
-	return __pgste(value);
-}
-
-static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	barrier();
-	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
-#endif
-}
-
 #endif /* _S390_PAGE_H */
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index d41b19925a5a..4fba13675950 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -15,7 +15,6 @@
 #include <linux/pagewalk.h>
 #include <linux/ksm.h>
 #include <asm/gmap_helpers.h>
-#include <asm/pgtable.h>
 
 /**
  * ptep_zap_softleaf_entry() - discard a software leaf entry.
@@ -35,6 +34,28 @@ static void ptep_zap_softleaf_entry(struct mm_struct *mm, softleaf_t entry)
 	free_swap_and_cache(entry);
 }
 
+static inline pgste_t pgste_get_lock(pte_t *ptep)
+{
+	unsigned long value = 0;
+#ifdef CONFIG_PGSTE
+	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
+
+	do {
+		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
+	} while (value & PGSTE_PCL_BIT);
+	value |= PGSTE_PCL_BIT;
+#endif
+	return __pgste(value);
+}
+
+static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
+{
+#ifdef CONFIG_PGSTE
+	barrier();
+	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
+#endif
+}
+
 /**
  * gmap_helper_zap_one_page() - discard a page if it was swapped.
  * @mm: the mm
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 666adcd681ab..08743c1dac2f 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -24,7 +24,6 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
-#include <asm/pgtable.h>
 #include <asm/machine.h>
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
@@ -116,6 +115,28 @@ static inline pte_t ptep_flush_lazy(struct mm_struct *mm,
 	return old;
 }
 
+static inline pgste_t pgste_get_lock(pte_t *ptep)
+{
+	unsigned long value = 0;
+#ifdef CONFIG_PGSTE
+	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
+
+	do {
+		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
+	} while (value & PGSTE_PCL_BIT);
+	value |= PGSTE_PCL_BIT;
+#endif
+	return __pgste(value);
+}
+
+static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
+{
+#ifdef CONFIG_PGSTE
+	barrier();
+	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
+#endif
+}
+
 static inline pgste_t pgste_get(pte_t *ptep)
 {
 	unsigned long pgste = 0;
-- 
2.52.0


