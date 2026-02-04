Return-Path: <kvm+bounces-70224-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCQtFf5hg2nAmAMAu9opvQ
	(envelope-from <kvm+bounces-70224-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:13:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF2EE8212
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 16:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 74A5C30E8DCE
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 15:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECABA426D1C;
	Wed,  4 Feb 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QA6Qg8rO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90079425CE2;
	Wed,  4 Feb 2026 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217395; cv=none; b=PQOP3Oanh9FFPzTSCVgQ5LnjM/MMZ/hw6drOvhozHvRJzOckTBqVBR4qWEBiXgYg+uENUtw3qO2I5YIcFA8CuQaFXtk45WOQo4uYlt5nifpi74Hp30WKwR+FXy/pw+evmkJ72a3rTlnCHUIseoe3fF3Z/H7scjmE819JBSIyv5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217395; c=relaxed/simple;
	bh=igISKK7+v8BlipLv7r4rS7c4NKEeh58owjmh9HI5ruM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrvJ0HQb3za85yquYJIn8P5uuEOHTOShmrLF7r6JEHBUTM+82bSutrz12yAQ40HtEAd1tyE6i/b+0UrEy+d84Iy5/WLRv3E7yqzdm0jAEd10DYKv3HrKKILrj5oNOOjA519Axcin74/MOQh1Axk3fqVan3nVdio0X/wCpdAUThQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QA6Qg8rO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6149VkGQ016593;
	Wed, 4 Feb 2026 15:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gswWEi089zPf+dLFl
	41BgwM5CH+umFApMFEKUX6Stgg=; b=QA6Qg8rODGRFje9IDy/kQ+cSeDc0Iub92
	uwjbkzL3pOFeMkl7RpGsE+VgNELWGgNgFVDx9+fYXhD+Wy8+D22AbTKmgBZI8Ifi
	zKH5KBHNnpgLe5RsdyK2Ic5VmV2CYSQ6uvvzySMrFZ40wHfJ7zvrakx5GTBh6eBs
	iomh0iXK0bAU0VVgG3/lDfdDgSMGV9N1fg9bEDpUJ4vZFISyhgHEngEV/ziG+Qex
	GdfsWDGWxdoYrt5TKWcfu+ic0rdefhR9866Za/rhK1diDTIrQNdI9RhEhQlC0WL/
	s00I2FJ7Ex1XpoE1QGZau1ZRSUzLKhMv1jG7SJwkBbn60XOp4nu5Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gyw7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 614CRlX5004425;
	Wed, 4 Feb 2026 15:03:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjwk93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Feb 2026 15:03:10 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 614F36wF47645070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 4 Feb 2026 15:03:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B3402004E;
	Wed,  4 Feb 2026 15:03:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A5F52004D;
	Wed,  4 Feb 2026 15:03:06 +0000 (GMT)
Received: from p-imbrenda.aag-de.ibm.com (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  4 Feb 2026 15:03:06 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@kernel.org,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v7 22/29] KVM: s390: Stop using CONFIG_PGSTE
Date: Wed,  4 Feb 2026 16:02:51 +0100
Message-ID: <20260204150259.60425-23-imbrenda@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=69835faf cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=WeuG7GAIFJ3A7Xv3FmEA:9
X-Proofpoint-GUID: zrOETy3f5hFM0-09MtlXRYtyhsQDNnBT
X-Proofpoint-ORIG-GUID: zrOETy3f5hFM0-09MtlXRYtyhsQDNnBT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDExMyBTYWx0ZWRfX38vcIVH+78xl
 u+DDYpwfJdT51IsfhEagUYvNBdJjwznre+CLd23Li9JGL7wmAynt5BdfoILYlwrtwnS1cClrwQA
 5xIffXxpO/DsTd6Xliz6Dvmyf0xVAVpKH3KxfSayokWa6vKfVaF8kUXkZ13vhe2YDzBUK85VY2k
 Th/bmp7b7QrEMIPIoErRY7JhlbR0l0RSlzDL7bOXX7SjhlDHlKXD94wwcPJE346sNfo0cyHGcgP
 upe89uSXYMMft25QIT4msaL1XZP8MvrLIih8WV2fJmMB/pWhoYFv9UYd3lrOJqWqiYNuhdbgcdQ
 ArSNRKosFnxCcqelWXWEG1XKdU99qAbwyiUcUXFJbLkYg+WRxoCHxCbijg7MsrP6LVGT4ysEboA
 nCHAStyHBmHO3wtpNT4psBQ8aLNFeqttzS3J7tyqfNUMFRDN8mNi02HDJlP1y1PihCSebdzjQu+
 WgHBOd1PedVNwQyGgTg==
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70224-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.ibm.com:mid];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 0BF2EE8212
X-Rspamd-Action: no action

Switch to using IS_ENABLED(CONFIG_KVM) instead of CONFIG_PGSTE, since
the latter will be removed soon.

Many CONFIG_PGSTE are left behind, because they will be removed
completely in upcoming patches. The ones replaced here are mostly the
ones that will stay.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
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
2.52.0


