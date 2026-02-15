Return-Path: <kvm+bounces-71113-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FEFMGzhkWkxngEAu9opvQ
	(envelope-from <kvm+bounces-71113-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:08:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2786613EF8B
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 16:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 07B5030028F4
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 15:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491B222756A;
	Sun, 15 Feb 2026 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="CQCBsr2h"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B36C1E5B7B
	for <kvm@vger.kernel.org>; Sun, 15 Feb 2026 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771168100; cv=none; b=q9s8CQBp7njImLHjWpR0Lj/3fYTNILZ/rMEuWth+y0o5FpWHMzJHs115tJI3gddMt85q9r/9cP8Q0FnNq3ldLhnUPo0sUnRnRNqhaXgcZhCK/T8c/rFOQ2wWhNGANDd87tv3udQi8ZRN3DNsiQljKMFBs8JQu2DhE1HE5YeHO2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771168100; c=relaxed/simple;
	bh=V08+o2yXur7pI17jTybJG/CqAlMqrlVHpgja2XEXPa8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=SKBAPb8DxAp/ttVbc5LSeY5JKCUOR8N1Vz3SZy1ehWkDhR4P0lhZx1aUsXsmpevoFQ8YVZ18xbj+2oSgblEmhRnDoCVjTVSCCEiAQV/iCMrZRe1CyPeFHyFkSpwVGzR51bHhAv0ARGXzptgPK4IkxxDLvn5w8ZfCdU3/Mp2okQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=CQCBsr2h; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1771168086; bh=bnsRtCdhJSZDx2jLt0N8Jhj0RomGtQGeG4Mj/IZEaWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQCBsr2hyJ1hfKoAUMTFlKkTdMf4v+Gm3QeZLJ22RF3PykojaRzcqfW2B4+5B89Rc
	 cPH14tYkxwYpIchgnJQYRfWtIGckgouvlJ1O9rSYPDgV740VPEitJJMt+Ovkl4c21L
	 mPuyaOzQRDcRlLuLKk30J/eIN+V0HHUrr1ugQaMs=
Received: from pve.sebastian ([118.250.2.92])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 10481CF7; Sun, 15 Feb 2026 22:04:04 +0800
X-QQ-mid: xmsmtpt1771164248tkg82h8la
Message-ID: <tencent_A1CC0E76805991513AA0C982068255A6A306@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoeSKU2iL/mCI88NVWqz26dHwT9E54jNLo7h8WwVAeNmVkeTQ0YMD
	 Z1aMig46FGSYV8PbRLecIwL8IeFdqOaEuyN7D6PHyOyWQWNPgXtuezs1LDfHkIlK+yDQ0SGKcO99
	 AWdt41PxZ/o46vWSVret630gHUJkyZTgVASPk0LXtlF5smDa4iPcKnPUIHh3ZrW+kUl0eQcgKhji
	 PZBFJlYPJ96S6NE+6w3WN4fJYepBHuXPWHABdyrrjkWME38gaRZbrAvXtfeGrmvA8vWLHlWZmIk+
	 aXcXc5SSRAD4yInUlmTdfm2Vs2KclXprYJdTwIvhnx77CjqdnKC2KeBrSN3vdkjC88xE8ktcMvcC
	 vyUop8Jbk3Tn5vCWysEDaZTBl/7XbRayfB2SYUo4HowfwA1x47xTYUaYC5XvwKClFJhjzzYwIvN5
	 su3db+OLsYyBc0ukXJ7ObFX28WIighb1PMUFefGLEMtX3uJ4ne9XeBQC4r2mssAhBCzvOL/K7YZ8
	 tKU74dW3iG2f8X/EfubyktHCtuKW1jWlRbnIdd72Fm5wRRgPUmzE0PvqnpRk0ePSHkIFGgGhAi3w
	 W+DffBadFiC8We/s4VN2PCqJqCfxeF30yq63eMUktZvu9yXes9JKoWwCpgDn7icZ+d+57DsvTBJ8
	 pizqB07BUbXqSY14hor7YxIeD2nYJh8ZVWgWeDaO+hjUCoqeasz81NCKI3j68Ax9OTAR/wFStHJO
	 ntqXwJ0y4C6WCXZr3odIULpMlssS52E3OWiY4tQRqxtD+PIXB3w6JRbF/nZjthtguoEG6Tsf+70A
	 kIJoRcBPhnn9tR9bIYRckBgSn2nPK+reV5QTFYrMKVmVJZtL/reAaDlBcYszh8LaCkMPMTfywbD7
	 9xyz409mBefJAOCFsh5Ty3dsdyA6Q1A5CeumeZe1RNJdPuFGjeMTtJ+1iJXBNCJ8STOlYE7yONHY
	 i+THJO+fpqHDqGQYExA4GkxH8QV2Tkv+OmaIf7eQ+0m2tw6mwPb/F1c+5v0EfDrlDecUIW5fXgBp
	 s/LX16FrSE5r7m+Ugyxw/pjJWhbzUndEc1xFjGMw==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: 76824143@qq.com
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	zhanghao <zhanghao1@kylinos.cn>
Subject: [PATCH 2/3] KVM: x86: Skip IN_GUEST_MODE vCPUs in kvm_vcpu_on_spin main loop
Date: Sun, 15 Feb 2026 22:04:01 +0800
X-OQ-MSGID: <20260215140402.24659-3-76824143@qq.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260215140402.24659-1-76824143@qq.com>
References: <20260215140402.24659-1-76824143@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[qq.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[qq.com:s=s201512];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71113-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[qq.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[76824143@qq.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[qq.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:mid,qq.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kylinos.cn:email]
X-Rspamd-Queue-Id: 2786613EF8B
X-Rspamd-Action: no action

From: zhanghao <zhanghao1@kylinos.cn>

Add a check in the kvm_vcpu_on_spin() main loop to skip vCPUs
that are already running in guest mode.

Reduces unnecessary yield_to() calls and VM exits.

Signed-off-by: zhanghao <zhanghao1@kylinos.cn>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 476ecdb18bdd..663df3a121c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4026,6 +4026,10 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 		vcpu = xa_load(&kvm->vcpu_array, idx);
 		if (!READ_ONCE(vcpu->ready))
 			continue;
+
+		if (READ_ONCE(vcpu->mode) == IN_GUEST_MODE)
+			continue;
+
 		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
 			continue;
 
-- 
2.39.2


