Return-Path: <kvm+bounces-72671-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFxCHNr7p2mvnAAAu9opvQ
	(envelope-from <kvm+bounces-72671-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:31:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6DF1FD99F
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:31:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C1D6B3046AB8
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 09:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1F13988ED;
	Wed,  4 Mar 2026 09:30:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECF53542E1;
	Wed,  4 Mar 2026 09:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616658; cv=none; b=j4E1qw2XikzPSo0AIyLj4H8RFvDSyIpEZRilwwcnjTgltwD31qt8r2zeCZePoozIlo3UXrqe/Ejr/DeQ0CZRYITIa1Za+AyuCQWU2RX7M310K1su5LaQlzK1dS2G/vdGWi2hBokDTh0SyZ8m4g/fsoPtBDoW3EpAdXq1LcgQdPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616658; c=relaxed/simple;
	bh=nMell/kkU0VvEVuaTGzTi4X9ynwOzwk/jFX27NlmQYs=;
	h=Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=M5LFs79yVGkMgtwT1YIR6ehT7UwjBCttdp5nNGiQulXzzFW7h1nHjAmPZ3v/+PB2YzomkZ240ZHGHlxLUdXw+hIP1wkoU+xoYOEJTC/z89dyEALpkwlKdLimT5efFOi8onCvgOY30kd8YHupEFQChjKbwqgM70fQDRz7sz3kdLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fQnTq1RMmz8Xs72;
	Wed, 04 Mar 2026 17:30:55 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl1.zte.com.cn with SMTP id 6249Uk2v099658;
	Wed, 4 Mar 2026 17:30:46 +0800 (+08)
	(envelope-from wang.yechao255@zte.com.cn)
Received: from mapi (szxl2zmapp06[null])
	by mapi (Zmail) with MAPI id mid12;
	Wed, 4 Mar 2026 17:30:49 +0800 (CST)
X-Zmail-TransId: 2b0869a7fbc9022-35137
X-Mailer: Zmail v1.0
Message-ID: <20260304173049328qFHOTh8G2sgzCY7pyCVpr@zte.com.cn>
In-Reply-To: <20260304172139131ChDubMSpGDUB03lY4UCbK@zte.com.cn>
References: 20260304172139131ChDubMSpGDUB03lY4UCbK@zte.com.cn
Date: Wed, 4 Mar 2026 17:30:49 +0800 (CST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <wang.yechao255@zte.com.cn>
To: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <wang.yechao255@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYyIDMvM10gUklTQy1WOiBLVk06IFNwbGl0IGh1Z2UgcGFnZXMgZHVyaW5nIGZhdWx0IGhhbmRsaW5nIGZvcgoKIGRpcnR5IGxvZ2dpbmc=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6249Uk2v099658
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yechao255@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Mar 2026 17:30:55 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69A7FBCF.000/4fQnTq1RMmz8Xs72
X-Rspamd-Queue-Id: 0E6DF1FD99F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.64 / 15.00];
	SUBJ_EXCESS_BASE64(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[zte.com.cn : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72671-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[wang.yechao255@zte.com.cn,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,zte.com.cn:mid,zte.com.cn:email]
X-Rspamd-Action: no action

From: Wang Yechao <wang.yechao255@zte.com.cn>

During dirty logging, all huge pages are write-protected. When the guest
writes to a write-protected huge page, a page fault is triggered. Before
recovering the write permission, the huge page must be split into smaller
pages (e.g., 4K). After splitting, the normal mapping process proceeds,
allowing write permission to be restored at the smaller page granularity.

This ensures that dirty logging works correctly with huge pages.

Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>
---
 arch/riscv/kvm/gstage.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index 92331e9b0bb8..27ea6bb81553 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -171,6 +171,9 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
 {
 	pgprot_t prot;
 	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;

 	out_map->addr = gpa;
 	out_map->level = 0;
@@ -179,6 +182,12 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
 	if (ret)
 		return ret;

+	found_leaf = kvm_riscv_gstage_get_leaf(gstage, gpa, &ptep, &ptep_level);
+	if (found_leaf && ptep_level > out_map->level) {
+		kvm_riscv_gstage_split_huge(gstage, pcache, gpa,
+					    out_map->level, true);
+	}
+
 	/*
 	 * A RISC-V implementation can choose to either:
 	 * 1) Update 'A' and 'D' PTE bits in hardware
-- 
2.47.3

