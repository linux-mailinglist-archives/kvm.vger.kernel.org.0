Return-Path: <kvm+bounces-61100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8442C0B206
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E092118A0AEF
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B412FF17F;
	Sun, 26 Oct 2025 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="sj+KaCxk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0999026CE36;
	Sun, 26 Oct 2025 20:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510029; cv=none; b=G0kBsy4On+iBDzBSpL4TotBY/xZ36EcvARMSp2eOLu5DPSc1sfXBvrDM6tumlBGNOl4sq6Bs5fEpvjuLC0VVndA9ygOfhaD3RfDPBWqx/9OneokdUCoOqq+vRRdaUrhcfhOrdUzb+nnIm9StdUvxuIFEqnW4lnmdx8OKs+cXLK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510029; c=relaxed/simple;
	bh=+Ti3U2iWFOxfk+4TBSeD31fMJ8+GGFy+5e9O2xaoP6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KViWnlc9SNt24jiYYHNiERyDYKP9vu0mPA7uBvzzciIH4d7lJj8HmMoyTHR/BxNM6UkVuMla5uUpaImWseEk/1Dp50Jkei0KRaFJWBPcoYlYzbbpVPuQPrIKORWJ67qL/NBKVnGzUg9lYic8BQiNvGBhElsg+MeGruPBXEwancE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=sj+KaCxk; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkQ505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:28 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkQ505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509968;
	bh=wV2iUiWpl/EUipSO7vBpIEZc8tTBrJHJmk2xdYg7qAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sj+KaCxk33pxmyrFfVzVqEElN5HlaEooteqB3rCIDxbKwGH+esVeJLo4bt4xSSdm2
	 dXGKTIlFor+uM0pPW4NXbqyRhBKrm7RMrjv1BJ/Xr07hJ/7JxBoJcW9KI0xxG7PhGO
	 uk7JI7bCmFYnuGbbXXKbrxZtmBKlkYRkX9YAy4DUItkUFQIBIlIJMrq3lLuVzKRnbW
	 6j/cMnisVMFxj1azQE9LzJBbqM1X1Sgp6oNGIjGVYkw7CkOGt94ISMLi9/dRF2mW48
	 effCtSL8HP9Qg2isExGcMWlt1yWGjdVJs3vwRyXcIavO/TkEbHBAb0HZh+TzS+yS4I
	 n4PgWvYDBi8TA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 09/22] KVM: VMX: Save/restore guest FRED RSP0
Date: Sun, 26 Oct 2025 13:18:57 -0700
Message-ID: <20251026201911.505204-10-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Save guest FRED RSP0 in vmx_prepare_switch_to_host() and restore it
in vmx_prepare_switch_to_guest() because MSR_IA32_FRED_RSP0 is passed
through to the guest, thus is volatile/unknown.

Note, host FRED RSP0 is restored in arch_exit_to_user_mode_prepare(),
regardless of whether it is modified in KVM.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v5:
* Remove the cpu_feature_enabled() check when set/get guest
  MSR_IA32_FRED_RSP0, as guest_cpu_cap_has() should suffice (Sean).
* Add a comment when synchronizing current MSR_IA32_FRED_RSP0 MSR to
  the kernel's local cache, because its handling is different from
  the MSR_KERNEL_GS_BASE handling (Sean).
* Add TB from Xuelian Guo.

Changes in v3:
* KVM only needs to save/restore guest FRED RSP0 now as host FRED RSP0
  is restored in arch_exit_to_user_mode_prepare() (Sean Christopherson).

Changes in v2:
* Don't use guest_cpuid_has() in vmx_prepare_switch_to_{host,guest}(),
  which are called from IRQ-disabled context (Chao Gao).
* Reset msr_guest_fred_rsp0 in __vmx_vcpu_reset() (Chao Gao).
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef9765779884..c1fb3745247c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1292,6 +1292,9 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 
 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
 #else
 	savesegment(fs, fs_sel);
 	savesegment(gs, gs_sel);
@@ -1336,6 +1339,16 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	invalidate_tss_limit();
 #ifdef CONFIG_X86_64
 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
+
+	if (guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_FRED)) {
+		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
+		/*
+		 * Synchronize the current value in hardware to the kernel's
+		 * local cache.  The desired host RSP0 will be set when the
+		 * CPU exits to userspace (RSP0 is a per-task value).
+		 */
+		fred_sync_rsp0(vmx->msr_guest_fred_rsp0);
+	}
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
 	vmx->vt.guest_state_loaded = false;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 645b0343e88c..48a5ab12cccf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -227,6 +227,7 @@ struct vcpu_vmx {
 	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
 	u64		      msr_guest_kernel_gs_base;
+	u64		      msr_guest_fred_rsp0;
 #endif
 
 	u64		      spec_ctrl;
-- 
2.51.0


