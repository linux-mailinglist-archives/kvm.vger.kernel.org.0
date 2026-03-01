Return-Path: <kvm+bounces-72315-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLKVMKyeo2k3IQUAu9opvQ
	(envelope-from <kvm+bounces-72315-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 03:04:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A28871CCD0C
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 03:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 647773025E25
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 01:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D642F3C37;
	Sun,  1 Mar 2026 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hq9iX7h6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E9F29D270;
	Sun,  1 Mar 2026 01:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330375; cv=none; b=b34C0nkmvyneGS1Ox0S3JB68FKnZAiMWkzt4OARb4kNS0DxTCjFgqdXEgKkdkggB6J5C7G04HFeorOqmj/BIYZF30mAK17c3QiGslr+42yhl2z4ZZ/kyTqPG4F5NbM3KiHmMegP6fJRzmF0AMvHjiiS4YQ1fNg9/Hhcx42Feap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330375; c=relaxed/simple;
	bh=QYW9ZbmUcnfCPA/HyaxHglK9sIZNNwiB7LNSLhjZZGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p2dRvfwmdy2BzKEErKe+dVPxAg12gxMwLfEJnIHHjnrGqicRkK2Qaojl/V8A3Ld/GqbCZijus7StjmZHsKCMVufD97qyZ4IxGeTYAtRzpK1x+8rF5CkDnCjaaxAimTQbq35zGKSr02eR5ghIDdJ5lSErN/xBclL88/WEJsVlu7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hq9iX7h6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0EAC19421;
	Sun,  1 Mar 2026 01:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330375;
	bh=QYW9ZbmUcnfCPA/HyaxHglK9sIZNNwiB7LNSLhjZZGA=;
	h=From:To:Cc:Subject:Date:From;
	b=hq9iX7h6eC8g7elYJ0Z9LqVMUNye9UP/hTNrfCr8R3ZN5vpIKBQfIXqjQDKjFVrAj
	 wp3+dAZEHzefCRfEm53a7V5ksphIknP2DU7gzZIEe4BvA3x2h/+SSLlleqh1IE87A8
	 ss9C2By1oh5o36FNB4FGzOFgLqDJFqkrtce2lw7swGDc8hsu+ZAHGf4jIhKGmf+8vF
	 VCEXQvDc/ayZPVYJRoW0nj0r5txenTLntkpGRBP1PHmYdo9wiYtXiPeTGpHvH2fDk2
	 hZrocu5o7tlaTWiN6mz3oEDeQpVpIbXRjy67W+TTkTh7C0ynttY0EPblLxo/O3LQ+A
	 GWYYlL2ycaK1Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	seanjc@google.com
Cc: Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org
Subject: FAILED: Patch "KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 20:59:33 -0500
Message-ID: <20260301015933.1725367-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72315-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[msgid.link:url,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A28871CCD0C
X-Rspamd-Action: no action

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5bb9ac1865123356337a389af935d3913ee917ed Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 12:59:48 -0800
Subject: [PATCH] KVM: x86: Return "unsupported" instead of "invalid" on access
 to unsupported PV MSR

Return KVM_MSR_RET_UNSUPPORTED instead of '1' (which for all intents and
purposes means "invalid") when rejecting accesses to KVM PV MSRs to adhere
to KVM's ABI of allowing host reads and writes of '0' to MSRs that are
advertised to userspace via KVM_GET_MSR_INDEX_LIST, even if the vCPU model
doesn't support the MSR.

E.g. running a QEMU VM with

  -cpu host,-kvmclock,kvm-pv-enforce-cpuid

yields:

  qemu: error: failed to set MSR 0x12 to 0x0
  qemu: target/i386/kvm/kvm.c:3301: kvm_buf_set_msrs:
        Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Cc: stable@vger.kernel.org
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://patch.msgid.link/20251230205948.4094097-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 211d8c24a4b11..e4418409b468d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4097,47 +4097,47 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated);
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (kvm_pv_enable_async_pf_int(vcpu, data))
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 		if (data & 0x1) {
 			/*
 			 * Pairs with the smp_mb__after_atomic() in
@@ -4150,7 +4150,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (unlikely(!sched_info_on()))
 			return 1;
@@ -4168,7 +4168,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (kvm_lapic_set_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
@@ -4176,7 +4176,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		/* only enable bit supported */
 		if (data & (-1ULL << 1))
@@ -4477,61 +4477,61 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.apf.msr_en_val;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.st.msr_val;
 		break;
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.pv_eoi.msr_val;
 		break;
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
-- 
2.51.0





