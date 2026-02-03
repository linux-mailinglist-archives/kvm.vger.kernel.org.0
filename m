Return-Path: <kvm+bounces-70040-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cEaUKG48gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70040-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:20:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D08DD7B5
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:20:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 08ABB30B2DCE
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A303D5253;
	Tue,  3 Feb 2026 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YQfLJV3U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A761F366833;
	Tue,  3 Feb 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142659; cv=none; b=NCnI5kPzgRoopXYfMVXFXRXQuZPZcLXHCjqCSzft2a/2iRG9HjKEX1Vce337NpVKhcTWCQPWbUPMNxWxV32vNQ8cbucsceRWgK9/GkM6c125Bjovuz6Xaqn01PqpmIVTf9mCMFPXWUNhOuEij+1eBtEPOS/AcEgU7BwsfnqE4X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142659; c=relaxed/simple;
	bh=6h76HamtuX5WAWZxbtzCPlZnwCKgGwSsmIJkkIJPz8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIDHeGUQ0cTrf+GZPvoDgVZPMES2mLs0/IpfN1lI3afJkARUmI0iCfZbpAN+kCocm8MCVjv01GOVPtIoawTBgfz0rJX5ZoPu/0iepd860dtKhP/jXHVlR247WBUZ1HmKsR9uj0/Qlyby2B1ZUHZR2FxrfNuEGcf+rpXFhs7XNvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YQfLJV3U; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142656; x=1801678656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6h76HamtuX5WAWZxbtzCPlZnwCKgGwSsmIJkkIJPz8A=;
  b=YQfLJV3U4W00bz3RsQwN46plVpbuHaXH36NgjNvtAXt7a+YHWCZlid3m
   j390G2IPC0mVc6DbzB+Xr2uRwJtwdiTf1reNMOwdNEcTprjGe9J9KBi0h
   zMnGPxwuJIUDYj8ER9yM3V+jMSAiYN/fcBSHkqTmrTaaAcpce+o9fRRLw
   AxHfJ6X2hHVol8zJZPz87bJSOv4Y74jB3Su+1KSLUScpoDBvNTU1fcpPQ
   7MBGBK3QKgnAaI2e6fmwiieg7gcnYOug41+X+rN/ESS32nbpy43jYqtV+
   zwqhWBFmETECCDsrtMWnnU2PxwKUehy6iquLNByJdeqOnYRI1UaGScb3b
   A==;
X-CSE-ConnectionGUID: RcSblYuhRq2wabtdF3UbfQ==
X-CSE-MsgGUID: 4ViusSTBSeenuNxiIuGaRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433182"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433182"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:36 -0800
X-CSE-ConnectionGUID: SHh7J4kKSOWnZnd07MoA5g==
X-CSE-MsgGUID: jyHEamHNSZOOrGgfhhKNtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727496"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:36 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/32] KVM: VMX: Update APIC timer virtualization on apicv changed
Date: Tue,  3 Feb 2026 10:16:50 -0800
Message-ID: <5f8655049106de981021d3d17bedc56574756678.1770116050.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70040-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 24D08DD7B5
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

VMX APIC timer virtualization requires the virtual-interrupt delivery.
It's part of KVM apicv, and when apicv state is changed, the
refresh_apicv_exec_ctrl() callback is invoked.  Export a lapic function to
update which timer to use for APIC timer emulation and make the VMX backend
call it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/lapic.c   | 6 ++++++
 arch/x86/kvm/lapic.h   | 1 +
 arch/x86/kvm/vmx/vmx.c | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 837f446eea41..a2f714eb78b1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1898,6 +1898,12 @@ static void apic_update_apic_virt_timer(struct kvm_lapic *apic)
 		apic_cancel_apic_virt_timer(apic);
 }
 
+void kvm_update_apic_virt_timer(struct kvm_vcpu *vcpu)
+{
+	apic_update_apic_virt_timer(vcpu->arch.apic);
+}
+EXPORT_SYMBOL_GPL(kvm_update_apic_virt_timer);
+
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
 	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d3fad67a4e78..3c597b670e7e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -250,6 +250,7 @@ void kvm_lapic_switch_to_apic_virt_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+void kvm_update_apic_virt_timer(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_lapic_apic_virt_timer_in_use(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dcb04fc0b8a7..82e1a0b2a8d2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4563,6 +4563,8 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 						 kvm_vcpu_apicv_active(vcpu));
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
+
+	kvm_update_apic_virt_timer(vcpu);
 }
 
 static u32 vmx_exec_control(struct vcpu_vmx *vmx)
-- 
2.45.2


