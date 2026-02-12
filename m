Return-Path: <kvm+bounces-70960-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OOKH2bfjWnE8AAAu9opvQ
	(envelope-from <kvm+bounces-70960-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:10:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C918C12E275
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 196BC303322C
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2460D35C1B8;
	Thu, 12 Feb 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Sh1E5NJy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4GvtexwN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Sh1E5NJy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4GvtexwN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC1335C1B7
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 14:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770905442; cv=none; b=r7vflkyIbCJAP697O35t8gYFGnh+gQVfo3oQeUaQuK8S3RQOPm+UEpBbewoOqffQBLfsB/6ZA4wU+7CnYQ3jl2BcpH7JvDEfA2GqIfbfYkVkdcU6CCoT2LEXr4KzYajK/RXcTtOAryFsI2dAZguDAWUzTgSQkOKvLVdka9Qj+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770905442; c=relaxed/simple;
	bh=jDyKRBmt0G41/VH3KfVNBmriwhTGiamLDB//4wIkoz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C+OvFdhGZeVJAHrJNKWYyc6HXz96mmFU6SCUpsBqnIzbaElObukn5oxn/7+zjAL8v4Xs91edIfYamdIlaEcv9Yc2DE92NhS3kwudbPEOcQ+jSFvpJENxVR4rJbZMxn9XQhZwJHxJnTTGmQfdUBnyl67ICL8swtsXcItxAN35OBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Sh1E5NJy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4GvtexwN; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Sh1E5NJy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4GvtexwN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 52B333E6DD;
	Thu, 12 Feb 2026 14:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770905439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/YrbUClmQVL1U5uh49SxY9lMMVv9VNYSFUFYMwRRmQA=;
	b=Sh1E5NJyPsuCoJnfDS59MPtfBo+qDL5BZ8Ahy+W1Y1FFR3gpQDJhO7vRere+4IhvfE7SMh
	LJShsWZSEe9a8qt/GHT19eOCd8h+4p4HEJZ8b7fiVb4l/wH4XuiYPMhcb2N8eLrm2kBFwm
	hI+ANLPW0kMpsvO0DhKE50kiTDFxm6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770905439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/YrbUClmQVL1U5uh49SxY9lMMVv9VNYSFUFYMwRRmQA=;
	b=4GvtexwNPsZ3e4rJ71vocCu2u5M6Z3E8fS6WgYAT8Yae8Da4QoJefjrTVUlXXH9W8ZAgqI
	/lHKxdMCobN6IMCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770905439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/YrbUClmQVL1U5uh49SxY9lMMVv9VNYSFUFYMwRRmQA=;
	b=Sh1E5NJyPsuCoJnfDS59MPtfBo+qDL5BZ8Ahy+W1Y1FFR3gpQDJhO7vRere+4IhvfE7SMh
	LJShsWZSEe9a8qt/GHT19eOCd8h+4p4HEJZ8b7fiVb4l/wH4XuiYPMhcb2N8eLrm2kBFwm
	hI+ANLPW0kMpsvO0DhKE50kiTDFxm6M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770905439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/YrbUClmQVL1U5uh49SxY9lMMVv9VNYSFUFYMwRRmQA=;
	b=4GvtexwNPsZ3e4rJ71vocCu2u5M6Z3E8fS6WgYAT8Yae8Da4QoJefjrTVUlXXH9W8ZAgqI
	/lHKxdMCobN6IMCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C5C13EA62;
	Thu, 12 Feb 2026 14:10:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gAuEG17fjWkSJAAAD6G6ig
	(envelope-from <clopez@suse.de>); Thu, 12 Feb 2026 14:10:38 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
	linux-hardening@vger.kernel.org (open list:KERNEL HARDENING (not covered by other areas):Keyword:\b__counted_by(_le|_be)?\b)
Subject: [PATCH] KVM: x86/pmu: annotate struct kvm_x86_pmu_event_filter with __counted_by()
Date: Thu, 12 Feb 2026 15:05:56 +0100
Message-ID: <20260212140556.3883030-2-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70960-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clopez@suse.de,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C918C12E275
X-Rspamd-Action: no action

struct kvm_x86_pmu_event_filter has a flexible array member, so annotate
it with the field that describes the amount of entries in such array.
Opportunistically replace the open-coded array size calculation with
flex_array_size() when copying the array portion of the struct from
userspace.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/pmu.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..d9159b969bd9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1261,7 +1261,7 @@ struct kvm_x86_pmu_event_filter {
 	__u32 nr_excludes;
 	__u64 *includes;
 	__u64 *excludes;
-	__u64 events[];
+	__u64 events[] __counted_by(nevents);
 };
 
 enum kvm_apicv_inhibit {
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index bd6b785cf261..e218352e3423 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1256,7 +1256,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 
 	r = -EFAULT;
 	if (copy_from_user(filter->events, user_filter->events,
-			   sizeof(filter->events[0]) * filter->nevents))
+			   flex_array_size(filter, events, filter->nevents)))
 		goto cleanup;
 
 	r = prepare_filter_lists(filter);

base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.51.0


