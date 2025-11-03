Return-Path: <kvm+bounces-61904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 270B8C2DA20
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 19:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F8F03BD8AA
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 18:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C452741B3;
	Mon,  3 Nov 2025 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mb7vhoWz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C026D239E97;
	Mon,  3 Nov 2025 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193928; cv=none; b=MabLYvAz51u3T05sVp7XzKySn3S0U9tHZhQ3HdJeVnRrwLZexblQrbh+ScM/QYIpyYaPXh3vFpbFDXX/Du3m9BvFAv2q44RNeD1Y6+hMe2gBLGxjP0EbA4mUD+e+AqOP2z97dHkgK82/w9vgkaQ0vUvj1ZNcww8u62Bb5o6BRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193928; c=relaxed/simple;
	bh=SrEyK8SJfOQkG4xF4hAGtuxRN3B7OPPK2EUDDpkgAdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szUQDhhqzD6UCRKLKNiTMnOToGIh9cSnddPVce+vMOBDtBAuccfS+RiD/0Me6Aa5KPLWkZUFZcKXnwXEAS0WiBNiShu1FfaY7XsHCBoVH4gChkrK26C7V4pbPnR5eMpFCBm6m7FOvgOGM5KnLd0OkCJs7377BCu/hX3HvtE/0Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mb7vhoWz; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762193927; x=1793729927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SrEyK8SJfOQkG4xF4hAGtuxRN3B7OPPK2EUDDpkgAdc=;
  b=Mb7vhoWzoUkdtwCWWL5pOGWF00KjD3bFPhkCkhTsqqNySOaSpJVB90b6
   vmK7rtlzLwPHKpro+8c+p9svRLAtHtaVAsd9CEXK3MwtD3l3h84nJIJov
   bCYPBXcRZb+FRzH0JnnMljl+Z6dVXihgz64T9Pp1gP87FqZzfJ8ivJYtQ
   IOtyTzs8DXHbwLL2rZgzEk9i+m/y2WkaPaxC/CtKOwOzsyOVwE3QlB0hy
   4aGRzGQ8VF76k8dy5R6I7EcyT/NYZsBS4D4vOIgtZl5uzmftLUrYeedQO
   nse/FoeJ7pLj6dX5jRsm7QrD8ymBMmiTbU+2F/DZOmaPMRXM+XACZueFb
   w==;
X-CSE-ConnectionGUID: nMxdZ+pQR1y7Q1rSJFmhVg==
X-CSE-MsgGUID: EBc5BHx4TQWLi1wetyqLZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="63974160"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="63974160"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 10:18:46 -0800
X-CSE-ConnectionGUID: ZqmnTnrCTfmHQk7wSr8Hvg==
X-CSE-MsgGUID: 7CAfQBm4TyuB4CJjO3WD3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="186623736"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 10:18:45 -0800
Date: Mon, 3 Nov 2025 10:18:40 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251103181840.kx3egw5fwgzpksu4@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-2-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:33PM -0700, Sean Christopherson wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> TSA mitigation:
> 
>   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
> 
> introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> (kernel->user also).
> 
> Make mitigations on Intel consistent with TSA. This would help handling the
> guest-only mitigations better in future.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> [sean: make CLEAR_CPU_BUF_VM mutually exclusive with the MMIO mitigation]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kernel/cpu/bugs.c | 9 +++++++--
>  arch/x86/kvm/vmx/vmenter.S | 2 +-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 6a526ae1fe99..723666a1357e 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -194,7 +194,7 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
>  
>  /*
>   * Controls CPU Fill buffer clear before VMenter. This is a subset of
> - * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
> + * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
>   * mitigation is required.
>   */
>  DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
> @@ -536,6 +536,7 @@ static void __init mds_apply_mitigation(void)
>  	if (mds_mitigation == MDS_MITIGATION_FULL ||
>  	    mds_mitigation == MDS_MITIGATION_VMWERV) {
>  		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
> +		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
>  		if (!boot_cpu_has(X86_BUG_MSBDS_ONLY) &&
>  		    (mds_nosmt || smt_mitigations == SMT_MITIGATIONS_ON))
>  			cpu_smt_disable(false);
> @@ -647,6 +648,7 @@ static void __init taa_apply_mitigation(void)
>  		 * present on host, enable the mitigation for UCODE_NEEDED as well.
>  		 */
>  		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
> +		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
>  
>  		if (taa_nosmt || smt_mitigations == SMT_MITIGATIONS_ON)
>  			cpu_smt_disable(false);
> @@ -748,6 +750,7 @@ static void __init mmio_apply_mitigation(void)
>  	 */
>  	if (verw_clear_cpu_buf_mitigation_selected) {
>  		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
> +		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
>  		static_branch_disable(&cpu_buf_vm_clear);
>  	} else {
>  		static_branch_enable(&cpu_buf_vm_clear);
> @@ -839,8 +842,10 @@ static void __init rfds_update_mitigation(void)
>  
>  static void __init rfds_apply_mitigation(void)
>  {
> -	if (rfds_mitigation == RFDS_MITIGATION_VERW)
> +	if (rfds_mitigation == RFDS_MITIGATION_VERW) {
>  		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
> +		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
> +	}
>  }
>  
>  static __init int rfds_parse_cmdline(char *str)
> diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> index bc255d709d8a..1f99a98a16a2 100644
> --- a/arch/x86/kvm/vmx/vmenter.S
> +++ b/arch/x86/kvm/vmx/vmenter.S
> @@ -161,7 +161,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
>  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
>  
>  	/* Clobbers EFLAGS.ZF */
> -	CLEAR_CPU_BUFFERS
> +	VM_CLEAR_CPU_BUFFERS
>  
>  	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
>  	jnc .Lvmlaunch
> -- 

Sean, based on Brendan's feedback, below are the fixes to the comments on
top of this patch:

---
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 08ed5a2e46a5..2be9be782013 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -321,9 +321,11 @@
 #endif
 .endm
 
+/* Primarily used in exit-to-userspace path */
 #define CLEAR_CPU_BUFFERS \
 	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
 
+/* For use in KVM */
 #define VM_CLEAR_CPU_BUFFERS \
 	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF_VM
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 723666a1357e..49d5797a2a42 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -490,7 +490,7 @@ static enum rfds_mitigations rfds_mitigation __ro_after_init =
 
 /*
  * Set if any of MDS/TAA/MMIO/RFDS are going to enable VERW clearing
- * through X86_FEATURE_CLEAR_CPU_BUF on kernel and guest entry.
+ * at userspace *and* guest entry.
  */
 static bool verw_clear_cpu_buf_mitigation_selected __ro_after_init;
 

