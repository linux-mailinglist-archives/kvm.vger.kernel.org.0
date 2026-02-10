Return-Path: <kvm+bounces-70735-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIRuKklQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70735-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3E0E11C873
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 56AC630148BA
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392C63815DE;
	Tue, 10 Feb 2026 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ej8CWAUY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28323815DB;
	Tue, 10 Feb 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737671; cv=none; b=Ty9gtIUDxRPN0PKvZly7GeFrGPLeVT2KwfQGBJS+CLbRgi1AZfeJw/UwQ0iKQ0JfqzayUG5apw1HZu0Qfg5Jsy/TYw9P13Kie99Vyn4bGuV/VbSrpN6ysmvVuoocGw20Gbu1QyYiu+C3Tpf+kTS4z1aMPkrJaHmr1T8CItF4mxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737671; c=relaxed/simple;
	bh=tsmqNCSvH88/5lYcYoy9YCmaMY3MGNLFxP41muKea+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRi+8E2m9d2XgzmAL9QBV9ydtHX7XkB/s/oEkK0bHK2gAvIpgrNkA16UnmBfbpxnvhjTy/K5JytikmhgX1/k/ih2eJFFCOSk4KbOzeIkK4yOex6qWO+4Rsz7snOPudsT0Z8AaYDjuMgqz8/zSMkIMh1IrCtV6XaEQGNzTtFwrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ej8CWAUY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61ACA4IE883546;
	Tue, 10 Feb 2026 15:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=YYQjkwmBWQzOEP72D
	xqZcJny6rxTTcuPaL0PT7izgmU=; b=Ej8CWAUYA6B7csYAzr1LeQDynZ2qeFAe5
	i6iU1wQeVrF96KAqEK6j/3FZBivH0Q1EzoWn7to58HWQ9XMfXhzSAIO7UroB3Wwn
	A81WcL1Juk66rSoOE5sSxtWrq+MTWm8ZGYLCiKMp+TvIDBV3GkFjywFAazoDGYao
	lqYBWoy0ydiDv/NknAjyQDBNORhg2hBJFsqE8DLME8/1mx1Tt29EZDiggKuoHQDx
	06rTkMF6oyPIJt9w4sRI48woIQ67ZAQR38ve42MQxdJwuELERSrZO54B3dux5IJn
	gQPsZCJMXqxVlStCMBs9XLvvJZMgDFJ3XG3M+WegexMIiao/uZmWA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696ucybb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABFbVM001815;
	Tue, 10 Feb 2026 15:34:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6je21jbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYL2v55837040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63C7120043;
	Tue, 10 Feb 2026 15:34:21 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6F5120040;
	Tue, 10 Feb 2026 15:34:20 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:20 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 06/36] KVM: s390: Add gmap_helper_set_unused()
Date: Tue, 10 Feb 2026 16:33:47 +0100
Message-ID: <20260210153417.77403-7-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698b5001 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=F2Av9RbSm_i__n-hslAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfX9kJR/HoyHeap
 OMdM6VMvK/mkuI7dXMzuYtqH9iSXuaLEwmp2HxKXS1ZdVFxV9dNh/oBgCGoMry1nijnmx0pKBk4
 xOOe7BvM3dyZoplsxoPHqnFe2Nbv1Viw31qNd9fPzM1o0qlvVZx3Mqwb14iWVAQV+N+8pf4wq0k
 LjyJju2ON4l8PHjCeivov113r19sLi7HiTjwMzK9Zwx9KBuU9RmE/s5qx9TGfkZwKuO1lh/HPQQ
 SVOg+ZJnNoSEcovIN0EgvI2AOxkT9fz9OU3b7TfZbYq0kbwGpISPBSncDFYzfDWE4yeHVcLD5Aa
 jDj555xnC0QTaS9YvOSkVOsuVWhOvQHlFzWHbYIxlCBxDjGa92hWFDq1lSuX4tkpp2poBWNN1xX
 pBjyGrGWjL8HqQTtsmYfbGFwMSr7miaXPJc8Ym36tY2FERYf01XKQxEgNA/9P2in8FKjPu4heRm
 ZiH92UIFuRa28PxzZ6w==
X-Proofpoint-ORIG-GUID: kP_NxmZugBCA6MpZ3jA6q8gMOGyha7fF
X-Proofpoint-GUID: kP_NxmZugBCA6MpZ3jA6q8gMOGyha7fF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
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
	TAGGED_FROM(0.00)[bounces-70735-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: C3E0E11C873
X-Rspamd-Action: no action

Add gmap_helper_set_unused() to mark userspace ptes as unused.

Core mm code will use that information to discard unused pages instead
of attempting to swap them.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.53.0


