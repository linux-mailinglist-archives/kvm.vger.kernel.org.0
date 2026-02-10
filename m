Return-Path: <kvm+bounces-70748-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QL27FMtQi2nwTwAAu9opvQ
	(envelope-from <kvm+bounces-70748-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E23EE11C95E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 16:37:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B70A307DE4D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CCF238A717;
	Tue, 10 Feb 2026 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WSQln4Py"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F8381713;
	Tue, 10 Feb 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770737681; cv=none; b=hQWN0lCzwfP8sPMWCthR2Dj9jfoCLmoB30TjL4J2DA6B2DgnJKOfSlVjt+p1BaxCE+5Dg8JF4wbywbLln8KmLExjeTjSsR61oeZzd4RT5kJMuJHzqdc+PjzweuKYjoXwNLxaAU0Jwdb0dFscalCfRdci946O+2A6cW2juHi0N0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770737681; c=relaxed/simple;
	bh=W8kyVxraQE/gyzrvvssvAoq8LuqVdSaxikQJEOzMG5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxa122o99PJPiBhRqv/2WBa5utWrCHl4VgqDGBpps/wXHG7OEsODQiGZMEyU5ajCb/dURyeU4I4QZ4uNdQd5ZZD8pVckcxg5lC7GYJG1Tdp8prlgzMhu0N/E+OSgBL/zzaBLs36KGzb41tfAd3Sc1uf3jDj4Sw52AVKd7bxsC0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WSQln4Py; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AAgreB326349;
	Tue, 10 Feb 2026 15:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PZJUnyuLZN7Jim0BW
	ZloIAy/evl5udfd6OcagJbzccE=; b=WSQln4Py3996ZvQ1MR7Msl1mEQk16k+XR
	Axfnb4lArzGTjh3bqEfmS4cAVjOYK36yI9qeSIwrLCgehdvsnMqy/dxiKMScO36/
	ALOEo/bIaYcwzN9zQrup30uuR9aAP0gnBO5Y94j45rXGWT/o0llJKrMf7QwY3pa7
	E5at0INtRAFOvmyVkrrsoEmf9gUMdwBeE79V4WjPFCG0Fehint5RJLr5GT1TN/2U
	BpBM/RAI69YonOSlZY9sQBjNTdtY1rQt/C2jYl4A4FjcpZzOpLf6hADH4KoeO5Kf
	nUL5QROEvmR8eIK8BpMTuWSfWQkcHPjtTUS3bNX7J6GCkH1JRipZA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696w4x9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61AEOkqR001479;
	Tue, 10 Feb 2026 15:34:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn1vfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 15:34:35 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AFYVrY27853170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 15:34:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4775020040;
	Tue, 10 Feb 2026 15:34:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA6D420043;
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.20.252])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Feb 2026 15:34:30 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@kernel.org
Subject: [GIT PULL v1 23/36] KVM: s390: Stop using CONFIG_PGSTE
Date: Tue, 10 Feb 2026 16:34:04 +0100
Message-ID: <20260210153417.77403-24-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=YeCwJgRf c=1 sm=1 tr=0 ts=698b500c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=WeuG7GAIFJ3A7Xv3FmEA:9
X-Proofpoint-GUID: mpsPjQ9tvO5slGsbZBLq5Ff7FURUdGnp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDEyOCBTYWx0ZWRfXynTt0POm1rCR
 KqqTUbrXvAqYrgewWVzw1uGwUSZBQUzXoxOgFOJRH+8rawTO+32snARCzvhH0nKRn+MlM3fhD9X
 1ZBRVXW59F/LAUQjbHWQmbOpmOzQc7KyBSmt0JjJDXftaDJp9amr0UsILFh91RKeZPraAT7l+eW
 OQvio0E1ZC9vjokGFaxw3d5MqCNXj0+9kiV1bIKN9/XFHyXj4hfFsJ2xOiSTbUGWe96R86IUP48
 1UMetEAngYJnmRGulVehkmI4cxACjghr1KmohdWdyQalcPpus4b3DfQ+C27QomMykCN32T9hIxM
 UcgTGm+/S6E3M6cpAmhfSEI/t9EgiB2X/EdPfH9ApSAUrNpPf1LuSwcg/wpu0H3F75LxkPrfjBD
 Vi44IglI7wYRc5Bral1V2naW6mu1YsQSLMFdyVq9E+JZMDyNxv+cVrGhXDL7U5mEdAtBlpajDfy
 yBm1xELTKl5w71Dhv0Q==
X-Proofpoint-ORIG-GUID: mpsPjQ9tvO5slGsbZBLq5Ff7FURUdGnp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100128
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70748-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: E23EE11C95E
X-Rspamd-Action: no action

Switch to using IS_ENABLED(CONFIG_KVM) instead of CONFIG_PGSTE, since
the latter will be removed soon.

Many CONFIG_PGSTE are left behind, because they will be removed
completely in upcoming patches. The ones replaced here are mostly the
ones that will stay.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/mmu_context.h | 2 +-
 arch/s390/include/asm/pgtable.h     | 4 ++--
 arch/s390/mm/fault.c                | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index d9b8501bc93d..48e548c01daa 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -29,7 +29,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	atomic_set(&mm->context.protected_count, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
-#ifdef CONFIG_PGSTE
+#if IS_ENABLED(CONFIG_KVM)
 	mm->context.has_pgste = 0;
 	mm->context.uses_skeys = 0;
 	mm->context.uses_cmm = 0;
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 04335f5e7f47..cd4d135c4503 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -577,7 +577,7 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 
 static inline int mm_is_protected(struct mm_struct *mm)
 {
-#ifdef CONFIG_PGSTE
+#if IS_ENABLED(CONFIG_KVM)
 	if (unlikely(atomic_read(&mm->context.protected_count)))
 		return 1;
 #endif
@@ -632,7 +632,7 @@ static inline pud_t set_pud_bit(pud_t pud, pgprot_t prot)
 #define mm_forbids_zeropage mm_forbids_zeropage
 static inline int mm_forbids_zeropage(struct mm_struct *mm)
 {
-#ifdef CONFIG_PGSTE
+#if IS_ENABLED(CONFIG_KVM)
 	if (!mm->context.allow_cow_sharing)
 		return 1;
 #endif
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e2e13778c36a..a52aa7a99b6b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -403,7 +403,7 @@ void do_dat_exception(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_dat_exception);
 
-#if IS_ENABLED(CONFIG_PGSTE)
+#if IS_ENABLED(CONFIG_KVM)
 
 void do_secure_storage_access(struct pt_regs *regs)
 {
@@ -470,4 +470,4 @@ void do_secure_storage_access(struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(do_secure_storage_access);
 
-#endif /* CONFIG_PGSTE */
+#endif /* CONFIG_KVM */
-- 
2.53.0


