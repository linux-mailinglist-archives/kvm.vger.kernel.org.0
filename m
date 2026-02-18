Return-Path: <kvm+bounces-71214-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJdNM8B2lWlwRwIAu9opvQ
	(envelope-from <kvm+bounces-71214-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 09:22:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C2A153F59
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 09:22:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DC67E30151C4
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 08:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BF131D371;
	Wed, 18 Feb 2026 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LxzG3ESO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LxzG3ESO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3263C31A56B
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 08:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402922; cv=none; b=pEIv7RbZ/AtmyVT1q2XAZtQ01UDCRInXtSwf7c0bk5l4+AScPq+xUt6nEEfbZR7+yB5L3LidFzfoQ9LpojkcpFxtySGtvvk8ObYu2VG1BGr05vYaUZmQ4COS5WVKl8cWlZSTgeQKBkvlAjN8/nIv6yOfRJkLSrxx3v4v/YrXwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402922; c=relaxed/simple;
	bh=TH3DH5sZ3YyRQn+6E5BlnD/gSVwnhrm79PHvlpsEKiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHyxXFQ4JvN04R+c2ykx69ChZBsNS9NfaEqyr7eUZChfGhJlKkfSIKBciTUXg2m0CKnf69ur2noT0M+FaekVeAyRVjxtiB/iERlkS5leeh4QduvChR0Gu5+vJDGa+wjOBCBrSrbn0z/iMRw16XnCcvZTMP+iVJLWmb+8d2rBc7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LxzG3ESO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LxzG3ESO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9597F5BCCC;
	Wed, 18 Feb 2026 08:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771402918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pu+C5dLQu/zzPEFzF00OQIZX29gA4v0cXo/52IprP4w=;
	b=LxzG3ESOgat3VqxxKOzEShuCAKqlv1ZCdstEbXVdOTndy+wHsGw1C+YomfAUSFl4B3byGH
	k0q4zkkQr3q93tR7l1c4SetJEJu1grJKgfLaSStRRFZlIrLrJ1IEyLMduNRZ5+ivsX6zMP
	NH15wDHHoQQQc0kXodAZPya6VeWS7AI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771402918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pu+C5dLQu/zzPEFzF00OQIZX29gA4v0cXo/52IprP4w=;
	b=LxzG3ESOgat3VqxxKOzEShuCAKqlv1ZCdstEbXVdOTndy+wHsGw1C+YomfAUSFl4B3byGH
	k0q4zkkQr3q93tR7l1c4SetJEJu1grJKgfLaSStRRFZlIrLrJ1IEyLMduNRZ5+ivsX6zMP
	NH15wDHHoQQQc0kXodAZPya6VeWS7AI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3CE2B3EA65;
	Wed, 18 Feb 2026 08:21:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EKTVDaZ2lWldHgAAD6G6ig
	(envelope-from <jgross@suse.com>); Wed, 18 Feb 2026 08:21:58 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v3 04/16] KVM: x86: Remove the KVM private read_msr() function
Date: Wed, 18 Feb 2026 09:21:21 +0100
Message-ID: <20260218082133.400602-5-jgross@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260218082133.400602-1-jgross@suse.com>
References: <20260218082133.400602-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71214-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[14];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgross@suse.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 88C2A153F59
X-Rspamd-Action: no action

Instead of having a KVM private read_msr() function, just use rdmsrq().

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
V2:
- remove the helper and use rdmsrq() directly (Sean Christopherson)
---
 arch/x86/include/asm/kvm_host.h | 10 ----------
 arch/x86/kvm/vmx/tdx.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..9034222a96e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2347,16 +2347,6 @@ static inline void kvm_load_ldt(u16 sel)
 	asm("lldt %0" : : "rm"(sel));
 }
 
-#ifdef CONFIG_X86_64
-static inline unsigned long read_msr(unsigned long msr)
-{
-	u64 value;
-
-	rdmsrq(msr, value);
-	return value;
-}
-#endif
-
 static inline void kvm_inject_gp(struct kvm_vcpu *vcpu, u32 error_code)
 {
 	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5df9d32d2058..d9e371e39853 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -801,7 +801,7 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (likely(is_64bit_mm(current->mm)))
 		vt->msr_host_kernel_gs_base = current->thread.gsbase;
 	else
-		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+		rdmsrq(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 
 	vt->guest_state_loaded = true;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d..3799cbbb4577 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1403,8 +1403,8 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	} else {
 		savesegment(fs, fs_sel);
 		savesegment(gs, gs_sel);
-		fs_base = read_msr(MSR_FS_BASE);
-		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+		rdmsrq(MSR_FS_BASE, fs_base);
+		rdmsrq(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 	}
 
 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
@@ -1463,7 +1463,7 @@ static u64 vmx_read_guest_host_msr(struct vcpu_vmx *vmx, u32 msr, u64 *cache)
 {
 	preempt_disable();
 	if (vmx->vt.guest_state_loaded)
-		*cache = read_msr(msr);
+		rdmsrq(msr, *cache);
 	preempt_enable();
 	return *cache;
 }
-- 
2.53.0


