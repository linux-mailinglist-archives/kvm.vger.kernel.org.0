Return-Path: <kvm+bounces-61431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E89DEC1D6E0
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:26:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D778B4E39F1
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D86319840;
	Wed, 29 Oct 2025 21:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZlqhFTNP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE73319619;
	Wed, 29 Oct 2025 21:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761773190; cv=none; b=GlbkRkuBmqlD9DyNmhhPPKV2N3KHef78vTibhy+mpQ9l9CR/2zcXK4PPaATXsyRF8qFQFki4UzqY8EZ4AMFIdAIp2EJnXxCmh/K6YitssvCtxRQYV/k2dKklDB+APRntiDpWGylNGq5UtLVc6tgXIIZ98qjkCSlNcsq52LD5JzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761773190; c=relaxed/simple;
	bh=4IEgxQ1JXqIDbvhxVeHf12Bor5YlJD2enTskwLRoQrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEUl8z7YoBaZzNgUOh8uW25HVfBGQX/DpOC7bcQc6OLrmO+DB9c7KdeAEqSnEsRDMVIgQ57SJimFu3DGFJXIPwqku2MrT66/63alTPiyjOtW3c6N1gYqYmHpdyzkchjNhBO+SIje93xuVMOzVrsO2UnOzVTxIos+6bLcA7941Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZlqhFTNP; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761773189; x=1793309189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4IEgxQ1JXqIDbvhxVeHf12Bor5YlJD2enTskwLRoQrM=;
  b=ZlqhFTNPxiHkPeknC3DqfL5x3mKBooyneBjYDL73RaXlb4BRtvK+Y+1Y
   Qg3Smte0yr/Sju9wPZl91jCOMYiQ2fh1ZImklOcPtEmQ4hRbhbymFmt+8
   sBN68XTOOprdk9UkwXQo5hCNsd7vjY5v4Zjw/UeF/0r2KV5BEhu+EB5tD
   ZGRRy4djTxtJfaDXPxNMFzFEmkFiZER3ECmmqG3xr1sox9w+hlSs7d4fA
   PQxDb5c/8CU7OrSX6bWloq6faZcl5grw+nblvJTnlVZQD06R9Z+lwL0PC
   lAhsMvTmTW++G51LeJkz/RWD6T8ZljvUXDjuzKYiUJYpV7M8wD018IRHz
   Q==;
X-CSE-ConnectionGUID: AE8RqPTRQ8CONUjWjXhW6g==
X-CSE-MsgGUID: E94ALB/mSLWpOc+1pUbdLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="62931386"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="62931386"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:26:28 -0700
X-CSE-ConnectionGUID: /eFhbi4PSZGtEyuiXhL7PQ==
X-CSE-MsgGUID: 8io2q75vTlCsa2k7QMIGEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="190908536"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:26:27 -0700
Date: Wed, 29 Oct 2025 14:26:26 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH 1/3] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251029-verw-vm-v1-1-babf9b961519@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>

TSA mitigation:

  d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")

introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
(kernel->user also).

Make mitigations on Intel consistent with TSA. This would help handling the
guest-only mitigations better in future.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 9 +++++++--
 arch/x86/kvm/vmx/vmenter.S | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b4517c12cc68e7c441f7589a4983d1..6d00a9ea7b4f28da291114a7a096b26cc129b57e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -194,7 +194,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
 /*
  * Controls CPU Fill buffer clear before VMenter. This is a subset of
- * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
+ * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
  * mitigation is required.
  */
 DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
@@ -536,6 +536,7 @@ static void __init mds_apply_mitigation(void)
 	if (mds_mitigation == MDS_MITIGATION_FULL ||
 	    mds_mitigation == MDS_MITIGATION_VMWERV) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 		if (!boot_cpu_has(X86_BUG_MSBDS_ONLY) &&
 		    (mds_nosmt || smt_mitigations == SMT_MITIGATIONS_ON))
 			cpu_smt_disable(false);
@@ -647,6 +648,7 @@ static void __init taa_apply_mitigation(void)
 		 * present on host, enable the mitigation for UCODE_NEEDED as well.
 		 */
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 
 		if (taa_nosmt || smt_mitigations == SMT_MITIGATIONS_ON)
 			cpu_smt_disable(false);
@@ -752,6 +754,7 @@ static void __init mmio_apply_mitigation(void)
 	} else {
 		static_branch_enable(&cpu_buf_vm_clear);
 	}
+	setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 
 	/*
 	 * If Processor-MMIO-Stale-Data bug is present and Fill Buffer data can
@@ -839,8 +842,10 @@ static void __init rfds_update_mitigation(void)
 
 static void __init rfds_apply_mitigation(void)
 {
-	if (rfds_mitigation == RFDS_MITIGATION_VERW)
+	if (rfds_mitigation == RFDS_MITIGATION_VERW) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
+		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
+	}
 }
 
 static __init int rfds_parse_cmdline(char *str)
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index bc255d709d8a16ae22b5bc401965d209a89a8692..0dd23beae207795484150698d1674dc4044cc520 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -161,7 +161,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
 	/* Clobbers EFLAGS.ZF */
-	CLEAR_CPU_BUFFERS
+	VM_CLEAR_CPU_BUFFERS
+.Lskip_clear_cpu_buffers:
 
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch

-- 
2.34.1



