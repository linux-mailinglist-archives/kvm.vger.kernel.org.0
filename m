Return-Path: <kvm+bounces-70731-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMEMMyJQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70731-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:34:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C1C11C827
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8F2123007211
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39BAB381709;
	Tue, 10 Feb 2026 15:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m4OJ4KDg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE962ED159;
	Tue, 10 Feb 2026 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737669; cv=none; b=uxPnVPMNNVU94LLbhDPT04R/c9W/ChSA70ihilG7XlJjNtTtH5JdyJYYTmqkT6pgfMMOD1ihp3A4avafrJie61nldWA6jWaRVDcgRNWtWwGxR4d2SXNYg+9VCZ2YWZJbQwofMaeXgrpPo7u2Jf1681p43inzuksQo/6yIk3clnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737669; c=relaxed/simple;
	bh=60muwHQpdJbJvA4hVkVooOTmRLS3UGj1TrUrqP6qlwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJUUm0jq3elfJ1IZsLBhxjOtLucowmfZScQ2dEr5tLNgQuXSMpcJkWuWU0KA8DsHmy1T1J4icyRuEyxQBPkPsdSII0czLSdo4PodmZ5WKg/yn48cHxJGinH9Au8U6XPZydxFVZZ75XG6SunsJqWCBHvymJyR6uTJyFfMAC8F4fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m4OJ4KDg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ACE8j2626186;
	Tue, 10 Feb 2026 15:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dd/GQ3Sm4MVZx+7Uf
	NL4349XEoHH8L3U+u6yHniCta4=; b=m4OJ4KDg4qXUdDGy+23EeaPDIH0ZAiXdb
	57r86SLf4os1mvgRbMJuY0rDnaS8ic+y9FrkUbSywV1RNwwnPdYyLkMq3CiBptx2
	9otHDSqzs3/XI4HtJu46mJ9UgOCDQblLJoxjVS6WFBFdRSywV6Js2gK94UKM+1zL
	aDqFedRoRf4WClYSqWpYxM1rvmFuLfpRpnZuHmJUcM4P3QCMZ7n2dw3doHIE6J7A
	QI3w9DJ3aUJGweOovB6+AE22ZkuoXksJDlm45O/I1rSLk6cJu2rlnXoOZMEyhQt1
	fdZNXvA6t6kLi4yJPfaoYaWh68yHZBw9PnaX+LJRUK1nyUO+YDpWg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wtska-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEk30d001407;
	Tue, 10 Feb 2026 15:34:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1veq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYJJA37093868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D3F820043;
	Tue, 10 Feb 2026 15:34:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FE6620040;
	Tue, 10 Feb 2026 15:34:18 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:18 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 02/36] KVM: s390: Refactor pgste lock and unlock functions
Date: Tue, 10 Feb 2026 16:33:43 +0100
Message-ID: <20260210153417.77403-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698b4fff cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=gw90SDbXj9Ny8T8iXsQA:9
X-Proofpoint-GUID: V8v-CTxnYzawGDPdK61L70ahTK-CaAiM
X-Proofpoint-ORIG-GUID: V8v-CTxnYzawGDPdK61L70ahTK-CaAiM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX4z4WG67+DT7x
 fZHq33AzZVQxfZZ/za1sGBoRBE0bIjmk5q9aVuRTYzFz6DDfSG85uireKeTKM+oojm9p3Coz5et
 iyxcTtqDNaHRue2yzkpqKay07PXKu3h+TtJe0FoHFzvJAWNqgNo2recf1fjVpzmJsoV0cwCXUUb
 FktJvR1wo9b+Gin65aAuub/7t6kFoip33ywKtZwalI2BNk8IXlYLTVvh+MEP1aRJgvOuwJXaV55
 UAoA0KtsDFdrJ/iRlvJqWkBK7cpRq9kTcyTZJSyitp33co4IYQTwmp6FSWW2LCd4/h8QB3gsZfA
 e4ytm1YodTtBBVPHgl6Fy3qNUf6KojcZniBBhpRXpZfXD/0BsQLRAjLObLlk1Vb1we+XLeXalzh
 8DWfWwyOxska3D6TgALMrL3uWj8+utHZ4km9pByP/cV5EB1oy74s90rg/MA5dHl4S1uxQ1RbZRY
 k2xk5eW7pFuqjHxpIDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70731-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E0C1C11C827
X-Rspamd-Action: no action

Move the pgste lock and unlock functions back into mm/pgtable.c and
duplicate them in mm/gmap_helpers.c to avoid function name collisions
later on.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0


