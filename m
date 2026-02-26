Return-Path: <kvm+bounces-71947-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCpBAX0RoGnbfQQAu9opvQ
	(envelope-from <kvm+bounces-71947-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:25:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F981A354A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4954A304D1E1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6AAF3A0B3C;
	Thu, 26 Feb 2026 09:23:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D6C39A7E1;
	Thu, 26 Feb 2026 09:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=183.62.165.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772097792; cv=none; b=dWXo3NRQ3nPGxdfFZ0RAyXQHrJ5YHIjSdUuSWrO8yWltBatxxax5+rndhmTulvT/jv6oXr5ejg2dqxPZzoeTUTS+1+RwjoNRRpr9CcbnaqoEmJ3mmvf3qyWObbWR9Q28emIBmTa4oKG/B5uvvmoKFEhOAJcnAA3+PC7BY4tvXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772097792; c=relaxed/simple;
	bh=EEt0pYpCjdjDSmrcJYDA46rn86FBvdiBVTiCWFGLbbc=;
	h=Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type; b=TNshlADiywlblOoNDBdEIA2FgEkbp/oy6nQ0RSzCNppsqyhVI4uf5UJYTVEG4ydEym8mDSbQQrZqdi3z7NU0YAS1sns0dTb18GQqrrV+KIruWCln5Rg7gLY7mPxVRnEV4bbFNxo8g3kOyWvuasRqBzhVNm82ctL94ww7FknmEWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn; spf=pass smtp.mailfrom=zte.com.cn; arc=none smtp.client-ip=183.62.165.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4fM5bG064Bz51SW9;
	Thu, 26 Feb 2026 17:22:50 +0800 (CST)
Received: from szxlzmapp02.zte.com.cn ([10.5.231.79])
	by mse-fl1.zte.com.cn with SMTP id 61Q9MgoL033919;
	Thu, 26 Feb 2026 17:22:42 +0800 (+08)
	(envelope-from wang.yechao255@zte.com.cn)
Received: from mapi (szxl2zmapp07[null])
	by mapi (Zmail) with MAPI id mid12;
	Thu, 26 Feb 2026 17:22:45 +0800 (CST)
X-Zmail-TransId: 2b0969a010e5ff4-658a5
X-Mailer: Zmail v1.0
Message-ID: <20260226172245358qVZavIykLL2QC0KoqTO-I@zte.com.cn>
Date: Thu, 26 Feb 2026 17:22:45 +0800 (CST)
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
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UklTQy1WOiBLVk06IEZpeCBodWdlcGFnZSBtYXBwaW5nIGhhbmRsaW5nIGR1cmluZyBkaXJ0eSBsb2dnaW5n?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 61Q9MgoL033919
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: wang.yechao255@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 26 Feb 2026 17:22:50 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69A010EA.000/4fM5bG064Bz51SW9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.69 / 15.00];
	SUBJ_EXCESS_BASE64(1.50)[];
	R_BAD_CTE_7BIT(1.05)[unknown,utf8];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[zte.com.cn : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71947-lists,kvm=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[wang.yechao255@zte.com.cn,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,zte.com.cn:mid,zte.com.cn:email]
X-Rspamd-Queue-Id: 75F981A354A
X-Rspamd-Action: no action

From: Wang Yechao <wang.yechao255@zte.com.cn>

When dirty logging is enabled, the gstage page tables must be mapped
at PAGE_SIZE granularity to track dirty pages accurately. Currently,
if a huge PTE is encountered during the write-protect fault, the code
returns -EEXIST, which breaks VM migration.

Instead of returning an error, drop the huge PTE and map only the page
that is currently being accessed. This on‑demand approach avoids the
overhead of splitting the entire huge page into small pages upfront.

Signed-off-by: Wang Yechao <wang.yechao255@zte.com.cn>
---
 arch/riscv/kvm/gstage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d722c2..16c8afdafbfb 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -134,7 +134,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,

        while (current_level != map->level) {
                if (gstage_pte_leaf(ptep))
-                       return -EEXIST;
+                       set_pte(ptep, __pte(0));

                if (!pte_val(ptep_get(ptep))) {
                        if (!pcache)
-- 
2.27.0

