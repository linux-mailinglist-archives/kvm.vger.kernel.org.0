Return-Path: <kvm+bounces-70603-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +JslD0L/iWluFQAAu9opvQ
	(envelope-from <kvm+bounces-70603-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:37:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D89D5111F5E
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 16:37:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A29323053AAF
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 15:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CCF37FF43;
	Mon,  9 Feb 2026 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eEyAXYFZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XyUXDYo1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eEyAXYFZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XyUXDYo1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A51C37F8C1
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770651172; cv=none; b=I/5qas6I5uDsQVbKg6DsaT1QW51gD9ej3NVIBEi28aPIb8ndfJlNGm9AStH8qjhGrs+mgFYKogOsArA8Da2dDdn19C52FqGffXvv6ffxX0izOUd6dfkYddqL0taQUrbYcAlF0zO9IeIBOBNu/X1DQI3VILnJy6I8VybAgqKmAsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770651172; c=relaxed/simple;
	bh=2jzCKfkuATuKM2SWEkQKEYWWewW9IGVdQS9kCe5rsxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MnoM9bRsWNYvFU+aZfUe2WX1wLWG/UWum7DqIv+5dA1fVh2DV//RoF6bdS1dirmJ+/uDqEZatSV1CMbu3q7Z2xbc0/wLTRHWDWtBoIZmdwAKxg884PinxQ+dLeIqbPcQLZPxVBX9sDrxLZ9uqetnpXMT/UbAFQtQrcdAIYMHLMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eEyAXYFZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XyUXDYo1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eEyAXYFZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XyUXDYo1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A76DB5BD2F;
	Mon,  9 Feb 2026 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770651170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ogoGOvVFOpaxr4AtnTZjL8fQolKqHO93LqTA3g1vGXg=;
	b=eEyAXYFZyz1VkNawoWhvObrlZ1bjC2/cTkYeG/Nfpf+r5bBlvBl7D4MMnNbw6CYiNDzZLP
	GLareVVeQV/ZcySJuQMwB0MTLQvCVNt4eQC14lXzG7mM2iyouRBtI50VDjzoge+FFkQl6k
	wYvau7cp4LiuAcnBTD2TgMWfWgH65dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770651170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ogoGOvVFOpaxr4AtnTZjL8fQolKqHO93LqTA3g1vGXg=;
	b=XyUXDYo1ZtK2Pe4KpWTdRrvc4lW0ZaaFvWNYKm3999Kf2d50LMOK2DD4rMxY/EdmM7asC/
	MZbmn40mlVtIh6Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eEyAXYFZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XyUXDYo1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770651170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ogoGOvVFOpaxr4AtnTZjL8fQolKqHO93LqTA3g1vGXg=;
	b=eEyAXYFZyz1VkNawoWhvObrlZ1bjC2/cTkYeG/Nfpf+r5bBlvBl7D4MMnNbw6CYiNDzZLP
	GLareVVeQV/ZcySJuQMwB0MTLQvCVNt4eQC14lXzG7mM2iyouRBtI50VDjzoge+FFkQl6k
	wYvau7cp4LiuAcnBTD2TgMWfWgH65dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770651170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ogoGOvVFOpaxr4AtnTZjL8fQolKqHO93LqTA3g1vGXg=;
	b=XyUXDYo1ZtK2Pe4KpWTdRrvc4lW0ZaaFvWNYKm3999Kf2d50LMOK2DD4rMxY/EdmM7asC/
	MZbmn40mlVtIh6Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D846A3EA63;
	Mon,  9 Feb 2026 15:32:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JFLeMSH+iWkrKwAAD6G6ig
	(envelope-from <clopez@suse.de>); Mon, 09 Feb 2026 15:32:49 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: seanjc@google.com,
	bp@alien8.de,
	kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev,
	jmattson@google.com,
	binbin.wu@linux.intel.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v2] KVM: x86: synthesize CPUID bits only if CPU capability is set
Date: Mon,  9 Feb 2026 16:31:09 +0100
Message-ID: <20260209153108.70667-2-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.51
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70603-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D89D5111F5E
X-Rspamd-Action: no action

KVM incorrectly synthesizes CPUID bits for KVM-only leaves, as the
following branch in kvm_cpu_cap_init() is never taken:

    if (leaf < NCAPINTS)
        kvm_cpu_caps[leaf] &= kernel_cpu_caps[leaf];

This means that bits set via SYNTHESIZED_F() for KVM-only leaves are
unconditionally set. This for example can cause issues for SEV-SNP
guests running on Family 19h CPUs, as TSA_SQ_NO and TSA_L1_NO are
always enabled by KVM in 80000021[ECX]. When userspace issues a
SNP_LAUNCH_UPDATE command to update the CPUID page for the guest, SNP
firmware will explicitly reject the command if the page sets sets these
bits on vulnerable CPUs.

To fix this, check in SYNTHESIZED_F() that the corresponding X86
capability is set before adding it to to kvm_cpu_cap_features.

Fixes: 31272abd5974 ("KVM: SVM: Advertise TSA CPUID bits to guests")
Link: https://lore.kernel.org/all/20260208164233.30405-1-clopez@suse.de/
Signed-off-by: Carlos López <clopez@suse.de>
---
v2: fix SYNTHESIZED_F() instead of using SCATTERED_F() for TSA bits
 arch/x86/kvm/cpuid.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..5f41924987c7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -770,7 +770,10 @@ do {									\
 #define SYNTHESIZED_F(name)					\
 ({								\
 	kvm_cpu_cap_synthesized |= feature_bit(name);		\
-	F(name);						\
+								\
+	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
+	if (boot_cpu_has(X86_FEATURE_##name))			\
+		F(name);					\
 })
 
 /*
-- 
2.51.0


