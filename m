Return-Path: <kvm+bounces-36832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4E5A21A9D
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 11:01:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B2E3A6254
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 10:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCAC1BEF87;
	Wed, 29 Jan 2025 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M+T4zBy9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619391B4230;
	Wed, 29 Jan 2025 10:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738144816; cv=none; b=K9mpiki/4jUayP6QFvsWztMvlAwjEOtjvPDu5Br5tVQgRbbESemw1BSy/fkPSVxR7aMiVOFylbTUaJQ0UjRPFdYpX9NMZmiEUEHk52tYTTi9rh1Ug37IXlHtVBuYIF6g9e9wpmRNcSwrSUAwElZQQRwTmeohLC8LTbOO+xcw3l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738144816; c=relaxed/simple;
	bh=N5c0i7v7FOq2ySIZVHmG6YwndHPT4au+Y9Zs3T3d7Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5O0lnerOhH8gPk0Cs6Ht4OdAjclFtX5BNFOJdfWDrE/NqEE7fQI/AmgVuZGRZiuG2YYzAqwKRMawQt2OoNpBUra7dRVGK0fZsqvPy6aE16MkVzstVTqikXFk6VnKUrHli/4lpV+efCacW8fF9didVnEKs8GE9LHRVt+HdPEylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M+T4zBy9; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738144814; x=1769680814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N5c0i7v7FOq2ySIZVHmG6YwndHPT4au+Y9Zs3T3d7Qk=;
  b=M+T4zBy9EELQpRmfFbLXzMPPf8R8HXkQ7PI3JGg+AGV0FAlW1SF1BrMW
   cjOwWNg/3DSoCzyLT750q+Wy1k9VRJeQ6VmwhVPkid7lFHlAl7ibL3tg0
   al3n4j+BZsCxlTPQt8JSKVTRDF8txP+hE2PcTPFqbYOVqQbeo4gBBjoDJ
   lzQW3skBzjJn9+uvth5nAl65RwlwCI/BF0asxQQIhMukyYl5V1hmYZHjd
   xJ7uXco7XrHUBa0iGXEPvQet0JDfAxiJyrMeGv+1vJBCpLF0KGdttFuLW
   fEoDDrvL71hA0+mJdpgXH5XAjVleyTQNH8dPTOAUPHQ3Bbg7e9kA35W8G
   Q==;
X-CSE-ConnectionGUID: JGdG5H+nSCO7NR5Eaj1uuQ==
X-CSE-MsgGUID: HP/95svBRhes3SHkQ71UtA==
X-IronPort-AV: E=McAfee;i="6700,10204,11329"; a="50036040"
X-IronPort-AV: E=Sophos;i="6.13,243,1732608000"; 
   d="scan'208";a="50036040"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:53 -0800
X-CSE-ConnectionGUID: bYHOkFg5T2Kj/wdL4Dykfg==
X-CSE-MsgGUID: vnw7UWpgQr+H37bFV2depg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132262699"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.ger.corp.intel.com) ([10.246.0.178])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2025 01:59:49 -0800
From: Adrian Hunter <adrian.hunter@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH V2 07/12] KVM: TDX: restore host xsave state when exit from the guest TD
Date: Wed, 29 Jan 2025 11:58:56 +0200
Message-ID: <20250129095902.16391-8-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250129095902.16391-1-adrian.hunter@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

On exiting from the guest TD, xsave state is clobbered.  Restore xsave
state on TD exit.

Set up guest state so that existing kvm_load_host_xsave_state() can be
used. Do not allow VCPU entry if guest state conflicts with the TD's
configuration.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
TD vcpu enter/exit v2:
 - Drop PT and CET feature flags (Chao)
 - Use cpu_feature_enabled() instead of static_cpu_has() (Chao)
 - Restore PKRU only if the host value differs from defined
   exit value (Chao)
 - Use defined masks to separate XFAM bits into XCR0/XSS (Adrian)
 - Use existing kvm_load_host_xsave_state() in place of
   tdx_restore_host_xsave_state() by defining guest CR4, XCR0, XSS
   and PKRU (Sean)
 - Do not enter if vital guest state is invalid (Adrian)

TD vcpu enter/exit v1:
 - Remove noinstr on tdx_vcpu_enter_exit() (Sean)
 - Switch to kvm_host struct for xcr0 and xss

v19:
 - Add EXPORT_SYMBOL_GPL(host_xcr0)

v15 -> v16:
 - Added CET flag mask
---
 arch/x86/kvm/vmx/tdx.c | 72 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3f3d61935a58..e4355553569a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -83,16 +83,21 @@ static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
 	return val;
 }
 
+/*
+ * Before returning from TDH.VP.ENTER, the TDX Module assigns:
+ *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9, 18:17)
+ *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
+ */
+#define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9) | GENMASK(18, 17))
+#define TDX_XFAM_XSS_MASK	(BIT(8) | GENMASK(16, 10))
+#define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)
+
 static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
 {
 	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
 
-	/*
-	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
-	 * and, CET support.
-	 */
-	val |= XFEATURE_MASK_PT | XFEATURE_MASK_CET_USER |
-	       XFEATURE_MASK_CET_KERNEL;
+	/* Ensure features are in the masks */
+	val &= TDX_XFAM_MASK;
 
 	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
 		return 0;
@@ -724,6 +729,19 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	return vcpu->arch.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK) ||
+	       vcpu->arch.ia32_xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK) ||
+	       vcpu->arch.pkru ||
+	       (cpu_feature_enabled(X86_FEATURE_XSAVE) &&
+		!kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) ||
+	       (cpu_feature_enabled(X86_FEATURE_XSAVES) &&
+		!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES));
+}
+
 static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -740,6 +758,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
 	/*
 	 * force_immediate_exit requires vCPU entering for events injection with
 	 * an immediately exit followed. But The TDX module doesn't guarantee
@@ -750,10 +770,22 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	 */
 	WARN_ON_ONCE(force_immediate_exit);
 
+	if (WARN_ON_ONCE(tdx_guest_state_is_invalid(vcpu))) {
+		/*
+		 * Invalid exit_reason becomes KVM_EXIT_INTERNAL_ERROR, refer
+		 * tdx_handle_exit().
+		 */
+		tdx->vt.exit_reason.full = -1u;
+		tdx->vp_enter_ret = -1u;
+		return EXIT_FASTPATH_NONE;
+	}
+
 	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	tdx_vcpu_enter_exit(vcpu);
 
+	kvm_load_host_xsave_state(vcpu);
+
 	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
 
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
@@ -1878,9 +1910,23 @@ static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	return r;
 }
 
+static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
+{
+	u64 cr0 = ~CR0_RESERVED_BITS;
+
+	if (cr4 & X86_CR4_CET)
+		cr0 |= X86_CR0_WP;
+
+	cr0 |= X86_CR0_PE | X86_CR0_NE;
+	cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
+
+	return cr0;
+}
+
 static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
 	u64 apic_base;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int ret;
 
@@ -1903,6 +1949,20 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	if (ret)
 		return ret;
 
+	vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;
+	vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
+	/*
+	 * On return from VP.ENTER, the TDX Module sets XCR0 and XSS to the
+	 * maximal values supported by the guest, and zeroes PKRU, so from
+	 * KVM's perspective, those are the guest's values at all times.
+	 */
+	vcpu->arch.ia32_xss = kvm_tdx->xfam & TDX_XFAM_XSS_MASK;
+	vcpu->arch.xcr0 = kvm_tdx->xfam & TDX_XFAM_XCR0_MASK;
+	vcpu->arch.pkru = 0;
+
+	/* TODO: freeze vCPU model before kvm_update_cpuid_runtime() */
+	kvm_update_cpuid_runtime(vcpu);
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 
 	return 0;
-- 
2.43.0


