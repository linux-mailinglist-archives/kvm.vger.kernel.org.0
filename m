Return-Path: <kvm+bounces-39451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED405A470E5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:22:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB3B516F1FE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894C81AF0D0;
	Thu, 27 Feb 2025 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jJydBdrD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590371487D1;
	Thu, 27 Feb 2025 01:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619173; cv=none; b=YTXlxL4SOFLh1cpRYLgVe2rhJM0K3qnhLDoC+ZhFSfkLVbZQMeg4Wz6UV45m6TmEnIJL2geWJfupSSiY2+zDH9B1nX29r3JcyUZb/APBNGaruiWi+tzEosaB42fpJTk3Zbuh2tVdK0y55J5x351RH0lO6WydMCpMG1JT30kJchM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619173; c=relaxed/simple;
	bh=RFuuXxLhAxJ8SSjFqPETXY9iTs1K4e+otykdJV4ex5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3M95z78pSBKuWz6CY2GHUd5MZVXSG6rVyAogyeJgx+J74F0gm0vkBNhGBuXrWeo7yrV66VbAMnEpkl5JYuBYA8fNT6W5TVS+wTZSd8gAENdeByNf0p5ljSWekqyCSZ6mxIAdv1YVVTrDs3xQEK4D5RCnoE952CbM1fc0TH19PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jJydBdrD; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619172; x=1772155172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RFuuXxLhAxJ8SSjFqPETXY9iTs1K4e+otykdJV4ex5w=;
  b=jJydBdrDzmZLcTv8GleIAAAnga8K4bGpvfdiuB2o6KE2nYs+1LH0Qvss
   wR/qX2nO/vmDhmRxj/mgyPC5lqFagLnw1d2uy7/jg2GIUtW4rzlcWhw+5
   uG8qpJWsnAy8Ix36XiqQLExWT4Y9WCYADv8oM78+hDIZNc6uaDnt+aCRh
   i965VXs7QkFAU8AzMIYxUYQ40/zzKpCY58rJBpJcUEGUPfIkPkMvL8ZG5
   Fy3J1kF7Evsw8onZ6c/LFH+7Nmr8SjUbJjWdfv1n+Ww1yVxVj0wZZ9lgp
   CYFxXejhMLyVW1okfUveaXbmGr0iUmBwsSpmVRB5MCtPZVDqX4RtO8/t9
   A==;
X-CSE-ConnectionGUID: CuFk5ddbRCGnDDH9fOzQ4g==
X-CSE-MsgGUID: kZZ5qlmCSA+taPr0TinM3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959644"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959644"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:32 -0800
X-CSE-ConnectionGUID: 3jdzHrL+TiOMnWAEY/9saA==
X-CSE-MsgGUID: eDhEubT4RrOkLxVAQu63NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674913"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:28 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 13/20] KVM: TDX: Add method to ignore guest instruction emulation
Date: Thu, 27 Feb 2025 09:20:14 +0800
Message-ID: <20250227012021.1778144-14-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Skip instruction emulation and let the TDX guest retry for MMIO emulation
after installing the MMIO SPTE with suppress #VE bit cleared.

TDX protects TDX guest state from VMM, instructions in guest memory cannot
be emulated.  MMIO emulation is the only case that triggers the instruction
emulation code path for TDX guest.

The MMIO emulation handling flow as following:
- The TDX guest issues a vMMIO instruction. (The GPA must be shared and is
  not covered by KVM memory slot.)
- The default SPTE entry for shared-EPT by KVM has suppress #VE bit set. So
  EPT violation causes TD exit to KVM.
- Trigger KVM page fault handler and install a new SPTE with suppress #VE
  bit cleared.
- Skip instruction emulation and return X86EMU_RETRY_INSTR to let the vCPU
  retry.
- TDX guest re-executes the vMMIO instruction.
- TDX guest gets #VE because KVM has cleared #VE suppress bit.
- TDX guest #VE handler converts MMIO into TDG.VP.VMCALL<MMIO>

Return X86EMU_RETRY_INSTR in the callback check_emulate_instruction() for
TDX guests to retry the MMIO instruction.  Also, the instruction emulation
handling will be skipped, so that the callback check_intercept() will never
be called for TDX guest.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No change.

TDX "the rest" v1:
- Dropped vt_check_intercept().
- Add a comment in vt_check_emulate_instruction().
- Update the changelog.
---
 arch/x86/kvm/vmx/main.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index b76f39cc56fb..035c3ed263b7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -278,6 +278,22 @@ static void vt_enable_smi_window(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static int vt_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len)
+{
+	/*
+	 * For TDX, this can only be triggered for MMIO emulation.  Let the
+	 * guest retry after installing the SPTE with suppress #VE bit cleared,
+	 * so that the guest will receive #VE when retry.  The guest is expected
+	 * to call TDG.VP.VMCALL<MMIO> to request VMM to do MMIO emulation on
+	 * #VE.
+	 */
+	if (is_td_vcpu(vcpu))
+		return X86EMUL_RETRY_INSTR;
+
+	return vmx_check_emulate_instruction(vcpu, emul_type, insn, insn_len);
+}
+
 static bool vt_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -938,7 +954,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.enable_smi_window = vt_enable_smi_window,
 #endif
 
-	.check_emulate_instruction = vmx_check_emulate_instruction,
+	.check_emulate_instruction = vt_check_emulate_instruction,
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-- 
2.46.0


