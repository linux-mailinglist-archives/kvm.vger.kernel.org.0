Return-Path: <kvm+bounces-70557-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLeCNSS9iGmmvQQAu9opvQ
	(envelope-from <kvm+bounces-70557-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 17:43:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8098F10974F
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 17:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6D6F3019839
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 16:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E86B258EDE;
	Sun,  8 Feb 2026 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dQ3PEOXB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+mBy3lA1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dQ3PEOXB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+mBy3lA1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1426B1DC997
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770568984; cv=none; b=CkAnYRipghWjIHWeTNQzHIDILOmveglCM+2i8c71eKjgG5FilIoMZzt87cc/phwUAE14lJAZ4V323YP75fxw8/SIPVDU41/16N2BtWpExMS0mOyVx7pmApPKVLWiUpJ9ihusLm3W6PnMGqPXRM77HAZDotXMPur37vg5G1vV9PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770568984; c=relaxed/simple;
	bh=7ga8ey+S+WsI7rjbEMDElhxozP0ToevHzdbgEl8wCBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jb3iXE0g87PqFRQKG7mcUWRYBc0EO1jM5bryzhHbduY7SB/93orMPXewOu/2VNbwvh3FT4PF4JiuJov0GSfS9cRg6OFmqloKGwK1euvYp5FT4fmytda18fkz2HqQQajehGYeqwtEwXRZJvPQf2QErF1B4V4MM/e5VGP10zHuP2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dQ3PEOXB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+mBy3lA1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dQ3PEOXB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+mBy3lA1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E4735BCDF;
	Sun,  8 Feb 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770568982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dPteStqC1EGaXLVEirmdOkrStpftmhePwOCUjlCU5is=;
	b=dQ3PEOXBY9G9qHDMi/6RrupOy+IDIK0RuEJ6RR+hii4pfgFVSOV5WtQmteHkT0NmXFpzaq
	2rO5gqHkjfHKrbI5x64GPd0VtwS956xvJx3pk5hnfCZiCNdcJwffqTs+9PeU8Pxo81/wHh
	5VHUeJhpEgSb4pvK5cweI1Opf6TmEFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770568982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dPteStqC1EGaXLVEirmdOkrStpftmhePwOCUjlCU5is=;
	b=+mBy3lA1mOmpnybt2oA1Dl8P2J4he0dr6DEyz0vtmat5bzndwaRUCVbue0RTempUFV1+te
	G1QV4x7OZFZLlfDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=dQ3PEOXB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+mBy3lA1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770568982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dPteStqC1EGaXLVEirmdOkrStpftmhePwOCUjlCU5is=;
	b=dQ3PEOXBY9G9qHDMi/6RrupOy+IDIK0RuEJ6RR+hii4pfgFVSOV5WtQmteHkT0NmXFpzaq
	2rO5gqHkjfHKrbI5x64GPd0VtwS956xvJx3pk5hnfCZiCNdcJwffqTs+9PeU8Pxo81/wHh
	5VHUeJhpEgSb4pvK5cweI1Opf6TmEFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770568982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dPteStqC1EGaXLVEirmdOkrStpftmhePwOCUjlCU5is=;
	b=+mBy3lA1mOmpnybt2oA1Dl8P2J4he0dr6DEyz0vtmat5bzndwaRUCVbue0RTempUFV1+te
	G1QV4x7OZFZLlfDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABE723EA63;
	Sun,  8 Feb 2026 16:43:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Af3kJRW9iGm9DQAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 08 Feb 2026 16:43:01 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: seanjc@google.com,
	bp@alien8.de,
	kvm@vger.kernel.org
Cc: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
Date: Sun,  8 Feb 2026 17:42:33 +0100
Message-ID: <20260208164233.30405-1-clopez@suse.de>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70557-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 8098F10974F
X-Rspamd-Action: no action

KVM incorrectly synthesizes TSA_SQ_NO and TSA_L1_NO when running
on AMD Family 19h CPUs by using SYNTHESIZED_F(), which unconditionally
enables features for KVM-only CPUID leaves (as is the case with
CPUID_8000_0021_ECX), regardless of the kernel's synthesis logic in
tsa_init(). This is due to the following logic in kvm_cpu_cap_init():

    if (leaf < NCAPINTS)
        kvm_cpu_caps[leaf] &= kernel_cpu_caps[leaf];

This can cause an unexpected failure on Family 19h CPUs during SEV-SNP
guest setup, when userspace issues SNP_LAUNCH_UPDATE, as setting these
bits in the CPUID page on vulnerable CPUs is explicitly rejected by SNP
firmware.

Switch to SCATTERED_F(), so that the bits are only set if the features
have been force-set by the kernel in tsa_init(), or if they are reported
in the raw CPUID.

Fixes: 31272abd5974 ("KVM: SVM: Advertise TSA CPUID bits to guests")
Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/kvm/cpuid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..819c176e02ff 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1230,8 +1230,8 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0021_ECX,
-		SYNTHESIZED_F(TSA_SQ_NO),
-		SYNTHESIZED_F(TSA_L1_NO),
+		SCATTERED_F(TSA_SQ_NO),
+		SCATTERED_F(TSA_L1_NO),
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0022_EAX,

base-commit: 0de4a0eec25b9171f2a2abb1a820e125e6797770
-- 
2.51.0


