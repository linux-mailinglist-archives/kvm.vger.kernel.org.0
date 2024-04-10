Return-Path: <kvm+bounces-14125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C5789FA17
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:39:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 350E2B2DEBE
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4358116D4D8;
	Wed, 10 Apr 2024 14:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7Es6lqT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2816E88C;
	Wed, 10 Apr 2024 14:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759726; cv=none; b=jGrzkWDUt48bnwODbth04akqWTmX4Eu97XiuVIJ4o2NIxx+HLOjUNBiGKRq+rLV53xDBJ/iozJNRZVTilaHf5Pzw2IfsEwXgHxCxkporIn2V/CC/54xP7A7gkMQqMkOfxIcGO81MRvR3jbd9qtbgH2OMxuiGabmBVOk5AvwNcFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759726; c=relaxed/simple;
	bh=gyZ9wRtB5eViadP4NCY6w/8MgIjA+6mKnlxGlnGXBWc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sqOrPur0w8PNd8DaMv+YQ51hxbhc/KVDhlN4mDoJXCZdRSQWXYnxmxpmIR+E79pwGoFiNv/KZHggEjYt+L/hGvhsDMvHjJevMmfR1g9T60HflduyFj59wJIUP354HFnozFefVg7fblKX8CIUM5XD+QbDoD3hs9k3yvL8bU6ionQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7Es6lqT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759725; x=1744295725;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gyZ9wRtB5eViadP4NCY6w/8MgIjA+6mKnlxGlnGXBWc=;
  b=T7Es6lqTQ1uk4bUX1yWUDSJ63Dn5mfjZNaGq9+VPUIlTKCSaprhU0eKP
   RMm8Ru6+SULGzYdo0FOA5J1NwsNYvQMo+gy3lqxsJYyf0j5Sa0e0naL6R
   d7Lgu+JvsxyBnvtuFHEYt5eQgWfzknw4OTuOjp5gwrB7qG6rMHdqTxc/x
   Pw+kcCy4RUVQLWaiTJjZIv6a7tanQf/0+2+FEhSS8+ldz88t+eih2d671
   o2umlTpomYbM2t+tM4KZ1qvje68XkDRkb4MuRCa99g+oQfTTLcEFaL540
   v/2PQCg8MnzHsI+4dD6BW4tpntXGGonBlm130MSdvxsGxrBz7lBDNjbsc
   w==;
X-CSE-ConnectionGUID: pCxRY7A7QmC5hgxspmoXFA==
X-CSE-MsgGUID: lhjutiiERQqXzuc6GoQ6fQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837761"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837761"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:25 -0700
X-CSE-ConnectionGUID: GNF/cqXIScSfPXR2Cr4FDg==
X-CSE-MsgGUID: PcZoryvtRB6NmJNLe1DrZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095497"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:21 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH v3 03/10] KVM: nVMX: Enable SPEC_CTRL virtualizaton for vmcs02
Date: Wed, 10 Apr 2024 22:34:31 +0800
Message-Id: <20240410143446.797262-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

to prevent nested guests from changing the SPEC_CTRL bits that userspace
doesn't allow a guest to change.

Propagate tertiary vm-exec controls from vmcs01 to vmcs02 and program
the mask of SPEC_CTRL MSRs as the userspace VMM requested.

With SPEC_CTRL virtualization enabled, guest will read from the shadow
value in VMCS. To ensure consistent view across nested VMX transitions,
propagate the shadow value between vmcs01 and vmcs02.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d05ddf751491..174790b2ffbc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2381,6 +2381,20 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 		secondary_exec_controls_set(vmx, exec_control);
 	}
 
+	/*
+	 * TERTIARY EXEC CONTROLS
+	 */
+	if (cpu_has_tertiary_exec_ctrls()) {
+		exec_control = __tertiary_exec_controls_get(vmcs01);
+
+		exec_control &= TERTIARY_EXEC_SPEC_CTRL_SHADOW;
+		if (exec_control & TERTIARY_EXEC_SPEC_CTRL_SHADOW)
+			vmcs_write64(IA32_SPEC_CTRL_MASK,
+				     vmx->vcpu.kvm->arch.force_spec_ctrl_mask);
+
+		tertiary_exec_controls_set(vmx, exec_control);
+	}
+
 	/*
 	 * ENTRY CONTROLS
 	 *
@@ -2625,6 +2639,19 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
 
+	/*
+	 * L2 after nested VM-entry should observe the same value of
+	 * IA32_SPEC_CTRL MSR as L1 unless:
+	 *	a. L1 loads IA32_SPEC_CTRL via MSR-load area.
+	 *	b. L1 enables IA32_SPEC_CTRL virtualization. this cannot
+	 *	   happen since KVM doesn't expose this feature to L1.
+	 *
+	 * Propagate spec_ctrl_shadow (the value guest will get via RDMSR)
+	 * to vmcs02. Later nested_vmx_load_msr() will take care of case a.
+	 */
+	if (vmx->nested.nested_run_pending && cpu_has_spec_ctrl_shadow())
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, vmx->spec_ctrl_shadow);
+
 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
 
 	if (nested_cpu_has_ept(vmcs12))
@@ -4883,6 +4910,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_update_cpu_dirty_logging(vcpu);
 	}
 
+	if (cpu_has_spec_ctrl_shadow())
+		vmcs_write64(IA32_SPEC_CTRL_SHADOW, vmx->spec_ctrl_shadow);
+
 	/* Unpin physical memory we referred to in vmcs02 */
 	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
 	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-- 
2.39.3


