Return-Path: <kvm+bounces-70744-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mCW+FZVQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70744-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6238711C90C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C9223301C658
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81079389DED;
	Tue, 10 Feb 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ko65gTp1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706B638884A;
	Tue, 10 Feb 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737679; cv=none; b=j9zJ/qquXW84/TZiOi3QuCFms7XFQME2LH+ZIEEIqUuYTC7LS3928TO9+4i+h132mLH+Z5eSpV142dyZUvk1g5/W2k6xJrEZDN8a0TZg27Gu6VhOmIU98X+H9HYXNKVj5XVURbItXVR2era8RHGptzKff5oZ34pTtjjTQjylMvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737679; c=relaxed/simple;
	bh=ltmLMcwg2b5+94qJDLHgWETCD6KWcJzpusDLN8UGmE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVtHoSPu/ZDouhtFQsznRFGPVCcX3Gh0H0Wj5RQdVha0+xCcuCNaGrjfbW3V8N0/GKi/EO8f4nsDSQoRziQOnu/KKhCHL977K2kotSD2vZStLWWN1lGixtIflqzM4FBeU9z0HYRdz4P1A+CxPEvM6sAoeEIlfI7+t0VThtRn0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ko65gTp1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AAF8vb451836;
	Tue, 10 Feb 2026 15:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2k7tiMmlPUFxsncEB
	Ckv5WKLeyUg75MLErViJTCI5gk=; b=Ko65gTp1J+cxh2lPmJVYeL7g+l7pmCjCo
	Xx8tUjMoGo1T2XK/Y/YGlmsJNFqI7g9bbxcySiJ3IWMwSXpmkWSKFDOpUmSFKroy
	9Zbrwx/8ETxGXysFnslJmzfLWfTJoOpm0JUl7sL1rePQjUYraCdbAwp5ssWdRo6r
	G5aktGoYN92ycWoz3B0DhHVaki7wNyECs0VjGrEBJolz49clRfkQHf1t2N8eeGeT
	/ZdmxZNAGA50kxzKxg3CqZnessPFiNnes75UNHFn1aDhlXGhqcI0ZXci5J9upCYn
	aIuL6cw7ChQY/II1WxfqmyT1Wpxyeeac5LZWZiEtn+IcuwjR8IBlA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucwfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:33 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEjUQ8001420;
	Tue, 10 Feb 2026 15:34:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1vf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:31 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYR0o61079966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C42FC20040;
	Tue, 10 Feb 2026 15:34:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49BCA20043;
	Tue, 10 Feb 2026 15:34:27 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:27 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 17/36] KVM: s390: KVM page table management functions: storage keys
Date: Tue, 10 Feb 2026 16:33:58 +0100
Message-ID: <20260210153417.77403-18-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698b5009 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=nv0Um0OdivUXotKj5UwA:9
X-Proofpoint-ORIG-GUID: dRkAnReN2slestTOQujFR-fnimi-taD8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX5DurJhn/ncsY
 aU0o7mMK/LlFdWwZ81B3aagu19zMtINQYvlLxHsEe+upy3wG+jcKK73DD4cDkEPYkm4xKkLu7kL
 6tlhjcyC47/k4ER23DQO4zPZ1hQRxM0TcsPNRrYI0FgxwANz4fbuCGwxUm4OBHF2jEchXAcYBfq
 Wbop0ITRGDGOhWsusYn6EBhOmy0yv/Bt5NIVmunMGvoWVc+4+hpIcWW8r81+Hd/pIi7VXerGbsw
 xkRwKEBBbic6IaXC4CHpUu2gAPC9pPsxPjfJUpDlTT8N1tFjN03EhYU4F5QmirrkjTGq6n7kQ/3
 v0qDCycZHp0cTHfjfMl9i7HYHeehBetpA9RPz2q128lx8dqiLTjmlmz/fJ+s/yBc9VVUgB/zHeu
 7iMQ+OOVSZpbS3kqEbPQBDn7Yq8u8B7VPvJGwdxwwl81pHawoAvgNxHdgnclB+E9sM4lJYpKpUB
 L4OAHZIxsEv9Ro82Aiw==
X-Proofpoint-GUID: dRkAnReN2slestTOQujFR-fnimi-taD8
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70744-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,pgste.hr:url];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 6238711C90C
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions related to storage key handling.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 223 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |   7 ++
 2 files changed, 230 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index c31838107752..99682792d9ee 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -602,3 +602,226 @@ long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
 
 	return dat_crste_walk_range(start, min(end, asce_end(asce)), table, &walk);
 }
+
+int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int rc;
+
+	skey->skey = 0;
+	rc = dat_entry_walk(NULL, gfn, asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep) {
+		union crste crste;
+
+		crste = READ_ONCE(*crstep);
+		if (!crste.h.fc || !crste.s.fc1.pr)
+			return 0;
+		skey->skey = page_get_storage_key(large_crste_to_phys(crste, gfn));
+		return 0;
+	}
+	pgste = pgste_get_lock(ptep);
+	if (ptep->h.i) {
+		skey->acc = pgste.acc;
+		skey->fp = pgste.fp;
+	} else {
+		skey->skey = page_get_storage_key(pte_origin(*ptep));
+	}
+	skey->r |= pgste.gr;
+	skey->c |= pgste.gc;
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static void dat_update_ptep_sd(union pgste old, union pgste pgste, union pte *ptep)
+{
+	if (pgste.acc != old.acc || pgste.fp != old.fp || pgste.gr != old.gr || pgste.gc != old.gc)
+		__atomic64_or(_PAGE_SD, &ptep->val);
+}
+
+int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+			union skey skey, bool nq)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(mc, gfn, asce, DAT_WALK_LEAF_ALLOC, TABLE_TYPE_PAGE_TABLE,
+			    &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep) {
+		page_set_storage_key(large_crste_to_phys(*crstep, gfn), skey.skey, !nq);
+		return 0;
+	}
+
+	old = pgste_get_lock(ptep);
+	pgste = old;
+
+	pgste.acc = skey.acc;
+	pgste.fp = skey.fp;
+	pgste.gc = skey.c;
+	pgste.gr = skey.r;
+
+	if (!ptep->h.i) {
+		union skey old_skey;
+
+		old_skey.skey = page_get_storage_key(pte_origin(*ptep));
+		pgste.hc |= old_skey.c;
+		pgste.hr |= old_skey.r;
+		old_skey.c = old.gc;
+		old_skey.r = old.gr;
+		skey.r = 0;
+		skey.c = 0;
+		page_set_storage_key(pte_origin(*ptep), skey.skey, !nq);
+	}
+
+	dat_update_ptep_sd(old, pgste, ptep);
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static bool page_cond_set_storage_key(phys_addr_t paddr, union skey skey, union skey *oldkey,
+				      bool nq, bool mr, bool mc)
+{
+	oldkey->skey = page_get_storage_key(paddr);
+	if (oldkey->acc == skey.acc && oldkey->fp == skey.fp &&
+	    (oldkey->r == skey.r || mr) && (oldkey->c == skey.c || mc))
+		return false;
+	page_set_storage_key(paddr, skey.skey, !nq);
+	return true;
+}
+
+int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gfn_t gfn,
+			     union skey skey, union skey *oldkey, bool nq, bool mr, bool mc)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union skey prev;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(mmc, gfn, asce, DAT_WALK_LEAF_ALLOC, TABLE_TYPE_PAGE_TABLE,
+			    &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep)
+		return page_cond_set_storage_key(large_crste_to_phys(*crstep, gfn), skey, oldkey,
+						 nq, mr, mc);
+
+	old = pgste_get_lock(ptep);
+	pgste = old;
+
+	rc = 1;
+	pgste.acc = skey.acc;
+	pgste.fp = skey.fp;
+	pgste.gc = skey.c;
+	pgste.gr = skey.r;
+
+	if (!ptep->h.i) {
+		rc = page_cond_set_storage_key(pte_origin(*ptep), skey, &prev, nq, mr, mc);
+		pgste.hc |= prev.c;
+		pgste.hr |= prev.r;
+		prev.c |= old.gc;
+		prev.r |= old.gr;
+	} else {
+		prev.acc = old.acc;
+		prev.fp = old.fp;
+		prev.c = old.gc;
+		prev.r = old.gr;
+	}
+	if (oldkey)
+		*oldkey = prev;
+
+	dat_update_ptep_sd(old, pgste, ptep);
+	pgste_set_unlock(ptep, pgste);
+	return rc;
+}
+
+int dat_reset_reference_bit(union asce asce, gfn_t gfn)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(NULL, gfn, asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep) {
+		union crste crste = READ_ONCE(*crstep);
+
+		if (!crste.h.fc || !crste.s.fc1.pr)
+			return 0;
+		return page_reset_referenced(large_crste_to_phys(*crstep, gfn));
+	}
+	old = pgste_get_lock(ptep);
+	pgste = old;
+
+	if (!ptep->h.i) {
+		rc = page_reset_referenced(pte_origin(*ptep));
+		pgste.hr = rc >> 1;
+	}
+	rc |= (pgste.gr << 1) | pgste.gc;
+	pgste.gr = 0;
+
+	dat_update_ptep_sd(old, pgste, ptep);
+	pgste_set_unlock(ptep, pgste);
+	return rc;
+}
+
+static long dat_reset_skeys_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste.acc = 0;
+	pgste.fp = 0;
+	pgste.gr = 0;
+	pgste.gc = 0;
+	if (ptep->s.pr)
+		page_set_storage_key(pte_origin(*ptep), PAGE_DEFAULT_KEY, 1);
+	pgste_set_unlock(ptep, pgste);
+
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+static long dat_reset_skeys_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	phys_addr_t addr, end, origin = crste_origin_large(*crstep);
+
+	if (!crstep->h.fc || !crstep->s.fc1.pr)
+		return 0;
+
+	addr = ((max(gfn, walk->start) - gfn) << PAGE_SHIFT) + origin;
+	end = ((min(next, walk->end) - gfn) << PAGE_SHIFT) + origin;
+	while (ALIGN(addr + 1, _SEGMENT_SIZE) <= end)
+		addr = sske_frame(addr, PAGE_DEFAULT_KEY);
+	for ( ; addr < end; addr += PAGE_SIZE)
+		page_set_storage_key(addr, PAGE_DEFAULT_KEY, 1);
+
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+long dat_reset_skeys(union asce asce, gfn_t start)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = dat_reset_skeys_pte,
+		.pmd_entry = dat_reset_skeys_crste,
+		.pud_entry = dat_reset_skeys_crste,
+	};
+
+	return _dat_walk_gfn_range(start, asce_end(asce), asce, &ops, DAT_WALK_IGN_HOLES, NULL);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 409064bd20a5..6c7815d4f07f 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -472,6 +472,13 @@ int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, in
 		   int walk_level, union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
+int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey);
+int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+			union skey skey, bool nq);
+int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gfn_t gfn,
+			     union skey skey, union skey *oldkey, bool nq, bool mr, bool mc);
+int dat_reset_reference_bit(union asce asce, gfn_t gfn);
+long dat_reset_skeys(union asce asce, gfn_t start);
 
 int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
 
-- 
2.53.0


