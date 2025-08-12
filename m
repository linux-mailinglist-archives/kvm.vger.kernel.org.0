Return-Path: <kvm+bounces-54496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28742B21B2C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14115467544
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D824B2EA745;
	Tue, 12 Aug 2025 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XV3YqZH4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A52EA156;
	Tue, 12 Aug 2025 02:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967404; cv=none; b=n5/vItoyToSdHlmkMlzJVDxF21onetWX4HgsT3fMmusJQm/qEIX7xI5YhXxha+hYYttyzAlkGMEGaVevo87bxWYTquUs+MGVW5nPpn8ncWgwrugGmEv9S45Q5PlyWLSsuWAlUmPv6jyXOFKq20YeNPNX5KNojArqJnCIFiliYrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967404; c=relaxed/simple;
	bh=WWXmejuSNj1MrJ3JUYatoYWUto9PetsGoWxYgnZzpo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LALirT5Gw11nm2uxGsbqcSry68AjLcpdCqIjakb/zkNhzgpP3ehgmBQ45b4tLJCw7Hp78uDHG9ztMJwWOzM+COzntqyAN7xApLWGoRd5X2Q/50/p/+sSEFqtdZsZYX4vOpdLZVsAXof3Gzrtka8tQhuSjtAOvvN8QqPMHSuXCMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XV3YqZH4; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967403; x=1786503403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WWXmejuSNj1MrJ3JUYatoYWUto9PetsGoWxYgnZzpo0=;
  b=XV3YqZH40lv8MDAr4w+4rYrcBaycCMPeKRqKEh9C3hIT1ot7VFtRkwnK
   h+roaZGlZj9p/f4aw3RNe2upzifO7WY1zIMuM0NX1smP01tVF8OAfwpbp
   SyMYKNEn23RcTFzrOT/3c7Tzu0Y7/emMtJCJPFbHnlCirHIcXSiUj4Ct6
   WyiKrg9NWXJ/xtWpjlZtHfNPpweOAomK3UnyXktTqP7kJJ6hVdyCXBZ9t
   1det+DD1NEBuK9Ks1wQowHPmSBy0Os/WK3+qFQOMl1uhFwOEIysXT/zUC
   HIuNVSc155opscw4JXF2RQNguPb8c5yYQwq4F+70I6WeFSh/pL5StOup5
   Q==;
X-CSE-ConnectionGUID: o74QWlmtTny6sS1Wu5x++A==
X-CSE-MsgGUID: 5JH2vl8bSLqpkpQ127KV4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100670"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100670"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:43 -0700
X-CSE-ConnectionGUID: Z7MXRvTaRT2ixdXVUoUTdA==
X-CSE-MsgGUID: KP531+qoTKu8N9r3Ct92sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321376"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:42 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 24/24] KVM: nVMX: Add consistency checks for CET states
Date: Mon, 11 Aug 2025 19:55:32 -0700
Message-ID: <20250812025606.74625-25-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce consistency checks for CET states during nested VM-entry.

A VMCS contains both guest and host CET states, each comprising the
IA32_S_CET MSR, SSP, and IA32_INTERRUPT_SSP_TABLE_ADDR MSR. Various
checks are applied to CET states during VM-entry as documented in SDM
Vol3 Chapter "VM ENTRIES". Implement all these checks during nested
VM-entry to emulate the architectural behavior.

In summary, there are three kinds of checks on guest/host CET states
during VM-entry:

A. Checks applied to both guest states and host states:

 * The IA32_S_CET field must not set any reserved bits; bits 10 (SUPPRESS)
   and 11 (TRACKER) cannot both be set.
 * SSP should not have bits 1:0 set.
 * The IA32_INTERRUPT_SSP_TABLE_ADDR field must be canonical.

B. Checks applied to host states only

 * IA32_S_CET MSR and SSP must be canonical if the CPU enters 64-bit mode
   after VM-exit. Otherwise, IA32_S_CET and SSP must have their higher 32
   bits cleared.

C. Checks applied to guest states only:

 * IA32_S_CET MSR and SSP are not required to be canonical (i.e., 63:N-1
   are identical, where N is the CPU's maximum linear-address width). But,
   bits 63:N of SSP must be identical.

Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 47e413e56764..7c88fedc27c7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3104,6 +3104,17 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
 	return !__is_canonical_address(la, l1_address_bits_on_exit);
 }
 
+static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u64 ssp, u64 ssp_tbl)
+{
+	if (!is_cet_msr_valid(vcpu, s_cet) || !IS_ALIGNED(ssp, 4))
+		return false;
+
+	if (is_noncanonical_msr_address(ssp_tbl, vcpu))
+		return false;
+
+	return true;
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -3173,6 +3184,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE) {
+		if (CC(!is_valid_cet_state(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
+					   vmcs12->host_ssp_tbl)))
+			return -EINVAL;
+
+		/*
+		 * IA32_S_CET and SSP must be canonical if the host will
+		 * enter 64-bit mode after VM-exit; otherwise, higher
+		 * 32-bits must be all 0s.
+		 */
+		if (ia32e) {
+			if (CC(is_noncanonical_msr_address(vmcs12->host_s_cet, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ssp, vcpu)))
+				return -EINVAL;
+		} else {
+			if (CC(vmcs12->host_s_cet >> 32) || CC(vmcs12->host_ssp >> 32))
+				return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -3283,6 +3314,22 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
+		if (CC(!is_valid_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
+					   vmcs12->guest_ssp_tbl)))
+			return -EINVAL;
+
+		/*
+		 * Guest SSP must have 63:N bits identical, rather than
+		 * be canonical (i.e., 63:N-1 bits identical), where N is
+		 * the CPU's maximum linear-address width. Similar to
+		 * is_noncanonical_msr_address(), use the host's
+		 * linear-address width.
+		 */
+		if (CC(!__is_canonical_address(vmcs12->guest_ssp, max_host_virt_addr_bits() + 1)))
+			return -EINVAL;
+	}
+
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
-- 
2.47.1


