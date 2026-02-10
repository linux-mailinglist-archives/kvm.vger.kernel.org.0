Return-Path: <kvm+bounces-70761-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IP4EMjVRi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70761-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E19D511C9ED
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:39:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 144663016513
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BC9385ECC;
	Tue, 10 Feb 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aD86DobG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACF4381718;
	Tue, 10 Feb 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737691; cv=none; b=lqgkiNh2oRCqN9NewHgQ9os1e3yiKUt2P7pOZ5u+rsYPqvLKsYQwCLMZydPxHH7aI3q3aCgclT4bYuJcYeFp9FLpLXx0M1Ba/zswNIe4P7RcP8vE7SPXEJ/wE0QOCVWp3e9jj+plPc9v7Q0V1y6DD7f9y2U3kdf4xRgZQFfxzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737691; c=relaxed/simple;
	bh=gnXLZI1H7D46WCHtVG2qJrHqZ44HiGOwRftFWIgsw2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owJHjLyVLPFQJwX0lMJr7+YB0x23aQroJA5ursGHAX776VPDLDVqL+iN8dfGMLYqEtx4O4aRUXq+tP80AVglKZyTINRLxuMjvO3890aI3O43odwfUfEN8I6cTy8Z0lMqaLSsJn93w+rrGvspo42qkSbl/k7WpgNRwpnsyn9AI1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aD86DobG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A8nhVU145954;
	Tue, 10 Feb 2026 15:34:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VHCVjl812hA8XHSYC
	33y1FgNfgX3C8Dznsufc7ZGUOU=; b=aD86DobG7hTvzaSHUlH3qOnIwKsg+vSL+
	W9MrkcC19KIR79Ir7IL37T++PFVnMOcFNxsqmLoyBnzNz3Z4wVHMAMIJ8atiS1JL
	FtFdONnAbXPbEJ5CJJilN/xM4utZOi6NJa03N+pc7SqVCMgw46mt8w4EEDRJPxlO
	/jgtaa+ybDW2FlwGsE/RT0s4fkePflH6MR5HbP2cYPTMOTm2tdf++zEpn6rUarFS
	IxV6QhgAOVAozC3JnyXOGgHKoonsIsEPaveHlE5Je2HsvHwjbIFAfw+LlCxu6NEA
	PU3tkmV1Zn78qHTPOEhcFchc2qG1jonSA/Xe35+lOez6ijUOb/OYA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696wtsm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABv2qS001873;
	Tue, 10 Feb 2026 15:34:31 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYRBA61079964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:27 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F7B820040;
	Tue, 10 Feb 2026 15:34:27 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B3AF320043;
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:26 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 16/36] KVM: s390: KVM page table management functions: walks
Date: Tue, 10 Feb 2026 16:33:57 +0100
Message-ID: <20260210153417.77403-17-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698b5007 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=QAN07HEYxiKkflwQkAkA:9
X-Proofpoint-GUID: a4R5S1ovPly2QkQ-F8jI3GBgeosJHoco
X-Proofpoint-ORIG-GUID: a4R5S1ovPly2QkQ-F8jI3GBgeosJHoco
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX2FschW1Fgzhe
 l9iqpQD2VzIM1noQ7EzW+nNQfBiEypejkc3Wbouz4Hg3IOgvzGQhtq02bJMoaSqa+rDIEXfk8ii
 zJL202j5fZKYHaq4Kj/vbYlOLWc4cRglkMKcIZPlaWrSNmonsGKR6829j+6VRvb2TrYPmoEdaBn
 f7ct0GdRzDiMydJRHKLpfVkWcOjLJHTd6Wr895bguefKxSWOiiyywIgrvLY4Ky/Wkmk1+pREwZO
 vndbZa+FQUpzYZfW9X3e0UqZby1AqrSMvRrXMqRVlLNLnZuT61N6xCQXcipNiVrV+2tsCTZiAao
 tjjV2zxcRbSzYLpyLzwxL80jFbS1WNwK4H11loy7LNyzSUpxS+z/YA1/RuWpQn9c+q8vIXS7v2J
 1OCzCiKlYdOiWpK06AF/forJDefQZTfhlAt/Nquknh0RWFlFjt6UoV+XHY/4BUlgxyDiyVviAZ4
 6A1ep3UeJPW4ZZ6jYrg==
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
	TAGGED_FROM(0.00)[bounces-70761-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[h.tt:url,s.sd:url,s.pr:url,linux.ibm.com:mid,fc0.tl:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E19D511C9ED
X-Rspamd-Action: no action

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to walk to specific table entries, or to
perform actions on a range of entries.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 386 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  39 +++++
 2 files changed, 425 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index e38b1a139fbb..c31838107752 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -216,3 +216,389 @@ union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, g
 	WRITE_ONCE(*ptep, new);
 	return pgste;
 }
+
+/*
+ * dat_split_ste() - Split a segment table entry into page table entries.
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ *
+ * Return: 0 in case of success, -ENOMEM if running out of memory.
+ */
+static int dat_split_ste(struct kvm_s390_mmu_cache *mc, union pmd *pmdp, gfn_t gfn,
+			 union asce asce, bool uses_skeys)
+{
+	union pgste pgste_init;
+	struct page_table *pt;
+	union pmd new, old;
+	union pte init;
+	int i;
+
+	BUG_ON(!mc);
+	old = READ_ONCE(*pmdp);
+
+	/* Already split, nothing to do. */
+	if (!old.h.i && !old.h.fc)
+		return 0;
+
+	pt = dat_alloc_pt_noinit(mc);
+	if (!pt)
+		return -ENOMEM;
+	new.val = virt_to_phys(pt);
+
+	while (old.h.i || old.h.fc) {
+		init.val = pmd_origin_large(old);
+		init.h.p = old.h.p;
+		init.h.i = old.h.i;
+		init.s.d = old.s.fc1.d;
+		init.s.w = old.s.fc1.w;
+		init.s.y = old.s.fc1.y;
+		init.s.sd = old.s.fc1.sd;
+		init.s.pr = old.s.fc1.pr;
+		pgste_init.val = 0;
+		if (old.h.fc) {
+			for (i = 0; i < _PAGE_ENTRIES; i++)
+				pt->ptes[i].val = init.val | i * PAGE_SIZE;
+			/* No need to take locks as the page table is not installed yet. */
+			pgste_init.prefix_notif = old.s.fc1.prefix_notif;
+			pgste_init.pcl = uses_skeys && init.h.i;
+			dat_init_pgstes(pt, pgste_init.val);
+		} else {
+			dat_init_page_table(pt, init.val, 0);
+		}
+
+		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce)) {
+			if (!pgste_init.pcl)
+				return 0;
+			for (i = 0; i < _PAGE_ENTRIES; i++) {
+				union pgste pgste = pt->pgstes[i];
+
+				pgste = dat_save_storage_key_into_pgste(pt->ptes[i], pgste);
+				pgste_set_unlock(pt->ptes + i, pgste);
+			}
+			return 0;
+		}
+		old = READ_ONCE(*pmdp);
+	}
+
+	dat_free_pt(pt);
+	return 0;
+}
+
+/*
+ * dat_split_crste() - Split a crste into smaller crstes.
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ *
+ * Return: %0 in case of success, %-ENOMEM if running out of memory.
+ */
+static int dat_split_crste(struct kvm_s390_mmu_cache *mc, union crste *crstep,
+			   gfn_t gfn, union asce asce, bool uses_skeys)
+{
+	struct crst_table *table;
+	union crste old, new, init;
+	int i;
+
+	old = READ_ONCE(*crstep);
+	if (is_pmd(old))
+		return dat_split_ste(mc, &crstep->pmd, gfn, asce, uses_skeys);
+
+	BUG_ON(!mc);
+
+	/* Already split, nothing to do. */
+	if (!old.h.i && !old.h.fc)
+		return 0;
+
+	table = dat_alloc_crst_noinit(mc);
+	if (!table)
+		return -ENOMEM;
+
+	new.val = virt_to_phys(table);
+	new.h.tt = old.h.tt;
+	new.h.fc0.tl = _REGION_ENTRY_LENGTH;
+
+	while (old.h.i || old.h.fc) {
+		init = old;
+		init.h.tt--;
+		if (old.h.fc) {
+			for (i = 0; i < _CRST_ENTRIES; i++)
+				table->crstes[i].val = init.val | i * HPAGE_SIZE;
+		} else {
+			crst_table_init((void *)table, init.val);
+		}
+		if (dat_crstep_xchg_atomic(crstep, old, new, gfn, asce))
+			return 0;
+		old = READ_ONCE(*crstep);
+	}
+
+	dat_free_crst(table);
+	return 0;
+}
+
+/**
+ * dat_entry_walk() - Walk the gmap page tables.
+ * @mc: Cache to use to allocate dat tables, if needed; can be NULL if neither
+ *      %DAT_WALK_SPLIT or %DAT_WALK_ALLOC is specified in @flags.
+ * @gfn: Guest frame.
+ * @asce: The ASCE of the address space.
+ * @flags: Flags from WALK_* macros.
+ * @walk_level: Level to walk to, from LEVEL_* macros.
+ * @last: Will be filled the last visited non-pte DAT entry.
+ * @ptepp: Will be filled the last visited pte entry, if any, otherwise NULL.
+ *
+ * Returns a table entry pointer for the given guest address and @walk_level.
+ *
+ * The @flags have the following meanings:
+ * * %DAT_WALK_IGN_HOLES: consider holes as normal table entries
+ * * %DAT_WALK_ALLOC: allocate new tables to reach the requested level, if needed
+ * * %DAT_WALK_SPLIT: split existing large pages to reach the requested level, if needed
+ * * %DAT_WALK_LEAF: return successfully whenever a large page is encountered
+ * * %DAT_WALK_ANY: return successfully even if the requested level could not be reached
+ * * %DAT_WALK_CONTINUE: walk to the requested level with the specified flags, and then try to
+ *                       continue walking to ptes with only DAT_WALK_ANY
+ * * %DAT_WALK_USES_SKEYS: storage keys are in use
+ *
+ * Context: called with kvm->mmu_lock held.
+ *
+ * Return:
+ * * %PGM_ADDRESSING if the requested address lies outside memory
+ * * a PIC number if the requested address lies in a memory hole of type _DAT_TOKEN_PIC
+ * * %-EFAULT if the requested address lies inside a memory hole of a different type
+ * * %-EINVAL if the given ASCE is not compatible with the requested level
+ * * %-EFBIG if the requested level could not be reached because a larger frame was found
+ * * %-ENOENT if the requested level could not be reached for other reasons
+ * * %-ENOMEM if running out of memory while allocating or splitting a table
+ */
+int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, int flags,
+		   int walk_level, union crste **last, union pte **ptepp)
+{
+	union vaddress vaddr = { .addr = gfn_to_gpa(gfn) };
+	bool continue_anyway = flags & DAT_WALK_CONTINUE;
+	bool uses_skeys = flags & DAT_WALK_USES_SKEYS;
+	bool ign_holes = flags & DAT_WALK_IGN_HOLES;
+	bool allocate = flags & DAT_WALK_ALLOC;
+	bool split = flags & DAT_WALK_SPLIT;
+	bool leaf = flags & DAT_WALK_LEAF;
+	bool any = flags & DAT_WALK_ANY;
+	struct page_table *pgtable;
+	struct crst_table *table;
+	union crste entry;
+	int rc;
+
+	*last = NULL;
+	*ptepp = NULL;
+	if (WARN_ON_ONCE(unlikely(!asce.val)))
+		return -EINVAL;
+	if (WARN_ON_ONCE(unlikely(walk_level > asce.dt)))
+		return -EINVAL;
+	if (!asce_contains_gfn(asce, gfn))
+		return PGM_ADDRESSING;
+
+	table = dereference_asce(asce);
+	if (asce.dt >= ASCE_TYPE_REGION1) {
+		*last = table->crstes + vaddr.rfx;
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION1))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == TABLE_TYPE_REGION1)
+			return 0;
+		if (entry.pgd.h.i) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.pgd);
+	}
+
+	if (asce.dt >= ASCE_TYPE_REGION2) {
+		*last = table->crstes + vaddr.rsx;
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION2))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == TABLE_TYPE_REGION2)
+			return 0;
+		if (entry.p4d.h.i) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.p4d);
+	}
+
+	if (asce.dt >= ASCE_TYPE_REGION3) {
+		*last = table->crstes + vaddr.rtx;
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION3))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == TABLE_TYPE_REGION3 &&
+		    continue_anyway && !entry.pud.h.fc && !entry.h.i) {
+			walk_level = TABLE_TYPE_PAGE_TABLE;
+			allocate = false;
+		}
+		if (walk_level == TABLE_TYPE_REGION3 || ((leaf || any) && entry.pud.h.fc))
+			return 0;
+		if (entry.pud.h.i && !entry.pud.h.fc) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		if (walk_level <= TABLE_TYPE_SEGMENT && entry.pud.h.fc) {
+			if (!split)
+				return -EFBIG;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.pud);
+	}
+
+	*last = table->crstes + vaddr.sx;
+	entry = READ_ONCE(**last);
+	if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_SEGMENT))
+		return -EINVAL;
+	if (crste_hole(entry) && !ign_holes)
+		return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
+		walk_level = TABLE_TYPE_PAGE_TABLE;
+		allocate = false;
+	}
+	if (walk_level == TABLE_TYPE_SEGMENT || ((leaf || any) && entry.pmd.h.fc))
+		return 0;
+
+	if (entry.pmd.h.i && !entry.pmd.h.fc) {
+		if (!allocate)
+			return any ? 0 : -ENOENT;
+		rc = dat_split_ste(mc, &(*last)->pmd, gfn, asce, uses_skeys);
+		if (rc)
+			return rc;
+		entry = READ_ONCE(**last);
+	}
+	if (walk_level <= TABLE_TYPE_PAGE_TABLE && entry.pmd.h.fc) {
+		if (!split)
+			return -EFBIG;
+		rc = dat_split_ste(mc, &(*last)->pmd, gfn, asce, uses_skeys);
+		if (rc)
+			return rc;
+		entry = READ_ONCE(**last);
+	}
+	pgtable = dereference_pmd(entry.pmd);
+	*ptepp = pgtable->ptes + vaddr.px;
+	if (pte_hole(**ptepp) && !ign_holes)
+		return (*ptepp)->tok.type == _DAT_TOKEN_PIC ? (*ptepp)->tok.par : -EFAULT;
+	return 0;
+}
+
+static long dat_pte_walk_range(gfn_t gfn, gfn_t end, struct page_table *table, struct dat_walk *w)
+{
+	unsigned int idx = gfn & (_PAGE_ENTRIES - 1);
+	long rc = 0;
+
+	for ( ; gfn < end; idx++, gfn++) {
+		if (pte_hole(READ_ONCE(table->ptes[idx]))) {
+			if (!(w->flags & DAT_WALK_IGN_HOLES))
+				return -EFAULT;
+			if (!(w->flags & DAT_WALK_ANY))
+				continue;
+		}
+
+		rc = w->ops->pte_entry(table->ptes + idx, gfn, gfn + 1, w);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+static long dat_crste_walk_range(gfn_t start, gfn_t end, struct crst_table *table,
+				 struct dat_walk *walk)
+{
+	unsigned long idx, cur_shift, cur_size;
+	dat_walk_op the_op;
+	union crste crste;
+	gfn_t cur, next;
+	long rc = 0;
+
+	cur_shift = 8 + table->crstes[0].h.tt * 11;
+	idx = (start >> cur_shift) & (_CRST_ENTRIES - 1);
+	cur_size = 1UL << cur_shift;
+
+	for (cur = ALIGN_DOWN(start, cur_size); cur < end; idx++, cur = next) {
+		next = cur + cur_size;
+		walk->last = table->crstes + idx;
+		crste = READ_ONCE(*walk->last);
+
+		if (crste_hole(crste)) {
+			if (!(walk->flags & DAT_WALK_IGN_HOLES))
+				return -EFAULT;
+			if (!(walk->flags & DAT_WALK_ANY))
+				continue;
+		}
+
+		the_op = walk->ops->crste_ops[crste.h.tt];
+		if (the_op) {
+			rc = the_op(walk->last, cur, next, walk);
+			crste = READ_ONCE(*walk->last);
+		}
+		if (rc)
+			break;
+		if (!crste.h.i && !crste.h.fc) {
+			if (!is_pmd(crste))
+				rc = dat_crste_walk_range(max(start, cur), min(end, next),
+							  _dereference_crste(crste), walk);
+			else if (walk->ops->pte_entry)
+				rc = dat_pte_walk_range(max(start, cur), min(end, next),
+							dereference_pmd(crste.pmd), walk);
+		}
+	}
+	return rc;
+}
+
+/**
+ * _dat_walk_gfn_range() - Walk DAT tables.
+ * @start: The first guest page frame to walk.
+ * @end: The guest page frame immediately after the last one to walk.
+ * @asce: The ASCE of the guest mapping.
+ * @ops: The gmap_walk_ops that will be used to perform the walk.
+ * @flags: Flags from WALK_* (currently only WALK_IGN_HOLES is supported).
+ * @priv: Will be passed as-is to the callbacks.
+ *
+ * Any callback returning non-zero causes the walk to stop immediately.
+ *
+ * Return: %-EINVAL in case of error, %-EFAULT if @start is too high for the
+ *         given ASCE unless the DAT_WALK_IGN_HOLES flag is specified,
+ *         otherwise it returns whatever the callbacks return.
+ */
+long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
+			 const struct dat_walk_ops *ops, int flags, void *priv)
+{
+	struct crst_table *table = dereference_asce(asce);
+	struct dat_walk walk = {
+		.ops	= ops,
+		.asce	= asce,
+		.priv	= priv,
+		.flags	= flags,
+		.start	= start,
+		.end	= end,
+	};
+
+	if (WARN_ON_ONCE(unlikely(!asce.val)))
+		return -EINVAL;
+	if (!asce_contains_gfn(asce, start))
+		return (flags & DAT_WALK_IGN_HOLES) ? 0 : -EFAULT;
+
+	return dat_crste_walk_range(start, min(end, asce_end(asce)), table, &walk);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index ee070d18bd36..409064bd20a5 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -45,6 +45,7 @@ enum {
 #define TABLE_TYPE_PAGE_TABLE -1
 
 enum dat_walk_flags {
+	DAT_WALK_USES_SKEYS	= 0x40,
 	DAT_WALK_CONTINUE	= 0x20,
 	DAT_WALK_IGN_HOLES	= 0x10,
 	DAT_WALK_SPLIT		= 0x08,
@@ -332,6 +333,34 @@ struct page_table {
 static_assert(sizeof(struct crst_table) == _CRST_TABLE_SIZE);
 static_assert(sizeof(struct page_table) == PAGE_SIZE);
 
+struct dat_walk;
+
+typedef long (*dat_walk_op)(union crste *crste, gfn_t gfn, gfn_t next, struct dat_walk *w);
+
+struct dat_walk_ops {
+	union {
+		dat_walk_op crste_ops[4];
+		struct {
+			dat_walk_op pmd_entry;
+			dat_walk_op pud_entry;
+			dat_walk_op p4d_entry;
+			dat_walk_op pgd_entry;
+		};
+	};
+	long (*pte_entry)(union pte *pte, gfn_t gfn, gfn_t next, struct dat_walk *w);
+};
+
+struct dat_walk {
+	const struct dat_walk_ops *ops;
+	union crste *last;
+	union pte *last_pte;
+	union asce asce;
+	gfn_t start;
+	gfn_t end;
+	int flags;
+	void *priv;
+};
+
 /**
  * _pte() - Useful constructor for union pte
  * @pfn: the pfn this pte should point to.
@@ -436,6 +465,11 @@ bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste ne
 			    union asce asce);
 void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce);
 
+long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
+			 const struct dat_walk_ops *ops, int flags, void *priv);
+
+int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, int flags,
+		   int walk_level, union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
 
@@ -834,4 +868,9 @@ static inline void dat_crstep_clear(union crste *crstep, gfn_t gfn, union asce a
 	dat_crstep_xchg(crstep, newcrste, gfn, asce);
 }
 
+static inline int get_level(union crste *crstep, union pte *ptep)
+{
+	return ptep ? TABLE_TYPE_PAGE_TABLE : crstep->h.tt;
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.53.0


