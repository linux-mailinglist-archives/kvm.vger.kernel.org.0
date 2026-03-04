Return-Path: <kvm+bounces-72668-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPa7LcP6p2mtmwAAu9opvQ
	(envelope-from <kvm+bounces-72668-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:26:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 641161FD8C4
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 10:26:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 461EA3040DAD
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 09:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2BA396B7F;
	Wed,  4 Mar 2026 09:26:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B52E35CB70;
	Wed,  4 Mar 2026 09:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=160.30.148.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772616380; cv=none; b=HpylmyTEmjw/cLA2QPvZo6pgCyzxiVbB3NR8AzLQ4sG9OAptagwpRyH0hqad4DRDhl/x0LI7Lhr22nCdWdp5Yy3GUIWKZbBkkqNCf87uXM6kMrGNB4dpB1xMYXJk2bY1j+3oXo9l/hwiEz6yBmlF5LuT62jkQz2JBVMbh2x53pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772616380; c=relaxed/simple;
	bh=eKJCJEl2Ht+aniDNfplngtE/vhaYlBUnaWl07XDbyIk=;
	h=Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type; b=BRXE59W8Aooh7eX+5RYl02El2yk4HxVOwH9mORJbgiZlooc+fWf7N07c6wkTDiZqKhSwR1Z3E+otNcCUqOjhqBrLinCUOUj0Qx8/EcR0s8LHaqXkMrO/VWvPwQdC8IvzKwAbjQDNfYcxok67gk0DnN0F9uwzCctrDil1mtWID1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=160.30.148.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fQnNM1Dmvz5B12g;
	Wed, 04 Mar 2026 17:26:11 +0800 (CST)
Received: from szxl2zmapp07.zte.com.cn ([10.1.32.52])
	by mse-fl1.zte.com.cn with SMTP id 6249PwJO088803;
	Wed, 4 Mar 2026 17:25:58 +0800 (+08)
	(envelope-from wang.yechao255@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
	by mapi (Zmail) with MAPI id mid12;
	Wed, 4 Mar 2026 17:26:01 +0800 (CST)
X-Zmail-TransId: 2b0369a7faa9f44-4504a
X-Mailer: Zmail v1.0
Message-ID: <20260304172601396IhMZyDqdV3dRmc2rVopfJ@zte.com.cn>
In-Reply-To: <20260304172139131ChDubMSpGDUB03lY4UCbK@zte.com.cn>
References: 20260304172139131ChDubMSpGDUB03lY4UCbK@zte.com.cn
Date: Wed, 4 Mar 2026 17:26:01 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvM10gUklTQy1WOiBLVk06IEZpeCBsb3N0IHdyaXRlIHByb3RlY3Rpb24gb24gaHVnZSBwYWdlcwogZHVyaW5nIGRpcnR5IGxvZ2dpbmc=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6249PwJO088803
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yechao255@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Mar 2026 17:26:11 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69A7FAB3.000/4fQnNM1Dmvz5B12g
X-Rspamd-Queue-Id: 641161FD8C4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.64 / 15.00];
	SUBJ_EXCESS_BASE64(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[zte.com.cn : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72668-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[zte.com.cn:mid,zte.com.cn:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Wang Yechao <wang.yechao255@zte.com.cn>

When enabling dirty log in small chunks (e.g., QEMU default chunk
size of 256K), the chunk size is always smaller than the page size
of huge pages (1G or 2M) used in the gstage page tables. This caused
the write protection to be incorrectly skipped for huge PTEs because
the condition `(end - addr) >= page_size` was not satisfied.

Remove the size check in `kvm_riscv_gstage_wp_range()` to ensure huge
PTEs are always write-protected regardless of the chunk size. Additionally,
explicitly align the address down to the page size before invoking
`kvm_riscv_gstage_op_pte()` to guarantee that the address passed to the
operation function is page-aligned.

This fixes the issue where dirty pages might not be tracked correctly
when using huge pages.

Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>
---
 arch/riscv/kvm/gstage.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d722c2..d2001d508046 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -304,10 +304,9 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
 		if (!found_leaf)
 			goto next;

-		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
-			kvm_riscv_gstage_op_pte(gstage, addr, ptep,
-						ptep_level, GSTAGE_OP_WP);
-
+		addr = ALIGN_DOWN(addr, page_size);
+		kvm_riscv_gstage_op_pte(gstage, addr, ptep,
+					ptep_level, GSTAGE_OP_WP);
 next:
 		addr += page_size;
 	}
-- 
2.47.3

