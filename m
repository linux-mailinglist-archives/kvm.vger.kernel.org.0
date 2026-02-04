Return-Path: <kvm+bounces-70223-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCABNPZhg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70223-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:12:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 49584E81FC
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:12:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 526B4302BDEF
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCCA8426D13;
	Wed,  4 Feb 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CvLOwiiq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86462423A97;
	Wed,  4 Feb 2026 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217395; cv=none; b=hwc08xKHQitOdW2XwK4sQ3Ceiexuwks2RZtCoT65kCPGgX/dr8XAMl5POuid7hfZxCA17f1rUP38OkdcMOl2LTfqZoG32HNm9EHJGq0rTAh/daeWaBk7glZVnWgNqvhw/RwgXkM3Bk9sJlkzKdxtPXiTfZJaaCYBYNGUXAs1odA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217395; c=relaxed/simple;
	bh=4wZErfrKNssXMqg/WlH8N5QlgSfcmfywFXurpRnUSvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htYEDalorcHGq68p1PjqBtubHOg/0fW+8UhIOlJXl8DN9DNH4PUiWLpHK4P7zotMPDuSyphFIr4bMGLKZm2gBg9HdfKbYgCk5BpOIEdI6mUMQLpulEU/cSQKw9TlL7BoRsUdsGWdaHv2aUyiLz09Kx98EqYmackC/oShFjivZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CvLOwiiq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613NLpuM030016;
	Wed, 4 Feb 2026 15:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=f7RVWpRk5Z8PWWgWS
	Ty+nNh0Azc8F0Cuhx8493suI6E=; b=CvLOwiiqOaoKAEpyzoE5dSgXTz6jInQ7N
	Zdm98iOvNwqw6SJKxzJkJULyoELNNLQClDiaUcaMwv3mAMvtL00qYtYvn4PzXrr8
	EAr2fD9GnoXh/S1tqm4+TXkyDvUpZT5DsqmlEglZuOxBF9nPsrPMTcgw7+QESBWP
	5KFSo3jkTxPjyVXoYWuHS6L8ztTl25sWISUyIx5YYGakPPDyW1UtyZFRmDqB3lvI
	OUwzeSxncnpPbT8YhYdQO/+eBXNHZZk88st+xpXV7B5XHsdM1FiURuuNE02P4XHN
	Y7K2pBOeLslZimlQvIkZX2zbh+UTCU7Cn6YQAA4TS0lG8gQ49LHSQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6jg30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:08 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614DeYFr027353;
	Wed, 4 Feb 2026 15:03:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1dcra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F337m30015836
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA1952004E;
	Wed,  4 Feb 2026 15:03:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98FB520043;
	Wed,  4 Feb 2026 15:03:03 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:03 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 14/29] KVM: s390: KVM page table management functions: clear and replace
Date: Wed,  4 Feb 2026 16:02:43 +0100
Message-ID: <20260204150259.60425-15-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: SNtu0RNwXuEnMEwR51Yry21m_zV598uX
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=69835fac cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cTj5uL8xXfUXbJxEK6wA:9
X-Proofpoint-ORIG-GUID: SNtu0RNwXuEnMEwR51Yry21m_zV598uX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX/hE1RxFRBRX9
 rP+AirjfmMJJSihW5O0SWBWlzjTNJk4BkIDQDNU3CsTqchaeq/SYLf23hWeuXGpyJj8Lc4GE1An
 CdMFouiEyXA0nBKnN/3F/uAbAOhKrOsADnc7gRd+qURfLxfmcbBNlL/GAtCUN1Gps+6Q/735HGk
 ZDgzJChq+4KHTx+9JO5B5pLPGz/ZuJHBd0L/mnCNFaP6KuCWkPls7ZsXvDmHPLHt0DHDN5ywW5Z
 6NkvyBBeoDRSWaqiJ0iSBwhPsDNj5x7F00Sv82TDeMVzxWroBnLyO0FgqnYmN86ITyG4tAX098i
 0frgXgDkhWLazyDc1a0EUWT8JgHYhW/gV7uuzYWxm6kkHFE0HcNJMjOJHU1FpD1/udWTWe0zWsj
 sq5TDsHPZ9Gn/ExS1ggpP+l2VRxcVxTFCvIKPAZl6LpTPfdJOl12U/FHBo2O3fsI+CkIbNIEYuY
 Q5lX/68WHsOgXy4z2Kw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602040113
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70223-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pgste.gr:url,linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 49584E81FC
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to clear, replace or exchange DAT table
entries.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 115 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  40 +++++++++++++++
 2 files changed, 155 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index c324a27f379f..e38b1a139fbb 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -101,3 +101,118 @@ void dat_free_level(struct crst_table *table, bool owns_ptes)
 	}
 	dat_free_crst(table);
 }
+
+/**
+ * dat_crstep_xchg() - Exchange a gmap CRSTE with another.
+ * @crstep: Pointer to the CRST entry
+ * @new: Replacement entry.
+ * @gfn: The affected guest address.
+ * @asce: The ASCE of the address space.
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ */
+void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce)
+{
+	if (crstep->h.i) {
+		WRITE_ONCE(*crstep, new);
+		return;
+	} else if (cpu_has_edat2()) {
+		crdte_crste(crstep, *crstep, new, gfn, asce);
+		return;
+	}
+
+	if (machine_has_tlb_guest())
+		idte_crste(crstep, gfn, IDTE_GUEST_ASCE, asce, IDTE_GLOBAL);
+	else
+		idte_crste(crstep, gfn, 0, NULL_ASCE, IDTE_GLOBAL);
+	WRITE_ONCE(*crstep, new);
+}
+
+/**
+ * dat_crstep_xchg_atomic() - Atomically exchange a gmap CRSTE with another.
+ * @crstep: Pointer to the CRST entry.
+ * @old: Expected old value.
+ * @new: Replacement entry.
+ * @gfn: The affected guest address.
+ * @asce: The asce of the address space.
+ *
+ * This function is needed to atomically exchange a CRSTE that potentially
+ * maps a prefix area, without having to invalidate it inbetween.
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ *
+ * Return: %true if the exchange was successful.
+ */
+bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
+			    union asce asce)
+{
+	if (old.h.i)
+		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
+	if (cpu_has_edat2())
+		return crdte_crste(crstep, old, new, gfn, asce);
+	return cspg_crste(crstep, old, new);
+}
+
+static void dat_set_storage_key_from_pgste(union pte pte, union pgste pgste)
+{
+	union skey nkey = { .acc = pgste.acc, .fp = pgste.fp };
+
+	page_set_storage_key(pte_origin(pte), nkey.skey, 0);
+}
+
+static void dat_move_storage_key(union pte old, union pte new)
+{
+	page_set_storage_key(pte_origin(new), page_get_storage_key(pte_origin(old)), 1);
+}
+
+static union pgste dat_save_storage_key_into_pgste(union pte pte, union pgste pgste)
+{
+	union skey skey;
+
+	skey.skey = page_get_storage_key(pte_origin(pte));
+
+	pgste.acc = skey.acc;
+	pgste.fp = skey.fp;
+	pgste.gr |= skey.r;
+	pgste.gc |= skey.c;
+
+	return pgste;
+}
+
+union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, gfn_t gfn,
+			    union asce asce, bool uses_skeys)
+{
+	union pte old = READ_ONCE(*ptep);
+
+	/* Updating only the software bits while holding the pgste lock. */
+	if (!((ptep->val ^ new.val) & ~_PAGE_SW_BITS)) {
+		WRITE_ONCE(ptep->swbyte, new.swbyte);
+		return pgste;
+	}
+
+	if (!old.h.i) {
+		unsigned long opts = IPTE_GUEST_ASCE | (pgste.nodat ? IPTE_NODAT : 0);
+
+		if (machine_has_tlb_guest())
+			__ptep_ipte(gfn_to_gpa(gfn), (void *)ptep, opts, asce.val, IPTE_GLOBAL);
+		else
+			__ptep_ipte(gfn_to_gpa(gfn), (void *)ptep, 0, 0, IPTE_GLOBAL);
+	}
+
+	if (uses_skeys) {
+		if (old.h.i && !new.h.i)
+			/* Invalid to valid: restore storage keys from PGSTE. */
+			dat_set_storage_key_from_pgste(new, pgste);
+		else if (!old.h.i && new.h.i)
+			/* Valid to invalid: save storage keys to PGSTE. */
+			pgste = dat_save_storage_key_into_pgste(old, pgste);
+		else if (!old.h.i && !new.h.i)
+			/* Valid to valid: move storage keys. */
+			if (old.h.pfra != new.h.pfra)
+				dat_move_storage_key(old, new);
+		/* Invalid to invalid: nothing to do. */
+	}
+
+	WRITE_ONCE(*ptep, new);
+	return pgste;
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index a053f0d49bae..ee070d18bd36 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -430,6 +430,12 @@ struct kvm_s390_mmu_cache {
 	short int n_rmaps;
 };
 
+union pgste __must_check __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new,
+					 gfn_t gfn, union asce asce, bool uses_skeys);
+bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
+			    union asce asce);
+void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce);
+
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
 
@@ -757,6 +763,21 @@ static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
 	WRITE_ONCE(*pgste_of(ptep), pgste);
 }
 
+static inline void dat_ptep_xchg(union pte *ptep, union pte new, gfn_t gfn, union asce asce,
+				 bool has_skeys)
+{
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste = __dat_ptep_xchg(ptep, pgste, new, gfn, asce, has_skeys);
+	pgste_set_unlock(ptep, pgste);
+}
+
+static inline void dat_ptep_clear(union pte *ptep, gfn_t gfn, union asce asce, bool has_skeys)
+{
+	dat_ptep_xchg(ptep, _PTE_EMPTY, gfn, asce, has_skeys);
+}
+
 static inline void dat_free_pt(struct page_table *pt)
 {
 	free_page((unsigned long)pt);
@@ -794,4 +815,23 @@ static inline struct kvm_s390_mmu_cache *kvm_s390_new_mmu_cache(void)
 	return NULL;
 }
 
+static inline bool dat_pmdp_xchg_atomic(union pmd *pmdp, union pmd old, union pmd new,
+					gfn_t gfn, union asce asce)
+{
+	return dat_crstep_xchg_atomic(_CRSTEP(pmdp), _CRSTE(old), _CRSTE(new), gfn, asce);
+}
+
+static inline bool dat_pudp_xchg_atomic(union pud *pudp, union pud old, union pud new,
+					gfn_t gfn, union asce asce)
+{
+	return dat_crstep_xchg_atomic(_CRSTEP(pudp), _CRSTE(old), _CRSTE(new), gfn, asce);
+}
+
+static inline void dat_crstep_clear(union crste *crstep, gfn_t gfn, union asce asce)
+{
+	union crste newcrste = _CRSTE_EMPTY(crstep->h.tt);
+
+	dat_crstep_xchg(crstep, newcrste, gfn, asce);
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.52.0


