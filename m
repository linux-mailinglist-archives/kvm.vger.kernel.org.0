Return-Path: <kvm+bounces-61747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8387C27775
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 05:13:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F18918984A2
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 04:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBE22749ED;
	Sat,  1 Nov 2025 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nfvoobAY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F50434D38C;
	Sat,  1 Nov 2025 04:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761970414; cv=none; b=Pzvk/j4uMEx0vWIQsvIIXbmdMM4Dy6t2DeI6Ss9Aq0zifXzWc/lSfxxKfBe3m/ZHSAAdgVHCMIotie7N1ovrTdWQMMUPi9PrYN+xNZYlPgCp7XUYWKCZejKh/xu3DeUvw5NZiNiPJnxQk1X08uUpsJGv+4yAgA1EHuVnz7A9Y6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761970414; c=relaxed/simple;
	bh=t35qE8O/UY/ELx866Fdwau4Jjt6Z15dBhkoXwNVMAZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUj3S/fGjI+CD/pJ7KGkYhY+8PpVnbQk3/trBLYvR+OE2dtNYcCQBbAyD+V876QClD5fYxsIf0pIXmYAlGwCVvOWaGsVceMTehjX0dAJXW1toTVlgqtUjvPWoz35oLfkrcMmQKBkrnkmHKHwbeHkjs84pkXRRmDb+a7fRL/jqP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nfvoobAY; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761970413; x=1793506413;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t35qE8O/UY/ELx866Fdwau4Jjt6Z15dBhkoXwNVMAZM=;
  b=nfvoobAYrL8hxbguhP2pyCqN2NMi2lGDgFgYVtJg1DQYO93u3y9Y6laK
   Y5lAy9EC9kuObjkGxrCNaI8Yd4akX7zKIq9S/W+H3FLy/gsoQWwlz4Mpw
   cH2OY12Lc+sK9islKdzW8HAtEDBXTKW4JnSUVF/HvnWFRVMQ8YLyyN8Fs
   NlZDvmYbBX8QKAe+CxKG2pGGcXq1JjtC6e9P2j8jqnz/SfWUJz4r4KXbE
   0uo4vFCAjkJfenhK03jnICG5FZiwgU3GuFOQA4rLvYK/k3C+mIxWiQRCt
   hxT6BycDbDvPUrvjyn5qIuj3DTBS8lD24i0kEqw6BjU9UcIWdFMZA6LG3
   Q==;
X-CSE-ConnectionGUID: Fr4rjrdjTv6Km7zBeqD3kQ==
X-CSE-MsgGUID: fVP32eQEQFavEZ1JbQ+Oww==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64021236"
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="64021236"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 21:13:32 -0700
X-CSE-ConnectionGUID: F8W6k9wYQUqSLTeqMV2sKw==
X-CSE-MsgGUID: PBL7mAU0TWqCXqKw+PUYeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,271,1754982000"; 
   d="scan'208";a="190473603"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.220.87])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 21:13:31 -0700
Date: Fri, 31 Oct 2025 21:13:24 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 2/8] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
Message-ID: <20251101041324.k2crtjvwqaxhkasr@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-3-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:34PM -0700, Sean Christopherson wrote:
> Decouple the use of ALTERNATIVE from the encoding of VERW to clear CPU
> buffers so that KVM can use ALTERNATIVE_2 to handle "always clear buffers"
> and "clear if guest can access host MMIO" in a single statement.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/nospec-branch.h | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 08ed5a2e46a5..923ae21cbef1 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -308,24 +308,23 @@
>   * CFLAGS.ZF.
>   * Note: Only the memory operand variant of VERW clears the CPU buffers.
>   */
> -.macro __CLEAR_CPU_BUFFERS feature
>  #ifdef CONFIG_X86_64
> -	ALTERNATIVE "", "verw x86_verw_sel(%rip)", \feature
> +#define CLEAR_CPU_BUFFERS_SEQ	verw x86_verw_sel(%rip)
>  #else
> -	/*
> -	 * In 32bit mode, the memory operand must be a %cs reference. The data
> -	 * segments may not be usable (vm86 mode), and the stack segment may not
> -	 * be flat (ESPFIX32).
> -	 */
> -	ALTERNATIVE "", "verw %cs:x86_verw_sel", \feature
> +/*
> + * In 32bit mode, the memory operand must be a %cs reference. The data segments
> + * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
> + */
> +#define CLEAR_CPU_BUFFERS_SEQ	verw %cs:x86_verw_sel
>  #endif
> -.endm
> +
> +#define __CLEAR_CPU_BUFFERS	__stringify(CLEAR_CPU_BUFFERS_SEQ)
>  
>  #define CLEAR_CPU_BUFFERS \
> -	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF
> +	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
>  
>  #define VM_CLEAR_CPU_BUFFERS \
> -	__CLEAR_CPU_BUFFERS X86_FEATURE_CLEAR_CPU_BUF_VM
> +	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM

Sorry nitpicking, we have too many "CLEAR_CPU_BUF" in these macros, can we
avoid adding CLEAR_CPU_BUFFERS_SEQ?

Or better yet, can we name the actual instruction define to VERW_SEQ, so as
to differentiate it from the ALTERNATIVE defines?

---
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 4cf347732ec1..16b957382224 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -309,23 +309,21 @@
  * Note: Only the memory operand variant of VERW clears the CPU buffers.
  */
 #ifdef CONFIG_X86_64
-#define CLEAR_CPU_BUFFERS_SEQ	verw x86_verw_sel(%rip)
+#define VERW_SEQ	verw x86_verw_sel(%rip)
 #else
 /*
  * In 32bit mode, the memory operand must be a %cs reference. The data segments
  * may not be usable (vm86 mode), and the stack segment may not be flat (ESPFIX32).
  */
-#define CLEAR_CPU_BUFFERS_SEQ	verw %cs:x86_verw_sel
+#define VERW_SEQ	verw %cs:x86_verw_sel
 #endif
 
-#define __CLEAR_CPU_BUFFERS	__stringify(CLEAR_CPU_BUFFERS_SEQ)
-
 /* Primarily used in exit-to-userspace path */
 #define CLEAR_CPU_BUFFERS \
-	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF
+	ALTERNATIVE "", __stringify(VERW_SEQ), X86_FEATURE_CLEAR_CPU_BUF
 
 #define VM_CLEAR_CPU_BUFFERS \
-	ALTERNATIVE "", __CLEAR_CPU_BUFFERS, X86_FEATURE_CLEAR_CPU_BUF_VM
+	ALTERNATIVE "", __stringify(VERW_SEQ), X86_FEATURE_CLEAR_CPU_BUF_VM
 
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY

