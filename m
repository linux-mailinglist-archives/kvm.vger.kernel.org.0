Return-Path: <kvm+bounces-35583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCDDCA1298D
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D99071889D84
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5CB1A8F7D;
	Wed, 15 Jan 2025 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LfERWS7T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F1C155C96;
	Wed, 15 Jan 2025 17:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736961256; cv=none; b=hnd+naIlaatz7i3z1eBbgAtxIglEH0Hq+abdcg5vueNhD/7jCRjWO+1Fcuu2wJQlPvFcpx2fioT1seDwrf1HvQsd378pda8BSRqi14Yi2ST8RN55zjb0+1jCOjA/7kAmimTeYLX3W3a4wnhJlIM1n5G6ZC+hLZ/jol7Hv50xTSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736961256; c=relaxed/simple;
	bh=9V4f+GgSVr8cFm5enDkmcjGmT6WT96bSBqA8ZFkiaLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbRUvS1CxW+Kg6MgzpzSt3F63qC0/5n0VM86nlcTYggcjDS+5yq2c2sAI24c+fyKqUWi/HnreMv0cU2OsCejZkizKgLbnqa7PjpSTCbDFUoh/jFwwP7uNODMaokXUbTaEJ/YSTtIqQ8bro5In4VGhAE1NJwz509dry0G9etSPRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LfERWS7T; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736961254; x=1768497254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9V4f+GgSVr8cFm5enDkmcjGmT6WT96bSBqA8ZFkiaLw=;
  b=LfERWS7TUju5NAtjT+33MS7BMl3QKhMsfKUYhh/RMYZr92yBibNcN/3H
   WykgpI8HGFLWOy775B+QCiGh7HOVC8no3shRpYZvXbFv7G/7sY1jnnnhB
   mWimdzYtGrqae89V6uu53LP9vdn7m9BEBYq3msvJh/a5jCHhg7LJfbbAE
   UWQ4RBEDTkxaxVEmpsKy65pFjOaIQoDmw38DFwN6KH5Kd1WeYWSEz7Vs+
   KQTzcKeJkRLIw8MLeYl8dZsE+E7kcTbkjyzAjP/HrS+XHAcM+X6XE7no5
   cK6CdkwAQEOaKYGzUZ0PCI1Ye65QFHjcv1P/dEv/XdxspuJgunMPoFEiV
   g==;
X-CSE-ConnectionGUID: zdtB19fGSke2d65MtkLz6A==
X-CSE-MsgGUID: GWTYY/gAR+SuWht7CFzsog==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="41243390"
X-IronPort-AV: E=Sophos;i="6.13,206,1732608000"; 
   d="scan'208";a="41243390"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 09:14:13 -0800
X-CSE-ConnectionGUID: pudNVkbtStWPuEe01Kt3mA==
X-CSE-MsgGUID: bPn7Nwm9SVGznJredPS3ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,206,1732608000"; 
   d="scan'208";a="105729523"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.246.16.163])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 09:14:10 -0800
Message-ID: <0c367e27-2b90-4b0a-ae1e-2f8a866bdd75@intel.com>
Date: Wed, 15 Jan 2025 19:14:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, rick.p.edgecombe@intel.com,
 dave.hansen@linux.intel.com, yan.y.zhao@intel.com
References: <20250115160912.617654-1-pbonzini@redhat.com>
 <20250115160912.617654-13-pbonzini@redhat.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20250115160912.617654-13-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/01/25 18:09, Paolo Bonzini wrote:
> From: Kai Huang <kai.huang@intel.com>
> 
> Intel TDX protects guest VM's from malicious host and certain physical
> attacks.  TDX introduces a new operation mode, Secure Arbitration Mode
> (SEAM) to isolate and protect guest VM's.  A TDX guest VM runs in SEAM and,
> unlike VMX, direct control and interaction with the guest by the host VMM
> is not possible.  Instead, Intel TDX Module, which also runs in SEAM,
> provides a SEAMCALL API.
> 
> The SEAMCALL that provides the ability to enter a guest is TDH.VP.ENTER.
> The TDX Module processes TDH.VP.ENTER, and enters the guest via VMX
> VMLAUNCH/VMRESUME instructions.  When a guest VM-exit requires host VMM
> interaction, the TDH.VP.ENTER SEAMCALL returns to the host VMM (KVM).
> 
> Add tdh_vp_enter() to wrap the SEAMCALL invocation of TDH.VP.ENTER.
> 
> TDH.VP.ENTER is different from other SEAMCALLS in several ways:
>  - it may take some time to return as the guest executes
>  - it uses more arguments
>  - after it returns some host state may need to be restored
> 
> TDH.VP.ENTER arguments are passed through General Purpose Registers (GPRs).
> For the special case of the TD guest invoking TDG.VP.VMCALL, nearly any GPR
> can be used, as well as XMM0 to XMM15. Notably, RBP is not used, and Linux
> mandates the TDX Module feature NO_RBP_MOD, which is enforced elsewhere.
> Additionally, XMM registers are not required for the existing Guest
> Hypervisor Communication Interface and are handled by existing KVM code
> should they be modified by the guest.
> 
> There are 2 input formats and 5 output formats for TDH.VP.ENTER arguments.
> Input #1 : Initial entry or following a previous async. TD Exit
> Input #2 : Following a previous TDCALL(TDG.VP.VMCALL)
> Output #1 : On Error (No TD Entry)
> Output #2 : Async. Exits with a VMX Architectural Exit Reason
> Output #3 : Async. Exits with a non-VMX TD Exit Status
> Output #4 : Async. Exits with Cross-TD Exit Details
> Output #5 : On TDCALL(TDG.VP.VMCALL)
> 
> Currently, to keep things simple, the wrapper function does not attempt
> to support different formats, and just passes all the GPRs that could be
> used.  The GPR values are held by KVM in the area set aside for guest
> GPRs.  KVM code uses the guest GPR area (vcpu->arch.regs[]) to set up for
> or process results of tdh_vp_enter().
> 
> Therefore changing tdh_vp_enter() to use more complex argument formats
> would also alter the way KVM code interacts with tdh_vp_enter().
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Message-ID: <20241121201448.36170-2-adrian.hunter@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/tdx.h  | 1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
>  arch/x86/virt/vmx/tdx/tdx.h | 1 +
>  3 files changed, 10 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 0c89afffdac4..6531b69a53ac 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -154,6 +154,7 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
>          return level - 1;
>  }
>  
> +u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
>  u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
>  u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
>  u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 55851a0591d2..bb6f8ef9661e 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1479,6 +1479,14 @@ static void tdx_clflush_page(struct page *page)
>  	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
>  }
>  
> +u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
> +{
> +	args->rcx = tdx_tdvpr_pa(td);
> +
> +	return __seamcall_saved_ret(TDH_VP_ENTER, args);
> +}
> +EXPORT_SYMBOL_GPL(tdh_vp_enter);
> +
>  u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
>  {
>  	struct tdx_module_args args = {
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 64932450aba3..b71b375b10c0 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -15,6 +15,7 @@
>  /*
>   * TDX module SEAMCALL leaf functions
>   */
> +#define TDH_VP_ENTER			0
>  #define TDH_MNG_ADDCX			1
>  #define TDH_MEM_PAGE_ADD		2
>  #define TDH_MEM_SEPT_ADD		3

FWIW I was planning to squash the noinstr change into this
patch, and amend the commit message accordingly, like so:

From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 15 Jan 2025 19:04:31 +0200
Subject: [PATCH] amend! x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX
 guest

x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest

Intel TDX protects guest VMs from malicious host and certain physical
attacks.  TDX introduces a new operation mode, Secure Arbitration Mode
(SEAM) to isolate and protect guest VMs.  A TDX guest VM runs in SEAM and,
unlike VMX, direct control and interaction with the guest by the host VMM
is not possible.  Instead, Intel TDX Module, which also runs in SEAM,
provides a SEAMCALL API.

The SEAMCALL that provides the ability to enter a guest is TDH.VP.ENTER.
The TDX Module processes TDH.VP.ENTER, and enters the guest via VMX
VMLAUNCH/VMRESUME instructions.  When a guest VM-exit requires host VMM
interaction, the TDH.VP.ENTER SEAMCALL returns to the host VMM (KVM).

Add tdh_vp_enter() to wrap the SEAMCALL invocation of TDH.VP.ENTER.

Make tdh_vp_enter() noinstr because KVM requires VM entry to be noinstr
for 2 reasons:
 1. The use of context tracking via guest_state_enter_irqoff() and
    guest_state_exit_irqoff()
 2. The need to avoid IRET between VM-exit and NMI handling in order to
    avoid prematurely releasing NMI inhibit.

Consequently make __seamcall_saved_ret() noinstr also. Note,
tdh_vp_enter() is the only caller of __seamcall_saved_ret().
Essentially, __seamcall_saved_ret() exists to serve the register passing
requirements of TDH.VP.ENTER SEAMCALL, and is unlikely to be used for
anything else.

TDH.VP.ENTER is different from other SEAMCALLS in several ways:
 - it may take some time to return as the guest executes
 - it uses more arguments
 - after it returns some host state may need to be restored

TDH.VP.ENTER arguments are passed through General Purpose Registers (GPRs).
For the special case of the TD guest invoking TDG.VP.VMCALL, nearly any GPR
can be used, as well as XMM0 to XMM15. Notably, RBP is not used, and Linux
mandates the TDX Module feature NO_RBP_MOD, which is enforced elsewhere.
Additionally, XMM registers are not required for the existing Guest
Hypervisor Communication Interface and are handled by existing KVM code
should they be modified by the guest.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/virt/vmx/tdx/seamcall.S | 3 +++
 arch/x86/virt/vmx/tdx/tdx.c      | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index 5b1f2286aea9..6854c52c374b 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -41,6 +41,9 @@ SYM_FUNC_START(__seamcall_ret)
 	TDX_MODULE_CALL host=1 ret=1
 SYM_FUNC_END(__seamcall_ret)
 
+/* KVM requires non-instrumentable __seamcall_saved_ret() for TDH.VP.ENTER */
+.section .noinstr.text, "ax"
+
 /*
  * __seamcall_saved_ret() - Host-side interface functions to SEAM software
  * (the P-SEAMLDR or the TDX module), with saving output registers to the
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index bb6f8ef9661e..c9c198e0b48c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1479,7 +1479,7 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
-u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
 {
 	args->rcx = tdx_tdvpr_pa(td);
 
-- 
2.43.0


