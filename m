Return-Path: <kvm+bounces-70743-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCgrB5hQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70743-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA39E11C914
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 24ECD306C13D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66BA3816ED;
	Tue, 10 Feb 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XNNg/3ec"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91573815E1;
	Tue, 10 Feb 2026 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737678; cv=none; b=RbzSaDfcCywnpt3BVWuD7ispGiub2a2HhbAX/WSwyCexjJR9yhurSFaXGBVNqxk7I8iKBNzEs0zH20VzMLZ94x+jEQADoSN9L6/bFYS5/e0DYPvRJvIcGsqeA7Xds75B/152ifGGBwWtgKxlqSCCTf/eH69Fj1Pq9wrF0wCI1lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737678; c=relaxed/simple;
	bh=VWOHbuCD+mrlxP3qN/Co54P1lW18z0Cpaq/f1bum+dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk2wrmbmmnIpT3WNg8SgYmeGhBihMtsWY/sl1WuK8GMtHcPCDRZ8F1kCbUeI5JRwnYu8qgDBc7h6i6ROokhLwQ9t/25PsOuzWLqF/IheRx7kBmQ/xVqpTmJtp9kkbOhaNzEh5pm248Bs5kPVfnqFPjFSmhwsNUQsrCyl34FEhZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XNNg/3ec; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AAVQGO661755;
	Tue, 10 Feb 2026 15:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Pw4/x69WliNcX3CP6
	d5crLvEWThlNFXDwqIxPBa8bDg=; b=XNNg/3ecZrc3318dodbKrDRQmTo5tsaPF
	YnRw/Qs82s5//6Wi7DTdgelFdCDFm9aaIhWCdjoVBderBPSEHkQ7orUQhKKLrJD5
	xEjBY2sQcGEFy0jBzRGLOjcHofhvGmHkAhqXu6bhT9dZdP9ez5Tfw7r7XZUh/Q90
	Wy72rULENJ0vGqG11NIW/3xSfGZCgRuem0/SV7zElsMVnYRV/a9aKZJaDeMrz1a5
	vwxN4noT6l4NAS2fbh1FLlMNyVAcnxANSL/UXoqtQzewbi7rX0KYnxPiapMhwKSf
	MsiikAihrx0Byko3F5A2eI3kd9TADI+C3toxk8NISEPiZAk/6bIiA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucwfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABNOV8001837;
	Tue, 10 Feb 2026 15:34:30 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYQcH39190988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98FCB2004B;
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2690B20043;
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 15/36] KVM: s390: KVM page table management functions: clear and replace
Date: Tue, 10 Feb 2026 16:33:56 +0100
Message-ID: <20260210153417.77403-16-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698b5007 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=cTj5uL8xXfUXbJxEK6wA:9
X-Proofpoint-ORIG-GUID: Y3ocltnHP1N7SLjuo0Oc0K-EmNjhQBMh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX//zmvo28S6zm
 IobNZkZofPjpXASGk6kHG5liZjA+gaRIc2eDHRM8mDzZRTdyQujBM1VeMOxXBpFBs1MRXspsoYk
 zadBBTF78QMP6EmVxdTGuo/k1CksiROqfaidJdD6578ApvcZuO6K+BS1OiW9WWbYzKIPt1e4s5s
 lfoq+0l8zsqWksxFNh3mcNyWYeFPol1ftke5lzQle5wGn9FHWUy2gqovZr2ZruX4VP1WKzwetoO
 blFwIkOepTqqnoKcOs0NG87EDgWkJ3WdkdEANeSSUU+pm3+tYKZRShO7vGgWVtas7M3kp28+Wyq
 vGuU/KIX0Ys32AXx0a3ol/fBWFGXCiRjjUDVXCWEsWOquHlngreOT7rZ9GZiGm0FBDBn2irojbB
 fh6h8yFUEqnSrob+TQosuHU53m4fwFTAfqHRNVLh108yi4rJiRq9Rvfo3Ioalkq2BHOgadeum+g
 z8y5myvl9JcFT3OBStw==
X-Proofpoint-GUID: Y3ocltnHP1N7SLjuo0Oc0K-EmNjhQBMh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70743-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: AA39E11C914
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to clear, replace or exchange DAT table
entries.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
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
2.53.0


