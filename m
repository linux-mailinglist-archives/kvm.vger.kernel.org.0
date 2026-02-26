Return-Path: <kvm+bounces-71958-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDa6FM0qoGlrfwQAu9opvQ
	(envelope-from <kvm+bounces-71958-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:13:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD9C1A4E62
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 12:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05912302E0D9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79ED93385AB;
	Thu, 26 Feb 2026 11:12:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B9A2AE68;
	Thu, 26 Feb 2026 11:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772104363; cv=none; b=LBJRKgMrJEGX9JNFdQg0KDp21NblD7dd14DBXtwwmKItZNdPOtVKvNYc8XShslLehpYTApoDfXErzLkd1NPB1JrC24cKTaBOP9nag1WqYuY+zm9igwLklLPrHwON+6MYxW4jFwu0InNCuo2ZIlxiGstkAzg7eUxzT3mcCyq9Yko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772104363; c=relaxed/simple;
	bh=DjNpO2hAfKU/lwA0bOanMBB73d04jcQxi9kOKB0ci/U=;
	h=Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type; b=QbB8Wl/5a5XEIvlcwZSgB15u9XeOT909F6O8n1woJzF1Wc6nP6jvRQppRnnEDtCOKobZTtN0CFAJnIJTIpZz9XlF2Jo+eecfAQ1giewnOlKjLDfXhTPG3tMB1m+KKRQeQsv/mQcZoJG0yz/MvCNJDC6scHhrCd0SJIem7gnc94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fM81r3FFGz5B12j;
	Thu, 26 Feb 2026 19:12:32 +0800 (CST)
Received: from szxlzmapp03.zte.com.cn ([10.5.231.207])
	by mse-fl2.zte.com.cn with SMTP id 61QBCSIt045768;
	Thu, 26 Feb 2026 19:12:28 +0800 (+08)
	(envelope-from wang.yechao255@zte.com.cn)
Received: from mapi (szxl2zmapp05[null])
	by mapi (Zmail) with MAPI id mid12;
	Thu, 26 Feb 2026 19:12:31 +0800 (CST)
X-Zmail-TransId: 2b0769a02a9fca6-36487
X-Mailer: Zmail v1.0
Message-ID: <20260226191231140_X1Juus7s2kgVlc0ZyW_K@zte.com.cn>
Date: Thu, 26 Feb 2026 19:12:31 +0800 (CST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: <wang.yechao255@zte.com.cn>
To: <anup@brainfault.org>, <atish.patra@linux.dev>, <pjw@kernel.org>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
        <liu.xuemei1@zte.com.cn>
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBSSVNDLVY6IEtWTTogU2tpcCBUSFAgc3VwcG9ydCBjaGVjayBkdXJpbmcgZGlydHkgbG9nZ2luZw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 61QBCSIt045768
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yechao255@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 26 Feb 2026 19:12:32 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69A02AA0.001/4fM81r3FFGz5B12j
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.64 / 15.00];
	SUBJ_EXCESS_BASE64(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[zte.com.cn : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71958-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[wang.yechao255@zte.com.cn,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zte.com.cn:mid,zte.com.cn:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BAD9C1A4E62
X-Rspamd-Action: no action

From: Wang Yechao <wang.yechao255@zte.com.cn>

When dirty logging is enabled, guest stage mappings are forced to
PAGE_SIZE granularity. Changing the mapping page size at this point
is incorrect.

Fixes: ed7ae7a34bea ("RISC-V: KVM: Transparent huge page support")
Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>
---
 arch/riscv/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 0b75eb2a1820..c3539f660142 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -535,7 +535,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
                goto out_unlock;

        /* Check if we are backed by a THP and thus use block mapping if possible */
-       if (vma_pagesize == PAGE_SIZE)
+       if (!logging && (vma_pagesize == PAGE_SIZE))
                vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva, &hfn, &gpa);

        if (writable) {
-- 
2.27.0

