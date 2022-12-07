Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEA3646151
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 19:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiLGS4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 13:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLGS4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 13:56:05 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7017532FE;
        Wed,  7 Dec 2022 10:56:03 -0800 (PST)
Received: from zn.tnic (p200300ea9733e711329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e711:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 54ADC1EC0426;
        Wed,  7 Dec 2022 19:56:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670439362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=w/3sUk/0rfDRuqVgEsIw3ITuf0RQoY4ZUXxH88HqJ9A=;
        b=FRcXo6P1WXcDtzyF+tdgCucKnoo5G7CTBSrh1jzak3+i6ipLz7ffxEIkZwkEnfelNrqP2R
        054sS/PfrLqdrjogmm+N5+bc6rgxmeLUiWEkB2CuygYNLaRavmTBw6FXltMoPFxwXhkNXi
        Q+CsZIgDK/J76gYZweohlXECXomsKJE=
Date:   Wed, 7 Dec 2022 19:55:57 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Message-ID: <Y5DhvRZX0Aizu1ya@zn.tnic>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-2-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201021948.9259-2-aik@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 01:19:46PM +1100, Alexey Kardashevskiy wrote:
> Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu variables

"x86/amd: " is perfectly fine as a prefix.

> Reading DR[0-3]_ADDR_MASK MSRs takes about 250 cycles which is going to
> be noticeable when the AMD KVM SEV-ES's DebugSwap feature is enabled and

which does what? I.e., a sort of lazy DR regs swapping...

> KVM needs to store these before switching to a guest; the DebugSwitch
> hardware support restores them as type B swap.

I know this is all clear to you but you should explain what type B
register swap is.

> This stores MSR values from set_dr_addr_mask() in percpu values and

s/This stores/Store/

From Documentation/process/submitting-patches.rst:

 "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour."

Also, do not talk about what your patch does - that should hopefully be
visible in the diff itself. Rather, talk about *why* you're doing what
you're doing.

> returns them via new get_dr_addr_mask(). The gain here is about 10x.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  arch/x86/include/asm/debugreg.h |  1 +
>  arch/x86/kernel/cpu/amd.c       | 32 ++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> index cfdf307ddc01..c4324d0205b5 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -127,6 +127,7 @@ static __always_inline void local_db_restore(unsigned long dr7)
>  
>  #ifdef CONFIG_CPU_SUP_AMD
>  extern void set_dr_addr_mask(unsigned long mask, int dr);
> +extern unsigned long get_dr_addr_mask(int dr);
>  #else
>  static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
>  #endif
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index c75d75b9f11a..ec7efcef4e14 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1158,6 +1158,11 @@ static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
>  	return false;
>  }
>  
> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr0_addr_mask);
> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr1_addr_mask);
> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr2_addr_mask);
> +DEFINE_PER_CPU_READ_MOSTLY(unsigned long, dr3_addr_mask);

This BPEXT thing is AMD-only, right?

I guess those should be called amd_drX_addr_mask where X in [0-3].

Yeah yeah, they are used in AMD-only code - svm* - but still.

>  void set_dr_addr_mask(unsigned long mask, int dr)
>  {
>  	if (!boot_cpu_has(X86_FEATURE_BPEXT))
> @@ -1166,17 +1171,44 @@ void set_dr_addr_mask(unsigned long mask, int dr)
>  	switch (dr) {
>  	case 0:
>  		wrmsr(MSR_F16H_DR0_ADDR_MASK, mask, 0);
> +		per_cpu(dr0_addr_mask, smp_processor_id()) = mask;
>  		break;
>  	case 1:
> +		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
> +		per_cpu(dr1_addr_mask, smp_processor_id()) = mask;
> +		break;
>  	case 2:
> +		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
> +		per_cpu(dr2_addr_mask, smp_processor_id()) = mask;
> +		break;
>  	case 3:
>  		wrmsr(MSR_F16H_DR1_ADDR_MASK - 1 + dr, mask, 0);
> +		per_cpu(dr3_addr_mask, smp_processor_id()) = mask;
>  		break;
>  	default:
>  		break;
>  	}
>  }
>  
> +unsigned long get_dr_addr_mask(int dr)

This function name is too generic for an exported function.

amd_get_dr_addr_mask() I'd say.

> +	if (!boot_cpu_has(X86_FEATURE_BPEXT))

check_for_deprecated_apis: WARNING: arch/x86/kernel/cpu/amd.c:1195: Do not use boot_cpu_has() - use cpu_feature_enabled() instead.

You could fix the above one too, while at it.

> +		return 0;
> +
> +	switch (dr) {
> +	case 0:
> +		return per_cpu(dr0_addr_mask, smp_processor_id());
> +	case 1:
> +		return per_cpu(dr1_addr_mask, smp_processor_id());
> +	case 2:
> +		return per_cpu(dr2_addr_mask, smp_processor_id());
> +	case 3:
> +		return per_cpu(dr3_addr_mask, smp_processor_id());

	default:	
		WARN_ON_ONCE(1);
		break;

Just in case.

And as a matter of fact, make that short and succinct:

        switch (dr) {
        case 0: return per_cpu(dr0_addr_mask, smp_processor_id());
        case 1: return per_cpu(dr1_addr_mask, smp_processor_id());
        case 2: return per_cpu(dr2_addr_mask, smp_processor_id());
        case 3: return per_cpu(dr3_addr_mask, smp_processor_id());
        default: WARN_ON_ONCE(1); break;
        }

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
