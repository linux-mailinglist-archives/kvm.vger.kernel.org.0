Return-Path: <kvm+bounces-70211-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QODuDvxgg2mfmAMAu9opvQ
	(envelope-from <kvm+bounces-70211-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:08:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CDEE7FE9
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3CAB3081594
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C06F41C307;
	Wed,  4 Feb 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vcs/mTCj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C76B2D879A;
	Wed,  4 Feb 2026 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217389; cv=none; b=Nks0IXfciHc8LHWux07xFDRIcU2FXXDLAM0US1Z831o1YCFPe2Bc2ymEOcAtjbGYtJuRVENJToFBzrKcad6rokJKrlLP5511YGYXCMyL/i/GlNz2z2fjd4NbA09VMDstHZw4r36T/78zt8F6M7JF19XfN8HpWAXIROCPC8xUuww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217389; c=relaxed/simple;
	bh=wZIM7tTYqqSB7gE+7VmQ8HvdCuIZC1gLeC4DpqWpcvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi4hQ7+FLhmlDR5pvJBj2Cr6GgYG4vLSES6WVbckWKcqX5Xss7wBH8mv3UmVT7Y2gAFgpPJci8sqOx5qpAuNpUiiP+Zaj2n4WHBdzfxgFxqY1ddDfFENUwhP9rctTE2mdB268tfwdhAc+BD/IkgKo4/4VcB51S7UmvUjNngFfUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vcs/mTCj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6140dl3D032157;
	Wed, 4 Feb 2026 15:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CE4JpDSEghk1nwVFo
	3HYe4mFC7f75/s97B715bNStdc=; b=Vcs/mTCjZ7TWLWJ5q7kBB9mUQ/k2WjJc3
	aAU25/isqfzzlW4/HFrWEv3jpyjDKNqXp/H9k7RycvEftMLYddPqM2EprluCzC0L
	OAoufSqk96YKyHzHToPO0VSVBxCawwP8QcbbYMhpDGaqblGzqzRgoz480u+HCtHL
	sYuzZJzaIR5PL3UNQjry5b+qBYEuLzMaXRY7R5tYmy2YmuxlYQ80q+7B1sFcb1yH
	XNnhK3LqxAFWS4ImDgfJp7kL+kTEjXcpx2YA/pvGGJbhKwObR0qh4fuKfxp6/NKo
	eCLttleZFJC33jlzr1RBs+LiLK804fTlxQhxDeHEzlDDLUNQnXv0A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gyw70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614CPBBR025706;
	Wed, 4 Feb 2026 15:03:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1w2mwnjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F31cf16777716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 066C220040;
	Wed,  4 Feb 2026 15:03:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B85EC2004D;
	Wed,  4 Feb 2026 15:03:00 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 05/29] KVM: s390: Add gmap_helper_set_unused()
Date: Wed,  4 Feb 2026 16:02:34 +0100
Message-ID: <20260204150259.60425-6-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=69835fa9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=F2Av9RbSm_i__n-hslAA:9
X-Proofpoint-GUID: BYKL69CtYqqMcBuFN3VxyOi7ON-pNe6_
X-Proofpoint-ORIG-GUID: BYKL69CtYqqMcBuFN3VxyOi7ON-pNe6_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX4+eLnlxsS++8
 Fx9MqKeLK0RI+QbizF6I5jLPBMskVzGSBp2xe7+dtdy0neoiDFW6MJsvnw7+naL53tfKtoX/urc
 a/pqEqvB1m2Kyg0YdWsEprx0kAln6h9g7lDNdibmOj9v1nWTn51SNymN9IzdC40qG5qqBZmlQQM
 kEpGWYtG0loEJc0A7VebDpEZBp0pBi5UYYVUZrZ+xy0oD11IPYVymZqUkpUTPaSXCW17QOnRrLM
 ApMqwo+kDe4LaRHv7Te56XtDut0N6kdc2mWKPNxRFyE2pNiOHy1ZsaqiSXQouQCM79ASXKR8pDP
 uld11Abszk/C+wT7JS4QDhLoKQYSgzvOVk7QZRpp8LglKE8Txj+kfAdKU7jMK6FttwmUm0iL25z
 V+2O6d+9jjo7keG+vqWM7ID/ep2Lc7sj04Z2gwoaXKC+d5PqdYGXdSETBgcPt5lT0G9+YgZWk0I
 +I27gmyjgQTnrhcK8Tg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_04,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
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
	TAGGED_FROM(0.00)[bounces-70211-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E4CDEE7FE9
X-Rspamd-Action: no action

Add gmap_helper_set_unused() to mark userspace ptes as unused.

Core mm code will use that information to discard unused pages instead
of attempting to swap them.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/gmap_helpers.h |  1 +
 arch/s390/mm/gmap_helpers.c          | 79 ++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include/asm/gmap_helpers.h
index 5356446a61c4..2d3ae421077e 100644
--- a/arch/s390/include/asm/gmap_helpers.h
+++ b/arch/s390/include/asm/gmap_helpers.h
@@ -11,5 +11,6 @@
 void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr);
 void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end);
 int gmap_helper_disable_cow_sharing(void);
+void gmap_helper_try_set_pte_unused(struct mm_struct *mm, unsigned long vmaddr);
 
 #endif /* _ASM_S390_GMAP_HELPERS_H */
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 4fba13675950..4864cb35fc25 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -129,6 +129,85 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
 }
 EXPORT_SYMBOL_GPL(gmap_helper_discard);
 
+/**
+ * gmap_helper_try_set_pte_unused() - mark a pte entry as unused
+ * @mm: the mm
+ * @vmaddr: the userspace address whose pte is to be marked
+ *
+ * Mark the pte corresponding the given address as unused. This will cause
+ * core mm code to just drop this page instead of swapping it.
+ *
+ * This function needs to be called with interrupts disabled (for example
+ * while holding a spinlock), or while holding the mmap lock. Normally this
+ * function is called as a result of an unmap operation, and thus KVM common
+ * code will already hold kvm->mmu_lock in write mode.
+ *
+ * Context: Needs to be called while holding the mmap lock or with interrupts
+ *          disabled.
+ */
+void gmap_helper_try_set_pte_unused(struct mm_struct *mm, unsigned long vmaddr)
+{
+	pmd_t *pmdp, pmd, pmdval;
+	pud_t *pudp, pud;
+	p4d_t *p4dp, p4d;
+	pgd_t *pgdp, pgd;
+	spinlock_t *ptl;	/* Lock for the host (userspace) page table */
+	pte_t *ptep;
+
+	pgdp = pgd_offset(mm, vmaddr);
+	pgd = pgdp_get(pgdp);
+	if (pgd_none(pgd) || !pgd_present(pgd))
+		return;
+
+	p4dp = p4d_offset(pgdp, vmaddr);
+	p4d = p4dp_get(p4dp);
+	if (p4d_none(p4d) || !p4d_present(p4d))
+		return;
+
+	pudp = pud_offset(p4dp, vmaddr);
+	pud = pudp_get(pudp);
+	if (pud_none(pud) || pud_leaf(pud) || !pud_present(pud))
+		return;
+
+	pmdp = pmd_offset(pudp, vmaddr);
+	pmd = pmdp_get_lockless(pmdp);
+	if (pmd_none(pmd) || pmd_leaf(pmd) || !pmd_present(pmd))
+		return;
+
+	ptep = pte_offset_map_rw_nolock(mm, pmdp, vmaddr, &pmdval, &ptl);
+	if (!ptep)
+		return;
+
+	/*
+	 * Several paths exists that takes the ptl lock and then call the
+	 * mmu_notifier, which takes the mmu_lock. The unmap path, instead,
+	 * takes the mmu_lock in write mode first, and then potentially
+	 * calls this function, which takes the ptl lock. This can lead to a
+	 * deadlock.
+	 * The unused page mechanism is only an optimization, if the
+	 * _PAGE_UNUSED bit is not set, the unused page is swapped as normal
+	 * instead of being discarded.
+	 * If the lock is contended the bit is not set and the deadlock is
+	 * avoided.
+	 */
+	if (spin_trylock(ptl)) {
+		/*
+		 * Make sure the pte we are touching is still the correct
+		 * one. In theory this check should not be needed, but
+		 * better safe than sorry.
+		 * Disabling interrupts or holding the mmap lock is enough to
+		 * guarantee that no concurrent updates to the page tables
+		 * are possible.
+		 */
+		if (likely(pmd_same(pmdval, pmdp_get_lockless(pmdp))))
+			__atomic64_or(_PAGE_UNUSED, (long *)ptep);
+		spin_unlock(ptl);
+	}
+
+	pte_unmap(ptep);
+}
+EXPORT_SYMBOL_GPL(gmap_helper_try_set_pte_unused);
+
 static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
 				   unsigned long end, struct mm_walk *walk)
 {
-- 
2.52.0


